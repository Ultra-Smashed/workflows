import type { ReactNode } from 'react'
import type { Metadata, Viewport } from 'next'
import '@/app/globals.css'

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  themeColor: '#08090a',
}

export const metadata: Metadata = {
  title: 'Sim Marketing Overlay — Euro Pricing',
  description:
    'A focused Sim marketing overlay for European pricing, plan positioning, and buyer conversion.',
  applicationName: 'Sim Marketing',
  openGraph: {
    title: 'Sim Marketing Overlay — Euro Pricing',
    description:
      'A focused Sim marketing overlay for European pricing, plan positioning, and buyer conversion.',
    type: 'website',
  },
}

interface RootLayoutProps {
  children: ReactNode
}

export default function RootLayout({ children }: RootLayoutProps) {
  return (
    <html lang='en'>
      <body>{children}</body>
    </html>
  )
}
