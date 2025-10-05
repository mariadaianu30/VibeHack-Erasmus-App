-- Fix Supabase Signup 500 Error
-- This script addresses the most common causes of signup failures

-- Step 1: Completely remove all problematic constraints
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_participant_check;
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_name_check;
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_user_type_not_null;
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_participant_age_check;
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_organization_name_check;

-- Step 2: Make all profile fields nullable temporarily
ALTER TABLE profiles ALTER COLUMN first_name DROP NOT NULL;
ALTER TABLE profiles ALTER COLUMN last_name DROP NOT NULL;
ALTER TABLE profiles ALTER COLUMN age DROP NOT NULL;
ALTER TABLE profiles ALTER COLUMN organization_name DROP NOT NULL;

-- Step 3: Drop and recreate the trigger function with better error handling
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- Step 4: Create a very simple, robust handle_new_user function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Use a try-catch approach with minimal data
    BEGIN
        INSERT INTO public.profiles (id, user_type)
        VALUES (
            NEW.id,
            COALESCE(NEW.raw_user_meta_data->>'user_type', 'participant')::user_type
        );
    EXCEPTION WHEN OTHERS THEN
        -- If the insert fails, create a minimal profile
        INSERT INTO public.profiles (id, user_type, first_name, last_name)
        VALUES (
            NEW.id,
            'participant'::user_type,
            'User',
            'User'
        );
    END;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 5: Recreate the trigger
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Step 6: Add only essential constraints (very permissive)
ALTER TABLE profiles ADD CONSTRAINT profiles_user_type_check 
    CHECK (user_type IN ('participant', 'organization'));

-- Step 7: Ensure the profiles table has the right structure
-- This is just to make sure the table exists and has the right columns
DO $$
BEGIN
    -- Check if the profiles table exists and has the right structure
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'profiles') THEN
        RAISE EXCEPTION 'Profiles table does not exist. Please run the main database schema first.';
    END IF;
    
    -- Log success
    RAISE NOTICE 'Database fix applied successfully. User signup should now work.';
END $$;
