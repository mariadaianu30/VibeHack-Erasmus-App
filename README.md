# Event Platform

A modern event management platform built with Next.js 14, TypeScript, Tailwind CSS, and Supabase.

## Features

- **User Authentication**: Login/Register with user type selection (Participant/Organization)
- **Profile Management**: Complete profiles for participants and organizations
- **Event Management**: Create, edit, and manage events
- **Application System**: Participants can apply to events with motivation letters
- **Dashboard**: Personalized dashboards for both user types
- **Real-time Updates**: Live data synchronization with Supabase

## Tech Stack

- **Frontend**: Next.js 14, TypeScript, Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Auth, Real-time)
- **Deployment**: Vercel (recommended)

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd event-platform
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - Copy your project URL and anon key
   - Copy `env.template` to `.env.local`
   - Fill in your Supabase credentials:
     ```
     NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
     NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
     ```

4. **Set up the database**
   - Go to your Supabase dashboard
   - Navigate to SQL Editor
   - Run the database schema (will be provided in Step 2)

5. **Run the development server**
   ```bash
   npm run dev
   ```

6. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## Project Structure

```
src/
├── app/                    # Next.js app directory
│   ├── (auth)/            # Authentication routes
│   │   ├── login/
│   │   └── register/
│   ├── dashboard/          # User dashboards
│   ├── events/             # Event management
│   │   ├── [id]/          # Event details
│   │   ├── create/        # Create event
│   │   └── manage/        # Manage events
│   ├── organizations/      # Organization pages
│   ├── profile/           # User profiles
│   └── my-applications/   # User applications
├── components/            # Reusable components
├── lib/                   # Utilities and configurations
│   ├── supabase.ts       # Supabase client
│   └── auth.ts           # Authentication helpers
└── middleware.ts         # Route protection
```

## Development Steps

This project follows a step-by-step development guide:

1. **Step 1**: Project Setup & Supabase Configuration ✅
2. **Step 2**: Database Schema & RLS Policies
3. **Step 3**: Root Layout & Navigation
4. **Step 4**: Authentication Pages
5. **Step 5**: Auth Middleware & Protected Routes
6. **Step 6**: Profile Form Component
7. **Step 7**: Profile Pages
8. **Step 8**: Event Components
9. **Step 9**: Homepage with Event Discovery
10. **Step 10**: Event Details Page
11. **Step 11**: Event Form & Create/Edit Pages
12. **Step 12**: Application Components
13. **Step 13**: Apply to Event & My Applications
14. **Step 14**: Organization Applications Management
15. **Step 15**: Participant Dashboard
16. **Step 16**: Organization Dashboard
17. **Step 17**: Manage Events Page
18. **Step 18**: Organizations Directory
19. **Step 19**: Error Handling & Loading States
20. **Step 20**: Final Integration & Bug Fixes

## Deployment

### Vercel (Recommended)

1. Push your code to GitHub
2. Connect your repository to Vercel
3. Add environment variables in Vercel dashboard
4. Deploy!

### Other Platforms

The app can be deployed to any platform that supports Next.js:
- Netlify
- Railway
- DigitalOcean App Platform
- AWS Amplify

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details