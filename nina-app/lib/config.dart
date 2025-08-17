/// The URL of the backend server.
const backendUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://localhost:8080',
);

/// The Google Cloud Storage bucket for the application.
const gcsBucket = 'gs://ghchinoy-genai-sa-assets/editorial-look';

/// The URL of the authentication service.
const String authServiceUrl =
    'https://nina-service-64774088793.us-central1.run.app/checkAuth';
