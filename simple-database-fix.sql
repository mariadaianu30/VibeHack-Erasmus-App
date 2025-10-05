-- Simple Database Fix for User Creation Issues
-- Run this script to fix the user creation problems

-- Step 1: Drop the problematic constraints temporarily
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_participant_check;
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_name_check;

-- Step 2: Create a much simpler handle_new_user function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Create a basic profile with minimal data
    -- The user will complete their profile through the application
    INSERT INTO public.profiles (id, user_type, first_name, last_name, age, organization_name)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'user_type', 'participant')::user_type,
        COALESCE(NEW.raw_user_meta_data->>'first_name', 'New'),
        COALESCE(NEW.raw_user_meta_data->>'last_name', 'User'),
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

-- Step 3: Recreate the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Step 4: Add back some basic constraints (but more flexible)
ALTER TABLE profiles ADD CONSTRAINT profiles_user_type_not_null CHECK (user_type IS NOT NULL);
ALTER TABLE profiles ADD CONSTRAINT profiles_participant_age_check CHECK (
    user_type != 'participant' OR (age IS NOT NULL AND age >= 13 AND age <= 100)
);
ALTER TABLE profiles ADD CONSTRAINT profiles_organization_name_check CHECK (
    user_type != 'organization' OR organization_name IS NOT NULL
);

-- Step 5: Test the fix by checking if the function works
-- You can test this by creating a user through the Supabase dashboard
-- or through the application
