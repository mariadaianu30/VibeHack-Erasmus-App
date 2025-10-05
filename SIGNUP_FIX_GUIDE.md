# Fix Supabase Signup 500 Error

## 🚨 **Problem Identified**
You're getting a `500 Internal Server Error` when users try to sign up because the database trigger `handle_new_user()` is failing.

## 🔧 **Solution Steps**

### Step 1: Run the Database Fix Script
1. Go to your Supabase Dashboard
2. Navigate to **SQL Editor**
3. Copy and paste the contents of `fix-signup-error.sql`
4. Click **Run** to execute the script

### Step 2: Verify the Fix
After running the script, test the signup process again.

## 🐛 **Root Cause Analysis**
The issue is caused by one or more of these problems:

1. **Strict Database Constraints**: The `profiles` table has NOT NULL constraints that prevent user creation
2. **Failing Trigger Function**: The `handle_new_user()` function is throwing errors
3. **Data Type Mismatches**: The trigger is trying to insert invalid data types
4. **Missing Default Values**: Required fields don't have fallback values

## 🛠️ **What the Fix Does**

1. **Removes All Problematic Constraints**: Temporarily removes strict NOT NULL constraints
2. **Creates a Robust Trigger**: New `handle_new_user()` function with error handling
3. **Makes Fields Nullable**: Allows user creation with minimal data
4. **Adds Error Recovery**: If the main insert fails, creates a basic profile
5. **Simplifies Constraints**: Only adds essential, permissive constraints

## 🧪 **Testing the Fix**

After applying the fix, you can test with:

```bash
node test-signup.js
```

Or test directly in your application by:
1. Going to `/register`
2. Filling out the form
3. Submitting the registration

## 📋 **Expected Results**

After the fix:
- ✅ User signup should work without 500 errors
- ✅ Basic profile will be created automatically
- ✅ Users can complete their profile later
- ✅ No more "Database error saving new user" messages

## 🔍 **If Issues Persist**

If you still get errors after running the fix:

1. **Check Supabase Logs**: Go to Supabase Dashboard → Logs → Auth
2. **Verify Email Settings**: Check if email confirmation is required
3. **Check RLS Policies**: Ensure Row Level Security isn't blocking inserts
4. **Test with Supabase Dashboard**: Try creating a user directly in the Auth section

## 📞 **Need Help?**

If the issue persists, check:
- Supabase project status
- Database connection limits
- Email service configuration
- RLS policies on the profiles table
