-- Fix Database Constraints for User Creation
-- Run this script to fix the constraint issues

-- First, let's drop the problematic constraints
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_participant_check;
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_name_check;

-- Create more flexible constraints that work with the handle_new_user function
ALTER TABLE profiles ADD CONSTRAINT profiles_participant_check_new CHECK (
    (user_type = 'participant' AND age IS NOT NULL AND first_name IS NOT NULL AND last_name IS NOT NULL) OR 
    (user_type = 'organization' AND organization_name IS NOT NULL)
);

-- Update the handle_new_user function to be more flexible
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert profile with minimal required data
    -- The user will complete their profile later through the application
    INSERT INTO public.profiles (id, user_type, first_name, last_name, age, organization_name)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'user_type', 'participant')::user_type,
        COALESCE(NEW.raw_user_meta_data->>'first_name', ''),
        COALESCE(NEW.raw_user_meta_data->>'last_name', ''),
        CASE 
            WHEN COALESCE(NEW.raw_user_meta_data->>'user_type', 'participant') = 'participant' 
            THEN COALESCE((NEW.raw_user_meta_data->>'age')::INTEGER, 18)
            ELSE NULL 
        END,
        CASE 
            WHEN COALESCE(NEW.raw_user_meta_data->>'user_type', 'participant') = 'organization' 
            THEN COALESCE(NEW.raw_user_meta_data->>'organization_name', 'New Organization')
            ELSE NULL 
        END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Alternative: Create a simpler version that just creates the profile
-- and lets the user complete it through the application
CREATE OR REPLACE FUNCTION public.handle_new_user_simple()
RETURNS TRIGGER AS $$
BEGIN
    -- Create a basic profile that the user can complete later
    INSERT INTO public.profiles (id, user_type, first_name, last_name)
    VALUES (
        NEW.id,
        'participant'::user_type,  -- Default to participant
        'New',  -- Temporary first name
        'User', -- Temporary last name
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- If you want to use the simpler version, run this:
-- DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
-- CREATE TRIGGER on_auth_user_created
--     AFTER INSERT ON auth.users
--     FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_simple();
