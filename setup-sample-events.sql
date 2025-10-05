-- Setup Sample Events and Applications
-- This script creates sample events and applications that work with real users
-- Run this AFTER you have created some users through the application

-- First, let's create some sample events that can be used for testing
-- These will be created by the first organization user you create

-- Note: Replace 'YOUR_ORGANIZATION_USER_ID' with the actual UUID of an organization user
-- You can find this by running: SELECT id FROM auth.users LIMIT 1;

-- Sample Events (uncomment and modify after you have organization users)
/*
INSERT INTO events (id, title, description, start_date, end_date, location, max_participants, category, organization_id, is_published) VALUES
('e1111111-1111-1111-1111-111111111111', 'Tech Innovation Summit 2024', 'Join us for a day of cutting-edge technology discussions, networking, and hands-on workshops. Learn about the latest trends in AI, blockchain, and sustainable tech solutions.', 
 '2024-03-15 09:00:00+00', '2024-03-15 18:00:00+00', 'San Francisco Convention Center', 200, 'Technology', 'YOUR_ORGANIZATION_USER_ID', true),

('e2222222-2222-2222-2222-222222222222', 'Sustainable Living Workshop', 'Learn practical ways to reduce your environmental footprint. Topics include zero-waste living, renewable energy, and sustainable gardening techniques.', 
 '2024-03-20 10:00:00+00', '2024-03-20 16:00:00+00', 'Portland Community Center', 50, 'Environment', 'YOUR_ORGANIZATION_USER_ID', true),

('e3333333-3333-3333-3333-333333333333', 'Creative Design Meetup', 'Connect with fellow designers, share your work, and get feedback from industry professionals. Bring your portfolio for review!', 
 '2024-03-25 18:00:00+00', '2024-03-25 21:00:00+00', 'Creative Hub Brooklyn', 30, 'Design', 'YOUR_ORGANIZATION_USER_ID', true);
*/

-- Alternative: Create a function to easily add sample events
CREATE OR REPLACE FUNCTION create_sample_events(org_user_id UUID)
RETURNS VOID AS $$
BEGIN
    -- Insert sample events for the given organization
    INSERT INTO events (id, title, description, start_date, end_date, location, max_participants, category, organization_id, is_published) VALUES
    ('e1111111-1111-1111-1111-111111111111', 'Tech Innovation Summit 2024', 'Join us for a day of cutting-edge technology discussions, networking, and hands-on workshops. Learn about the latest trends in AI, blockchain, and sustainable tech solutions.', 
     '2024-03-15 09:00:00+00', '2024-03-15 18:00:00+00', 'San Francisco Convention Center', 200, 'Technology', org_user_id, true),
    
    ('e2222222-2222-2222-2222-222222222222', 'Sustainable Living Workshop', 'Learn practical ways to reduce your environmental footprint. Topics include zero-waste living, renewable energy, and sustainable gardening techniques.', 
     '2024-03-20 10:00:00+00', '2024-03-20 16:00:00+00', 'Portland Community Center', 50, 'Environment', org_user_id, true),
    
    ('e3333333-3333-3333-3333-333333333333', 'Creative Design Meetup', 'Connect with fellow designers, share your work, and get feedback from industry professionals. Bring your portfolio for review!', 
     '2024-03-25 18:00:00+00', '2024-03-25 21:00:00+00', 'Creative Hub Brooklyn', 30, 'Design', org_user_id, true),
    
    ('e4444444-4444-4444-4444-444444444444', 'AI and Machine Learning Conference', 'Deep dive into artificial intelligence and machine learning. Expert speakers, hands-on coding sessions, and networking opportunities.', 
     '2024-04-10 09:00:00+00', '2024-04-12 17:00:00+00', 'Tech Hub San Francisco', 150, 'Technology', org_user_id, true),
    
    ('e5555555-5555-5555-5555-555555555555', 'Community Garden Project', 'Help us build a community garden in the heart of the city. Learn about urban farming, composting, and sustainable food production.', 
     '2024-04-15 08:00:00+00', '2024-04-15 14:00:00+00', 'Central Park Community Garden', 25, 'Environment', org_user_id, true),
    
    ('e6666666-6666-6666-6666-666666666666', 'Art Exhibition Opening', 'Celebrate local artists and their work. Live music, refreshments, and the opportunity to meet the artists behind the pieces.', 
     '2024-04-20 19:00:00+00', '2024-04-20 22:00:00+00', 'Creative Hub Gallery', 100, 'Art', org_user_id, true);
END;
$$ LANGUAGE plpgsql;

-- Usage: After creating an organization user, run:
-- SELECT create_sample_events('your-organization-user-id-here');

-- Create a function to add sample applications
CREATE OR REPLACE FUNCTION create_sample_applications(participant_user_id UUID)
RETURNS VOID AS $$
BEGIN
    -- Insert sample applications for the given participant
    INSERT INTO applications (event_id, participant_id, motivation_letter, status) VALUES
    ('e1111111-1111-1111-1111-111111111111', participant_user_id, 
     'I am extremely excited about the Tech Innovation Summit 2024! As a passionate technology enthusiast with a background in computer science, I have been following the latest developments in AI and blockchain technology. This summit presents an incredible opportunity for me to learn from industry leaders, network with like-minded professionals, and gain hands-on experience with cutting-edge technologies. I am particularly interested in the sustainable tech solutions track, as I believe technology should be used to address environmental challenges. I am committed to being an active participant, asking thoughtful questions, and contributing to discussions. I would love to share my recent project on machine learning for environmental monitoring and learn from others experiences. Thank you for considering my application!', 'pending'),
    
    ('e2222222-2222-2222-2222-222222222222', participant_user_id, 
     'I am deeply passionate about environmental sustainability and have been actively involved in various green initiatives in my community. The Sustainable Living Workshop is exactly what I need to take my environmental advocacy to the next level. I have been practicing zero-waste living for the past two years and have started a small community garden in my neighborhood. I am excited to learn more about renewable energy solutions and advanced sustainable gardening techniques. I believe this workshop will not only enhance my personal practices but also help me educate and inspire others in my community. I am committed to sharing the knowledge I gain and implementing sustainable practices in my daily life.', 'accepted'),
    
    ('e3333333-3333-3333-3333-333333333333', participant_user_id, 
     'As a creative professional with over five years of experience in design, I am thrilled about the opportunity to connect with fellow designers at the Creative Design Meetup. I have been working as a freelance graphic designer and have recently started exploring UI/UX design. I am particularly excited about the portfolio review session, as I am always looking for ways to improve my work and get fresh perspectives. I have been following the Creative Hub community for a while and have been impressed by the quality of events and the supportive community. I am eager to share my recent projects, learn from others experiences, and potentially collaborate on future projects. This meetup would be a valuable networking opportunity and a chance to grow as a designer.', 'pending');
END;
$$ LANGUAGE plpgsql;

-- Usage: After creating a participant user, run:
-- SELECT create_sample_applications('your-participant-user-id-here');
