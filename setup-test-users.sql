-- Setup Test Users for Event Platform
-- This script creates test users in the auth system and their corresponding profiles
-- Run this AFTER running the database-schema.sql

-- Note: In Supabase, you cannot directly insert into auth.users via SQL
-- Instead, you need to create users through the Supabase Auth API or Dashboard
-- This script provides the profile data that will be created automatically
-- when users sign up through the application

-- For testing purposes, you have two options:

-- OPTION 1: Create users through Supabase Dashboard
-- 1. Go to Authentication > Users in your Supabase dashboard
-- 2. Click "Add user" and create these test users:
--    - Email: alice@example.com, Password: password123
--    - Email: bob@example.com, Password: password123  
--    - Email: carol@example.com, Password: password123
--    - Email: david@example.com, Password: password123
--    - Email: emma@example.com, Password: password123
--    - Email: org1@example.com, Password: password123
--    - Email: org2@example.com, Password: password123
--    - Email: org3@example.com, Password: password123

-- OPTION 2: Use the application to create users (recommended)
-- Simply run the application and create accounts through the registration form
-- The handle_new_user() function will automatically create profiles

-- If you want to manually create profiles for existing users, 
-- you can run this script (replace the UUIDs with actual user IDs from auth.users):

/*
-- Sample Organizations (replace UUIDs with actual user IDs)
INSERT INTO profiles (id, user_type, organization_name, bio, location, website) VALUES
('REPLACE_WITH_ACTUAL_USER_ID_1', 'organization', 'Tech Innovators', 'Leading technology company focused on innovation and community building.', 'San Francisco, CA', 'https://techinnovators.com'),
('REPLACE_WITH_ACTUAL_USER_ID_2', 'organization', 'Green Future', 'Environmental organization dedicated to sustainable living and eco-friendly practices.', 'Portland, OR', 'https://greenfuture.org'),
('REPLACE_WITH_ACTUAL_USER_ID_3', 'organization', 'Creative Hub', 'Community space for artists, designers, and creative professionals.', 'Brooklyn, NY', 'https://creativehub.nyc');

-- Sample Participants (replace UUIDs with actual user IDs)
INSERT INTO profiles (id, user_type, first_name, last_name, age, bio, location) VALUES
('REPLACE_WITH_ACTUAL_USER_ID_4', 'participant', 'Alice', 'Johnson', 25, 'Passionate about technology and community building. Love attending tech meetups and hackathons.', 'San Francisco, CA'),
('REPLACE_WITH_ACTUAL_USER_ID_5', 'participant', 'Bob', 'Smith', 30, 'Environmental activist and sustainability enthusiast. Always looking for ways to make a positive impact.', 'Portland, OR'),
('REPLACE_WITH_ACTUAL_USER_ID_6', 'participant', 'Carol', 'Davis', 28, 'Creative professional with a passion for design and art. Love connecting with fellow creatives.', 'Brooklyn, NY'),
('REPLACE_WITH_ACTUAL_USER_ID_7', 'participant', 'David', 'Wilson', 22, 'Recent computer science graduate eager to learn and grow in the tech community.', 'Austin, TX'),
('REPLACE_WITH_ACTUAL_USER_ID_8', 'participant', 'Emma', 'Brown', 35, 'Experienced project manager with a passion for organizing community events.', 'Seattle, WA');
*/
