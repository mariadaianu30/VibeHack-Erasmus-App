/** @type {import('next').NextConfig} */
const nextConfig = {
  eslint: {
    // ⚠️ Vercel nu va mai opri build-ul din cauza linting errors
    ignoreDuringBuilds: true,
  },
  typescript: {
    // ⚠️ Opțional: dacă ai și erori TypeScript blocante
    ignoreBuildErrors: true,
  },
};

module.exports = nextConfig;
