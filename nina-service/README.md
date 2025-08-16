# nina-service

This directory contains the Go HTTP service responsible for handling authorization checks for the Nina application.

## Deployment to Google Cloud Run

Deploying this service makes it a callable endpoint that the Flutter application can use to verify user authorization.

### Prerequisites

1.  Ensure you have the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured.
2.  Ensure you have enabled the **Cloud Run API** and **Cloud Build API** in your `ghchinoy-genai-sa` Google Cloud project.

### Deployment Steps

1.  **Navigate to this directory:**
    ```bash
    cd /path/to/your/project/nina/nina-service
    ```

2.  **Build and Push the Container Image:**
    *   This command uses Google Cloud Build to build your container image from the `Dockerfile` and push it to the Google Container Registry.
    ```bash
    gcloud builds submit --tag gcr.io/ghchinoy-genai-sa/nina-service
    ```

3.  **Deploy the Image to Cloud Run:**
    *   This command deploys the container image to the fully managed Cloud Run service.
    ```bash
    gcloud run deploy nina-service --image gcr.io/ghchinoy-genai-sa/nina-service --platform managed --region us-central1 --allow-unauthenticated
    ```
    *   During the deployment, you may be prompted to confirm settings. The defaults are usually acceptable.
    *   The `--allow-unauthenticated` flag makes the service public, but it is secured by requiring a valid Firebase ID token in the `Authorization` header, which is verified by the service's code.

4.  **Retrieve the Service URL:**
    *   After a successful deployment, the command will output the service URL. It will look something like this:
        `https://nina-service-xxxxxxxxxx-uc.a.run.app`
    *   This is the URL that the Flutter application will need to call.
