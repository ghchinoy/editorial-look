# nina

An AI-powered image generation application.

## Features

*   User authentication with Firebase
*   Image generation with Imagen 4
*   Settings panel for advanced controls
*   Gallery of saved images from Firestore

## Getting Started

This project is intended to be cloned and run with your own Firebase project.

### 1. Initial Firebase Setup

*   Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
*   In your Google Cloud project, enable the **Vertex AI API**.
*   In your Firebase project, go to the **Authentication** section and enable the **Google** sign-in provider.
*   Create an **OAuth 2.0 Client ID** for a web application in the Google Cloud Console and add the necessary authorized origins and redirect URIs.

### 2. Local Configuration

After cloning the repository, you must generate your own Firebase configuration files. These files are not committed to the repository for security reasons.

1.  **Install CLIs:** Make sure you have the [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) and the [Firebase CLI](https://firebase.google.com/docs/cli#install_the_firebase_cli) installed and you are logged in (`firebase login`).

2.  **Configure the Flutter App:**
    *   Navigate to the `nina-app` directory.
    *   Run the following command and select your Firebase project when prompted:
        ```bash
        flutterfire configure
        ```
    *   This will generate a `lib/firebase_options.dart` file with your project's specific API keys.

3.  **Configure Deployment Targets:**
    *   You need to create a `.firebaserc` file to tell the CLI which hosting site to deploy to. Run the following command to create the file and set up a target named `editorial-look` (you can replace this with your desired site name).
        ```bash
        firebase target:apply hosting editorial-look editorial-look
        ```

4.  **Update Client IDs:**
    *   In `lib/login_screen.dart`, replace the placeholder `clientId` in the `GoogleSignIn` constructor with your Web Client ID from the Google Cloud Console.
    *   In `web/index.html`, ensure the `meta` tag for `google-signin-client_id` has your client ID.

### 3. Run the Application
    *   Run `flutter pub get` to install the dependencies.
    *   Run `flutter run -d chrome` to run the application in debug mode.

## Deploying Firebase Rules and Indexes

To deploy the Firestore security rules and indexes, and Storage rules, you need to have the Firebase CLI installed.

1.  **Install the Firebase CLI:**
    *   If you don't have the Firebase CLI installed, you can install it by following the instructions in the [official documentation](https://firebase.google.com/docs/cli#install_the_firebase_cli).

2.  **Login to Firebase:**
    *   Run `firebase login` to log in to your Firebase account.

3.  **Select the correct Firebase project:**
    *   Run `firebase projects:list` to see a list of your Firebase projects and which one is currently active.
    *   If the correct project is not active, run `firebase use <your-project-id>` to switch to the correct project.

4.  **Check Existing Indexes:**
    *   Go to the [Google Cloud Console](https://console.cloud.google.com/).
    *   Make sure you have the correct project selected.
    *   In the navigation menu, go to **Databases > Firestore**.
    *   In the Firestore UI, click on the **Indexes** tab.
    *   Here you will see a list of all your existing indexes.

5.  **Deploy the rules and indexes:**
    *   Navigate to the project directory (`/Users/ghchinoy/dev/nina/nina-app`).
    *   Run the following command to deploy both rules and indexes:
        ```bash
        firebase deploy --only firestore
        ```
    *   Alternatively, you can deploy them separately:
        ```bash
        firebase deploy --only firestore:rules
        firebase deploy --only firestore:indexes
        ```

6.  **Configure CORS for Firebase Storage:**
    *   The Flutter web app needs permission to display images from your project's Firebase Storage bucket. You must apply a Cross-Origin Resource Sharing (CORS) policy to the bucket.
    *   First, create a `cors.json` file with the following content:
        ```json
        [
          {
            "origin": ["http://localhost:8000", "https://*.firebaseapp.com", "https://*.web.app"],
            "method": ["GET"],
            "maxAgeSeconds": 3600
          }
        ]
        ```
    *   **Important:** Your project's default storage bucket is named `<your-project-id>.appspot.com`. You can verify this in your `lib/firebase_options.dart` file.
    *   Run the following command, replacing `<your-project-id>` with your actual Firebase project ID:
        ```bash
        gcloud storage buckets update gs://<your-project-id>.appspot.com --cors-file=cors.json
        ```

7.  **Deploy Storage Rules:**
    *   Run the following command to deploy the storage rules:
        ```bash
        firebase deploy --only storage
        ```

## Backend Service (`nina-service`)

The `nina` project includes a backend Go service located in the `nina-service` directory. This service handles secure operations that should not be performed directly by the client application, such as user authorization checks.

For instructions on how to deploy this service to Google Cloud Run, please see the `README.md` file within the `nina-service` directory.

## User Authorization

This application uses a Firestore-based allowlist to control user access. Only users whose email addresses are present in the `allowlist` collection will be able to log in.

### Managing Authorized Users

1.  Go to your project's **Firestore Database** in the [Firebase Console](https://console.firebase.google.com/).
2.  Ensure you have a collection named `lookbook_allowlist`.
3.  To add a new authorized user, create a new document in this collection. The document ID can be anything (e.g., an auto-generated ID).
4.  Inside the document, create a single field with the following properties:
    *   **Field Name:** `email`
    *   **Field Type:** `String`
    *   **Field Value:** The email address of the user you want to authorize (e.g., `user@example.com`).

Only users who sign in with a Google account matching an email in this collection will be granted access.

## Deployment to Firebase Hosting

To deploy the application to a shareable, public URL, use Firebase Hosting.

1.  **Initialize Hosting (One-Time Setup):**
    *   From within the `nina-app` directory, run the following command:
        ```bash
        firebase init hosting
        ```
    *   The Firebase CLI will ask a series of questions:
        *   `What do you want to use as your public directory?` Enter **`build/web`**.
        *   `Configure as a single-page app (rewrite all urls to /index.html)?` Enter **`y`** (Yes).
        *   `Set up automatic builds and deploys with GitHub?` Enter **`n`** (No) for now.
        *   `File build/web/index.html already exists. Overwrite?` Enter **`n`** (No).

2.  **Build the Application:**
    *   Before you deploy, you need to create a production build of your application.
        ```bash
        flutter build web
        ```

3.  **Deploy the Application:**
    *   This command will upload the contents of your `build/web` directory to Firebase Hosting.
        ```bash
        firebase deploy --only hosting
        ```
    *   After the command completes, the CLI will output the public URL for your live application.