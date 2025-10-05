'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Calendar, Users, User, LogOut, Plus, Eye, Settings, ArrowRight, TrendingUp, Clock, CheckCircle } from 'lucide-react'

interface User {
  id: string
  email?: string
}

interface Profile {
  user_type: 'participant' | 'organization'
  first_name?: string
  last_name?: string
  organization_name?: string
}

export default function DashboardPage() {
  const [user, setUser] = useState<User | null>(null)
  const [profile, setProfile] = useState<Profile | null>(null)
  const [loading, setLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    const getSession = async () => {
      const { data: { session } } = await supabase.auth.getSession()
      
      if (!session?.user) {
        router.push('/login')
        return
      }

      setUser(session.user)
      
      // Fetch user profile
      const { data: profileData } = await supabase
        .from('profiles')
        .select('user_type, first_name, last_name, organization_name')
        .eq('id', session.user.id)
        .single()

      if (profileData) {
        setProfile(profileData)
      }
      
      setLoading(false)
    }

    getSession()
  }, [router])

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    router.push('/')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  if (!user || !profile) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Access Denied</h2>
          <p className="text-gray-600 mb-4">You need to be logged in to access this page.</p>
          <button
            onClick={() => router.push('/login')}
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
          >
            Go to Login
          </button>
        </div>
      </div>
    )
  }

  const getDisplayName = () => {
    if (profile.user_type === 'organization') {
      return profile.organization_name || 'Organization'
    }
    return `${profile.first_name || ''} ${profile.last_name || ''}`.trim() || user.email || 'User'
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="bg-white rounded-xl shadow-sm border p-6 mb-8">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900">
                Welcome back, {getDisplayName()}!
              </h1>
              <p className="text-gray-600 mt-2">
                {profile.user_type === 'participant' 
                  ? 'Discover and apply to amazing events'
                  : 'Manage your events and applications'
                }
              </p>
            </div>
            <button
              onClick={handleSignOut}
              className="flex items-center text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md hover:bg-gray-100"
            >
              <LogOut className="h-5 w-5 mr-2" />
              Sign Out
            </button>
          </div>
        </div>

        {/* Dashboard Content */}
        {profile.user_type === 'participant' ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {/* Quick Actions */}
            <div className="bg-white rounded-xl shadow-sm border p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
              <div className="space-y-3">
                <button 
                  onClick={() => router.push('/events')}
                  className="w-full flex items-center justify-center px-4 py-3 border border-blue-600 text-blue-600 rounded-lg hover:bg-blue-50 transition-colors"
                >
                  <Calendar className="h-5 w-5 mr-2" />
                  Browse Events
                </button>
                <button 
                  onClick={() => router.push('/my-applications')}
                  className="w-full flex items-center justify-center px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                >
                  <Eye className="h-5 w-5 mr-2" />
                  My Applications
                </button>
              </div>
            </div>

            {/* Recent Activity */}
            <div className="bg-white rounded-xl shadow-sm border p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Recent Activity</h3>
              <div className="text-gray-500 text-sm">
                <p>No recent activity</p>
                <p className="mt-2">Start by browsing events and applying to ones that interest you!</p>
              </div>
            </div>

            {/* Profile */}
            <div className="bg-white rounded-xl shadow-sm border p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Your Profile</h3>
              <div className="space-y-2 text-sm">
                <p><span className="font-medium">Name:</span> {getDisplayName()}</p>
                <p><span className="font-medium">Email:</span> {user.email}</p>
                <p><span className="font-medium">Type:</span> Participant</p>
              </div>
              <button 
                onClick={() => router.push('/profile')}
                className="mt-4 w-full flex items-center justify-center px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <Settings className="h-5 w-5 mr-2" />
                Edit Profile
              </button>
            </div>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {/* Quick Actions */}
            <div className="bg-white rounded-xl shadow-sm border p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Actions</h3>
              <div className="space-y-3">
                <button 
                  onClick={() => router.push('/events/create')}
                  className="w-full flex items-center justify-center px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                >
                  <Plus className="h-5 w-5 mr-2" />
                  Create Event
                </button>
                <button 
                  onClick={() => router.push('/events/manage')}
                  className="w-full flex items-center justify-center px-4 py-3 border border-blue-600 text-blue-600 rounded-lg hover:bg-blue-50 transition-colors"
                >
                  <Calendar className="h-5 w-5 mr-2" />
                  Manage Events
                </button>
                <button 
                  onClick={() => router.push('/applications')}
                  className="w-full flex items-center justify-center px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                >
                  <Users className="h-5 w-5 mr-2" />
                  View Applications
                </button>
              </div>
            </div>

            {/* Organization Stats */}
            <div className="bg-white rounded-xl shadow-sm border p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Organization Stats</h3>
              <div className="space-y-3">
                <div className="flex justify-between">
                  <span className="text-gray-600">Total Events:</span>
                  <span className="font-semibold">0</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Active Events:</span>
                  <span className="font-semibold">0</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600">Total Applications:</span>
                  <span className="font-semibold">0</span>
                </div>
              </div>
            </div>

            {/* Profile */}
            <div className="bg-white rounded-xl shadow-sm border p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Organization Profile</h3>
              <div className="space-y-2 text-sm">
                <p><span className="font-medium">Organization:</span> {getDisplayName()}</p>
                <p><span className="font-medium">Email:</span> {user.email}</p>
                <p><span className="font-medium">Type:</span> Organization</p>
              </div>
              <button 
                onClick={() => router.push('/profile')}
                className="mt-4 w-full flex items-center justify-center px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <Settings className="h-5 w-5 mr-2" />
                Edit Profile
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}