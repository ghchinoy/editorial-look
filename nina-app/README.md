# nina-app: Flutter Web Frontend

[![Flutter](https://img.shields.io/badge/Flutter-3.22+-02569B?style=flat-square&logo=flutter)](pubspec.yaml)
[![Firebase Hosting](https://img.shields.io/badge/Firebase_Hosting-Live-FFA000?style=flat-square&logo=firebase)](https://editorial-look.web.app)
[![License](https://img.shields.io/badge/License-Apache_2.0-green.svg?style=flat-square)](../LICENSE)

`nina-app` is a responsive Flutter web application designed for editorial AI image generation and curation. It provides interactive prompt assistance, parallel Imagen image rendering, real-time Gemini art critique, and an editorial staggered gallery.

🔗 **Live Deployment:** [https://editorial-look.web.app](https://editorial-look.web.app)

---

## 📑 Table of Contents

* [✨ Key Features](#-key-features)
* [📋 Prerequisites](#-prerequisites)
* [⚡ Getting Started](#-getting-started)
  * [1. Initial Firebase Setup](#1-initial-firebase-setup)
  * [2. Local Configuration](#2-local-configuration)
  * [3. Run the Application](#3-run-the-application)
* [🔧 Development & Troubleshooting](#-development--troubleshooting)
* [🔒 User Authorization & Allowlist](#-user-authorization--allowlist)
* [📦 Firebase Rules, Indexes & CORS](#-firebase-rules-indexes--cors)
* [🚀 Deployment to Firebase Hosting](#-deployment-to-firebase-hosting)
* [🤝 Contributing](#-contributing)
* [📄 License](#-license)

---

## ✨ Key Features

* **AI-Powered Image Generation**: Utilizes Google's Imagen models to generate high-quality images with customizable aspect ratios and counts.
* **Prompt with an Editorial Eye**: Select a style (e.g. Fashion, Business) and city to generate detailed creative prompts with Gemini.
* **AI-Powered Critique**: Instant "Editor's Notes" feedback from Gemini evaluating prompt alignment, photorealism, and aesthetics.
* **Interactive Gallery**:
  * Browse past creations in dynamic masonry, standard, and quilted layouts.
  * Interactive preview stacks with drop shadows and organic tilt angles.
  * Full-screen detail view showing prompt metadata, author, latency metrics, and critique breakdown.
  * One-click direct image downloads.

---

## 📋 Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.22 or higher)
* [Dart SDK](https://dart.dev/get-dart) (v3.4 or higher)
* [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools` v13+)
* [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) (`dart pub global activate flutterfire_cli`)
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`gcloud`)

---

## ⚡ Getting Started

### 1. Initial Firebase Setup

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
2. In your Google Cloud project, enable the **Vertex AI API**.
3. In your Firebase project, navigate to **Authentication > Sign-in method** and enable the **Google** provider.
4. Create an **OAuth 2.0 Client ID** for a Web Application in the Google Cloud Console and add your authorized origins (`http://localhost:8000`, `https://<your-project>.web.app`).

### 2. Local Configuration

After cloning the repository, configure your local project settings:

1. **Log in to Firebase & FlutterFire:**
   ```bash
   firebase login
   ```

2. **Configure the Flutter App:**
   ```bash
   cd nina-app
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` with your project keys.

3. **Configure Deployment Targets:**
   ```bash
   firebase target:apply hosting editorial-look <your-hosting-site-id>
   ```

4. **Update OAuth Client IDs:**
   * In [`lib/login_screen.dart`](lib/login_screen.dart), replace the placeholder `clientId` in the `GoogleSignIn` constructor with your Web Client ID.
   * In [`web/index.html`](web/index.html), verify that the `google-signin-client_id` meta tag is populated.

### 3. Run the Application

```bash
# Install Dart dependencies
flutter pub get

# Run on Chrome with web-renderer
flutter run -d chrome
```

---

## 🔧 Development & Troubleshooting

* **Hot Reload vs Full Restart:** After adding a new Flutter package with platform-specific code (e.g. `url_launcher`), perform a full **stop and restart** (`R` or restart the debug process). Hot reload alone may throw a `MissingPluginException`.
* **CORS Errors during Image Loading:** Ensure the Cloud Storage CORS policy is applied (see below).

---

## 🔒 User Authorization & Allowlist

This application restricts access using a Firestore-based allowlist:

1. In your Firestore Database, create a collection named `lookbook_allowlist`.
2. Add a document for each authorized user with:
   * **Field:** `email` (`String`)
   * **Value:** The Google email address permitted to log in.
3. Authorization checks are securely verified server-side by [`nina-service`](../nina-service).

---

## 📦 Firebase Rules, Indexes & CORS

### 1. Deploy Firestore Rules and Indexes

```bash
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### 2. Configure CORS for Firebase Storage

To allow the web canvas to display and download images from Firebase Storage, apply `cors.json`:

```bash
gcloud storage buckets update gs://<your-project-id>.appspot.com --cors-file=cors.json
```

### 3. Deploy Storage Rules

```bash
firebase deploy --only storage
```

---

## 🚀 Deployment to Firebase Hosting

```bash
# 1. Build the Flutter web application
flutter build web --release

# 2. Deploy to Firebase Hosting
firebase deploy --only hosting
```

---

## 🤝 Contributing

Contributions are welcome! Please open an issue first to discuss substantial changes.

## 📄 License

This project is licensed under the Apache 2.0 License.