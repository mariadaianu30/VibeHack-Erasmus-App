-- Sample Data for Event Platform
-- Run this AFTER running the database-schema.sql
-- Note: This creates test data. In production, you would create real users through the auth system.

-- Insert sample profiles (these would normally be created through auth signup)
-- For testing purposes, we'll create some sample data

-- Sample Organizations
INSERT INTO profiles (id, user_type, organization_name, bio, location, website) VALUES
('11111111-1111-1111-1111-111111111111', 'organization', 'Tech Innovators', 'Leading technology company focused on innovation and community building.', 'San Francisco, CA', 'https://techinnovators.com'),
('22222222-2222-2222-2222-222222222222', 'organization', 'Green Future', 'Environmental organization dedicated to sustainable living and eco-friendly practices.', 'Portland, OR', 'https://greenfuture.org'),
('33333333-3333-3333-3333-333333333333', 'organization', 'Creative Hub', 'Community space for artists, designers, and creative professionals.', 'Brooklyn, NY', 'https://creativehub.nyc');

-- Sample Participants
INSERT INTO profiles (id, user_type, first_name, last_name, age, bio, location) VALUES
('44444444-4444-4444-4444-444444444444', 'participant', 'Alice', 'Johnson', 25, 'Passionate about technology and community building. Love attending tech meetups and hackathons.', 'San Francisco, CA'),
('55555555-5555-5555-5555-555555555555', 'participant', 'Bob', 'Smith', 30, 'Environmental activist and sustainability enthusiast. Always looking for ways to make a positive impact.', 'Portland, OR'),
('66666666-6666-6666-6666-666666666666', 'participant', 'Carol', 'Davis', 28, 'Creative professional with a passion for design and art. Love connecting with fellow creatives.', 'Brooklyn, NY'),
('77777777-7777-7777-7777-777777777777', 'participant', 'David', 'Wilson', 22, 'Recent computer science graduate eager to learn and grow in the tech community.', 'Austin, TX'),
('88888888-8888-8888-8888-888888888888', 'participant', 'Emma', 'Brown', 35, 'Experienced project manager with a passion for organizing community events.', 'Seattle, WA');

-- Sample Events
INSERT INTO events (id, title, description, start_date, end_date, location, max_participants, category, organization_id, is_published) VALUES
('e1111111-1111-1111-1111-111111111111', 'Tech Innovation Summit 2024', 'Join us for a day of cutting-edge technology discussions, networking, and hands-on workshops. Learn about the latest trends in AI, blockchain, and sustainable tech solutions.', 
 '2024-03-15 09:00:00+00', '2024-03-15 18:00:00+00', 'San Francisco Convention Center', 200, 'Technology', '11111111-1111-1111-1111-111111111111', true),

('e2222222-2222-2222-2222-222222222222', 'Sustainable Living Workshop', 'Learn practical ways to reduce your environmental footprint. Topics include zero-waste living, renewable energy, and sustainable gardening techniques.', 
 '2024-03-20 10:00:00+00', '2024-03-20 16:00:00+00', 'Portland Community Center', 50, 'Environment', '22222222-2222-2222-2222-222222222222', true),

('e3333333-3333-3333-3333-333333333333', 'Creative Design Meetup', 'Connect with fellow designers, share your work, and get feedback from industry professionals. Bring your portfolio for review!', 
 '2024-03-25 18:00:00+00', '2024-03-25 21:00:00+00', 'Creative Hub Brooklyn', 30, 'Design', '33333333-3333-3333-3333-333333333333', true),

('e4444444-4444-4444-4444-444444444444', 'AI and Machine Learning Conference', 'Deep dive into artificial intelligence and machine learning. Expert speakers, hands-on coding sessions, and networking opportunities.', 
 '2024-04-10 09:00:00+00', '2024-04-12 17:00:00+00', 'Tech Hub San Francisco', 150, 'Technology', '11111111-1111-1111-1111-111111111111', true),

('e5555555-5555-5555-5555-555555555555', 'Community Garden Project', 'Help us build a community garden in the heart of the city. Learn about urban farming, composting, and sustainable food production.', 
 '2024-04-15 08:00:00+00', '2024-04-15 14:00:00+00', 'Central Park Community Garden', 25, 'Environment', '22222222-2222-2222-2222-222222222222', true),

('e6666666-6666-6666-6666-666666666666', 'Art Exhibition Opening', 'Celebrate local artists and their work. Live music, refreshments, and the opportunity to meet the artists behind the pieces.', 
 '2024-04-20 19:00:00+00', '2024-04-20 22:00:00+00', 'Creative Hub Gallery', 100, 'Art', '33333333-3333-3333-3333-333333333333', true);

-- Sample Applications
INSERT INTO applications (event_id, participant_id, motivation_letter, status) VALUES
('e1111111-1111-1111-1111-111111111111', '44444444-4444-4444-4444-444444444444', 
 'I am extremely excited about the Tech Innovation Summit 2024! As a passionate technology enthusiast with a background in computer science, I have been following the latest developments in AI and blockchain technology. This summit presents an incredible opportunity for me to learn from industry leaders, network with like-minded professionals, and gain hands-on experience with cutting-edge technologies. I am particularly interested in the sustainable tech solutions track, as I believe technology should be used to address environmental challenges. I am committed to being an active participant, asking thoughtful questions, and contributing to discussions. I would love to share my recent project on machine learning for environmental monitoring and learn from others experiences. Thank you for considering my application!', 'pending'),

