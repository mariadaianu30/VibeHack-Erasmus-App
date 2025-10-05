-- Event Platform Database Schema
-- Run this script in your Supabase SQL Editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE user_type AS ENUM ('participant', 'organization');
CREATE TYPE application_status AS ENUM ('pending', 'accepted', 'rejected');

-- Create profiles table
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_type user_type NOT NULL,
    
    -- Common fields
    first_name TEXT,
    last_name TEXT,
    bio TEXT,
    location TEXT,
    
    -- Participant-specific fields
    age INTEGER CHECK (age >= 13 AND age <= 100),
    
    -- Organization-specific fields
    organization_name TEXT,
    website TEXT,
    
    -- Constraints
    CONSTRAINT profiles_participant_check CHECK (
        (user_type = 'participant' AND age IS NOT NULL) OR 
        (user_type = 'organization' AND organization_name IS NOT NULL)
    ),
    
    CONSTRAINT profiles_name_check CHECK (
        (user_type = 'participant' AND first_name IS NOT NULL AND last_name IS NOT NULL) OR
        (user_type = 'organization' AND organization_name IS NOT NULL)
    )
);

-- Create events table
CREATE TABLE events (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    title TEXT NOT NULL CHECK (LENGTH(title) >= 3 AND LENGTH(title) <= 200),
    description TEXT NOT NULL CHECK (LENGTH(description) >= 10 AND LENGTH(description) <= 2000),
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    location TEXT NOT NULL CHECK (LENGTH(location) >= 3 AND LENGTH(location) <= 200),
    max_participants INTEGER NOT NULL CHECK (max_participants > 0 AND max_participants <= 1000),
    category TEXT NOT NULL CHECK (LENGTH(category) >= 2 AND LENGTH(category) <= 50),
    organization_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    is_published BOOLEAN DEFAULT false,
    
    -- Constraints
    CONSTRAINT events_date_check CHECK (end_date > start_date),
    CONSTRAINT events_future_check CHECK (start_date > NOW())
);

-- Create applications table
CREATE TABLE applications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    event_id UUID REFERENCES events(id) ON DELETE CASCADE NOT NULL,
    participant_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    motivation_letter TEXT NOT NULL CHECK (LENGTH(motivation_letter) >= 200 AND LENGTH(motivation_letter) <= 2000),
    status application_status DEFAULT 'pending',
    
    -- Ensure one application per participant per event
    UNIQUE(event_id, participant_id)
);

-- Create indexes for performance
CREATE INDEX idx_profiles_user_type ON profiles(user_type);
CREATE INDEX idx_profiles_organization_name ON profiles(organization_name) WHERE user_type = 'organization';
CREATE INDEX idx_profiles_location ON profiles(location);

CREATE INDEX idx_events_organization_id ON events(organization_id);
CREATE INDEX idx_events_start_date ON events(start_date);
CREATE INDEX idx_events_end_date ON events(end_date);
CREATE INDEX idx_events_category ON events(category);
CREATE INDEX idx_events_is_published ON events(is_published);
CREATE INDEX idx_events_date_range ON events(start_date, end_date);

CREATE INDEX idx_applications_event_id ON applications(event_id);
CREATE INDEX idx_applications_participant_id ON applications(participant_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_created_at ON applications(created_at);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at 
    BEFORE UPDATE ON events 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_applications_updated_at 
    BEFORE UPDATE ON applications 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles table
-- Users can view all profiles
CREATE POLICY "Profiles are viewable by everyone" ON profiles
    FOR SELECT USING (true);

-- Users can only update their own profile
CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- RLS Policies for events table
-- Everyone can view published events
CREATE POLICY "Published events are viewable by everyone" ON events
    FOR SELECT USING (is_published = true);

-- Organizations can view their own events (published or not)
CREATE POLICY "Organizations can view own events" ON events
    FOR SELECT USING (
        auth.uid() = organization_id
    );

-- Organizations can insert their own events
CREATE POLICY "Organizations can insert own events" ON events
    FOR INSERT WITH CHECK (
        auth.uid() = organization_id AND
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND user_type = 'organization'
        )
    );

-- Organizations can update their own events
CREATE POLICY "Organizations can update own events" ON events
    FOR UPDATE USING (
        auth.uid() = organization_id
    );

-- Organizations can delete their own events
CREATE POLICY "Organizations can delete own events" ON events
    FOR DELETE USING (
        auth.uid() = organization_id
    );

-- RLS Policies for applications table
-- Participants can view their own applications
CREATE POLICY "Participants can view own applications" ON applications
    FOR SELECT USING (auth.uid() = participant_id);

-- Organizations can view applications to their events
CREATE POLICY "Organizations can view applications to their events" ON applications
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM events 
            WHERE id = event_id AND organization_id = auth.uid()
        )
    );

-- Participants can insert applications to events
CREATE POLICY "Participants can apply to events" ON applications
    FOR INSERT WITH CHECK (
        auth.uid() = participant_id AND
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() AND user_type = 'participant'
        ) AND
        EXISTS (
            SELECT 1 FROM events 
            WHERE id = event_id AND is_published = true
        )
    );

-- Organizations can update application status for their events
CREATE POLICY "Organizations can update application status" ON applications
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM events 
            WHERE id = event_id AND organization_id = auth.uid()
        )
    );

-- Create a function to handle new user profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, user_type, first_name, last_name)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'user_type', 'participant')::user_type,
        COALESCE(NEW.raw_user_meta_data->>'first_name', ''),
        COALESCE(NEW.raw_user_meta_data->>'last_name', '')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user profile creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create a function to get event statistics
CREATE OR REPLACE FUNCTION get_event_stats(event_uuid UUID)
RETURNS TABLE (
    total_applications BIGINT,
    pending_applications BIGINT,
    accepted_applications BIGINT,
    rejected_applications BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_applications,
        COUNT(*) FILTER (WHERE status = 'pending') as pending_applications,
        COUNT(*) FILTER (WHERE status = 'accepted') as accepted_applications,
        COUNT(*) FILTER (WHERE status = 'rejected') as rejected_applications
    FROM applications
    WHERE event_id = event_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a function to get user's application count
CREATE OR REPLACE FUNCTION get_user_application_stats(user_uuid UUID)
RETURNS TABLE (
    total_applications BIGINT,
    pending_applications BIGINT,
    accepted_applications BIGINT,
    rejected_applications BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_applications,
        COUNT(*) FILTER (WHERE status = 'pending') as pending_applications,
        COUNT(*) FILTER (WHERE status = 'accepted') as accepted_applications,
        COUNT(*) FILTER (WHERE status = 'rejected') as rejected_applications
    FROM applications
    WHERE participant_id = user_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
