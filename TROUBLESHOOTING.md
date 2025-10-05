# Troubleshooting Guide

## "Failed to create user: Database error creating new user"

This error typically occurs due to database constraint violations during user creation. Here's how to fix it:

### **Step 1: Check Your Database Schema**

1. Go to your Supabase Dashboard
2. Navigate to **SQL Editor**
3. Run this query to check if the schema was created correctly:

```sql
-- Check if tables exist
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('profiles', 'events', 'applications');

-- Check if the handle_new_user function exists
SELECT routine_name FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name = 'handle_new_user';

-- Check if the trigger exists
SELECT trigger_name FROM information_schema.triggers 
WHERE trigger_schema = 'public' 
AND trigger_name = 'on_auth_user_created';
```

### **Step 2: Fix Database Constraints**

If the schema exists but you're still getting errors, run the fix script:

1. Copy the contents of `simple-database-fix.sql`
2. Paste it into your Supabase SQL Editor
3. Click **Run**

### **Step 3: Test User Creation**

After running the fix, test user creation:

1. **Option A: Through Supabase Dashboard**
   - Go to Authentication > Users
   - Click "Add user"
   - Create a test user with email `test@example.com`
   - Check if a profile was created automatically

2. **Option B: Through Application**
   - Start your dev server: `npm run dev`
   - Go to `/register`
   - Try creating a new account

### **Step 4: Debug Further**

If you're still getting errors, check the Supabase logs:

1. Go to **Logs** in your Supabase dashboard
2. Look for any error messages related to user creation
3. Check the **Database** logs for constraint violations

### **Common Issues and Solutions**

#### **Issue 1: Constraint Violation**
```
ERROR: new row for relation "profiles" violates check constraint
```
**Solution:** Run the `simple-database-fix.sql` script

#### **Issue 2: Function Not Found**
```
ERROR: function public.handle_new_user() does not exist
```
**Solution:** The database schema wasn't run properly. Re-run `database-schema.sql`

#### **Issue 3: Trigger Not Working**
```
ERROR: trigger "on_auth_user_created" does not exist
```
**Solution:** Re-run the database schema and fix scripts

#### **Issue 4: RLS Policy Issues**
```
ERROR: new row violates row-level security policy
```
**Solution:** Check that RLS policies are set up correctly in the schema

### **Step 5: Manual Profile Creation (Fallback)**

If automatic profile creation still doesn't work, you can create profiles manually:

1. Create a user through Supabase Dashboard
2. Note the user ID
3. Manually insert a profile:

```sql
-- Replace 'USER_ID_HERE' with the actual user ID
INSERT INTO profiles (id, user_type, first_name, last_name, age, organization_name)
VALUES (
    'USER_ID_HERE',
    'participant',  -- or 'organization'
    'Test',
    'User',
    25,  -- only for participants
    NULL  -- only for organizations
);
```

### **Step 6: Verify Everything Works**

Run these queries to verify the setup:

```sql
-- Check users and their profiles
SELECT 
    u.email,
    p.user_type,
    p.first_name,
    p.last_name,
    p.organization_name
FROM auth.users u
LEFT JOIN profiles p ON u.id = p.id;

-- Check if events table is accessible
SELECT COUNT(*) FROM events;

-- Check if applications table is accessible  
SELECT COUNT(*) FROM applications;
```

### **Still Having Issues?**

If you're still experiencing problems:

1. **Check Supabase Status**: Visit [status.supabase.com](https://status.supabase.com)
2. **Verify Environment Variables**: Make sure your `.env.local` has the correct Supabase URL and key
3. **Check Network**: Ensure your application can connect to Supabase
4. **Review Logs**: Check both application logs and Supabase logs for detailed error messages

### **Reset Everything (Nuclear Option)**

If nothing else works, you can reset your database:

1. Go to **Settings > Database** in Supabase
2. Click **Reset Database** (⚠️ This will delete all data)
3. Re-run the `database-schema.sql` script
4. Re-run the `simple-database-fix.sql` script
5. Test user creation again
