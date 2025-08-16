const backendUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://localhost:8080',
);

const gcsBucket = 'gs://ghchinoy-genai-sa-assets/editorial-look';

const String authServiceUrl =
    'https://nina-service-64774088793.us-central1.run.app/checkAuth';
