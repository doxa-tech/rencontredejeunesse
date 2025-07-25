import { defineConfig } from 'astro/config';

// https://astro.build/config
import react from "@astrojs/react";

// https://astro.build/config
export default defineConfig({
  integrations: [react()],
  redirects: {
    "/2024": "/2025"
  },
  vite: {
    // fsevents was causing an exception when starting the app
    optimizeDeps: { exclude: ["fsevents"] }
  }
});