('e1111111-1111-1111-1111-111111111111', '77777777-7777-7777-7777-777777777777', 
 'As a recent computer science graduate, I am eager to expand my knowledge and network in the technology field. The Tech Innovation Summit 2024 aligns perfectly with my career goals and interests. I have been working on several personal projects involving AI and machine learning, and I believe this event will provide valuable insights and connections that will help me grow as a developer. I am particularly excited about the hands-on workshops and the opportunity to learn from industry experts. I am committed to being an engaged participant and contributing to the tech community. This summit would be a significant step in my professional development journey.', 'accepted'),

('e2222222-2222-2222-2222-222222222222', '55555555-5555-5555-5555-555555555555', 
 'I am deeply passionate about environmental sustainability and have been actively involved in various green initiatives in my community. The Sustainable Living Workshop is exactly what I need to take my environmental advocacy to the next level. I have been practicing zero-waste living for the past two years and have started a small community garden in my neighborhood. I am excited to learn more about renewable energy solutions and advanced sustainable gardening techniques. I believe this workshop will not only enhance my personal practices but also help me educate and inspire others in my community. I am committed to sharing the knowledge I gain and implementing sustainable practices in my daily life.', 'accepted'),

('e3333333-3333-3333-3333-333333333333', '66666666-6666-6666-6666-666666666666', 
 'As a creative professional with over five years of experience in design, I am thrilled about the opportunity to connect with fellow designers at the Creative Design Meetup. I have been working as a freelance graphic designer and have recently started exploring UI/UX design. I am particularly excited about the portfolio review session, as I am always looking for ways to improve my work and get fresh perspectives. I have been following the Creative Hub community for a while and have been impressed by the quality of events and the supportive community. I am eager to share my recent projects, learn from others experiences, and potentially collaborate on future projects. This meetup would be a valuable networking opportunity and a chance to grow as a designer.', 'pending'),

('e4444444-4444-4444-4444-444444444444', '44444444-4444-4444-4444-444444444444', 
 'I am extremely excited about the AI and Machine Learning Conference! As someone who has been working with AI technologies for the past three years, I am eager to deepen my understanding and stay updated with the latest developments. I have been working on several machine learning projects, including a recommendation system and a natural language processing application. The hands-on coding sessions are particularly appealing to me, as I learn best through practical application. I am also looking forward to the networking opportunities and the chance to connect with other AI enthusiasts and professionals. I believe this conference will provide valuable insights that I can apply to my current projects and future endeavors. I am committed to being an active participant and contributing to the discussions.', 'pending'),

('e5555555-5555-5555-5555-555555555555', '88888888-8888-8888-8888-888888888888', 
 'I am passionate about community building and sustainable living, and the Community Garden Project is a perfect opportunity to combine both interests. As an experienced project manager, I have organized several community events and have a strong background in coordinating volunteers and managing resources. I am particularly excited about learning more about urban farming and composting techniques, as I have been interested in starting a similar project in my neighborhood. I believe my organizational skills and passion for sustainability would make me a valuable contributor to this project. I am committed to not only participating in the garden building but also helping to establish systems for ongoing maintenance and community involvement. This project aligns perfectly with my values and goals.', 'accepted');

-- Create some additional test data for better testing scenarios
INSERT INTO events (id, title, description, start_date, end_date, location, max_participants, category, organization_id, is_published) VALUES
('e7777777-7777-7777-7777-777777777777', 'Draft Event - Not Published', 'This is a draft event that is not yet published. It should not be visible to participants.', 
 '2024-05-01 10:00:00+00', '2024-05-01 16:00:00+00', 'Private Location', 20, 'Technology', '11111111-1111-1111-1111-111111111111', false),

('e8888888-8888-8888-8888-888888888888', 'Past Event', 'This event has already occurred and should not be visible in current event listings.', 
 '2024-01-15 10:00:00+00', '2024-01-15 16:00:00+00', 'Past Location', 30, 'Technology', '11111111-1111-1111-1111-111111111111', true);

-- Add some more applications to test different scenarios
INSERT INTO applications (event_id, participant_id, motivation_letter, status) VALUES
('e4444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555555', 
 'I am interested in learning more about AI and machine learning, particularly in the context of environmental applications. I believe AI can be a powerful tool for addressing climate change and environmental challenges. This conference would provide me with the knowledge and connections needed to explore this intersection of technology and environmentalism. I am particularly interested in the sustainable AI track and would love to learn about how machine learning can be used for environmental monitoring and conservation efforts.', 'rejected'),

('e6666666-6666-6666-6666-666666666666', '77777777-7777-7777-7777-777777777777', 
 'As someone who appreciates art and creativity, I would love to attend the Art Exhibition Opening. While my background is in technology, I believe that art and technology can work together to create innovative solutions. I am particularly interested in digital art and interactive installations. This event would be a great opportunity for me to explore the creative side of technology and connect with artists who might be interested in collaborating on tech-art projects. I am excited about the possibility of meeting like-minded individuals who share an interest in the intersection of art and technology.', 'pending');
