'use client'

import { useEffect, useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Calendar, MapPin, Users, ArrowLeft } from 'lucide-react'

interface EventDetail {
  id: string
  title: string
  description: string
  start_date: string
  end_date: string
  location: string
  max_participants: number
  category: string
  is_published: boolean
  organization_id: string
  image_url?: string | null
  gallery_urls?: string[] | null
  profiles?: {
    organization_name: string
  }
}

export default function EventDetailPage() {
  const params = useParams<{ id: string }>()
  const router = useRouter()
  const [event, setEvent] = useState<EventDetail | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchEvent = async () => {
      const { data, error } = await supabase
        .from('events')
        .select(`*, profiles:organization_id ( organization_name )`)
        .eq('id', params.id)
        .single()

      if (!error) setEvent(data)
      setLoading(false)
    }
    fetchEvent()
  }, [params.id])

  const formatDate = (dateString: string) =>
    new Date(dateString).toLocaleString()

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  if (!event) {
    return (
      <div className="max-w-3xl mx-auto px-4 py-12">
        <button onClick={() => router.push('/events')} className="text-blue-600 hover:underline inline-flex items-center mb-6">
          <ArrowLeft className="h-4 w-4 mr-2" /> Back to events
        </button>
        <div className="bg-yellow-50 border border-yellow-200 text-yellow-800 p-4 rounded-lg">Event not found.</div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-3xl mx-auto px-4 py-10">
        <button onClick={() => router.push('/events')} className="text-blue-600 hover:underline inline-flex items-center mb-6">
          <ArrowLeft className="h-4 w-4 mr-2" /> Back to events
        </button>

        <div className="bg-white rounded-2xl shadow-soft overflow-hidden">
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-6 text-white">
            <h1 className="text-2xl font-bold">{event.title}</h1>
            <p className="opacity-90 mt-1">{event.profiles?.organization_name || 'Organization'}</p>
          </div>
          {event.image_url && (
            <div className="h-56 w-full overflow-hidden">
              <img src={event.image_url} alt="Event" className="h-full w-full object-cover" />
            </div>
          )}
          <div className="p-6 space-y-4">
            <p className="text-gray-700">{event.description}</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-sm text-gray-600">
              <div className="flex items-center"><Calendar className="h-4 w-4 mr-2" /> {formatDate(event.start_date)}</div>
              <div className="flex items-center"><Users className="h-4 w-4 mr-2" /> Max {event.max_participants}</div>
              <div className="flex items-center"><MapPin className="h-4 w-4 mr-2" /> {event.location}</div>
            </div>

            {Array.isArray(event.gallery_urls) && event.gallery_urls.length > 0 && (
              <div>
                <h2 className="text-lg font-semibold text-gray-900 mb-3">Gallery</h2>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                  {event.gallery_urls.map((url, idx) => (
                    <div key={idx} className="aspect-video overflow-hidden rounded-lg border">
                      <img src={url} alt={`Gallery ${idx+1}`} className="w-full h-full object-cover" />
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}


