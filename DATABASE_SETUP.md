# Database Setup Guide

## Step 1: Run the Database Schema
1. Go to your Supabase Dashboard
2. Navigate to **SQL Editor**
3. Copy and paste the contents of `database-schema.sql`
4. Click **Run** to execute the script

## Step 2: Create Test Users (Choose One Option)

### Option A: Create Users Through Supabase Dashboard (Quick)
1. Go to **Authentication > Users** in your Supabase dashboard
2. Click **Add user** and create these test users:

**Organizations:**
- Email: `org1@example.com`, Password: `password123`
- Email: `org2@example.com`, Password: `password123`
- Email: `org3@example.com`, Password: `password123`

**Participants:**
- Email: `alice@example.com`, Password: `password123`
- Email: `bob@example.com`, Password: `password123`
- Email: `carol@example.com`, Password: `password123`

### Option B: Create Users Through the Application (Recommended)
1. Start your development server: `npm run dev`
2. Navigate to `http://localhost:3000/register`
3. Create accounts with the emails above
4. Select "Organization" or "Participant" as user type

## Step 3: Update User Profiles
After creating users, you need to update their profiles to have proper data:

1. Go to **Table Editor > profiles** in your Supabase dashboard
2. For each user, update their profile with appropriate data:

**For Organizations:**
- Set `organization_name`, `bio`, `location`, `website`
- Leave `first_name`, `last_name`, `age` as NULL

**For Participants:**
- Set `first_name`, `last_name`, `age`, `bio`, `location`
- Leave `organization_name`, `website` as NULL

## Step 4: Create Sample Events
1. In SQL Editor, run the `setup-sample-events.sql` script
2. Find an organization user ID: `SELECT id FROM auth.users WHERE email = 'org1@example.com';`
3. Create sample events: `SELECT create_sample_events('your-org-user-id-here');`

## Step 5: Create Sample Applications (Optional)
1. Find a participant user ID: `SELECT id FROM auth.users WHERE email = 'alice@example.com';`
2. Create sample applications: `SELECT create_sample_applications('your-participant-user-id-here');`

## Verification
Run these queries to verify everything is set up correctly:

```sql
-- Check users and profiles
SELECT u.email, p.user_type, p.first_name, p.last_name, p.organization_name 
FROM auth.users u 
LEFT JOIN profiles p ON u.id = p.id;

-- Check events
SELECT title, category, is_published, organization_id 
FROM events;

-- Check applications
SELECT a.status, e.title, p.first_name 
FROM applications a
JOIN events e ON a.event_id = e.id
JOIN profiles p ON a.participant_id = p.id;
```

## Troubleshooting

### Foreign Key Constraint Error
If you get a foreign key constraint error, it means you're trying to insert profiles for users that don't exist in `auth.users`. Make sure to create users first through the Supabase dashboard or the application.

### RLS Policy Errors
If you get RLS policy errors, make sure you're running queries as an authenticated user or with the service role key.

### Missing Profile Data
If profiles are missing data, update them manually in the Table Editor or through the application interface.
