# Nina: Your AI-Powered Creative Director

[![Live Demo](https://img.shields.io/badge/Live_Demo-editorial--look.web.app-4285F4?style=flat-square&logo=google-chrome&logoColor=white)](https://editorial-look.web.app)
[![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?style=flat-square&logo=flutter)](./nina-app)
[![Cloud Run](https://img.shields.io/badge/Cloud_Run-Go_Backend-4285F4?style=flat-square&logo=google-cloud)](./nina-service)
[![License](https://img.shields.io/badge/License-Apache_2.0-green.svg?style=flat-square)](LICENSE)

Nina is an experimental web application designed to be a creative partner for generating high-quality, editorial-style images. It integrates Google GenAI models (Imagen and Gemini) to assist across the creative workflow, from prompt engineering and multi-image generation to automated art critique and gallery curation.

🔗 **Try the live application:** [https://editorial-look.web.app](https://editorial-look.web.app)

---

## ✨ Features

* **AI-Assisted Prompt Engineering:** Select a style (e.g., "Fashion," "Business") and city to generate rich, detailed prompts using Gemini.
* **Advanced Imagen Generation:** Generate 1–4 high-resolution images simultaneously with aspect ratio controls (`1:1`, `3:4`, `4:3`, `16:9`, `9:16`).
* **AI-Powered Critique:** Receive structured "Editor's Notes" from an AI critique persona evaluating prompt alignment, photorealism, and aesthetic composition.
* **Dynamic Viewing Experience:** View creations across multiple layouts, including standard grids and staggered editorial layouts.
* **Secure & Persistent:** Backed by Cloud Firestore for gallery persistence and a Go microservice on Cloud Run for server-side token authorization.

---

## 🖼️ Application Screenshots

![Nina App Screenshot](https://github.com/user-attachments/assets/9478d7f7-28c8-4f57-b15c-dfef4bbf17f9)

![Nina App Screenshot](https://github.com/user-attachments/assets/a7aff66e-4b6d-4fb5-8740-4690f4f52016)

---

## ⚡ Quickstart (Local Development)

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.22+)
* [Go](https://go.dev/doc/install) (v1.25+)
* [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools` & `firebase login`)
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`gcloud`)

### Clone & Run

```bash
# 1. Clone the repository
git clone https://github.com/ghchinoy/editorial-look.git
cd editorial-look

# 2. Run the Flutter web frontend
cd nina-app
flutter pub get
flutter run -d chrome
```

```bash
# 3. (Optional) Run the Go backend authorization service locally
cd ../nina-service
export PORT=8080
go run .
```

---

## 📂 Repository Structure

This repository is organized as a monorepo:

| Directory | Role | Documentation |
|---|---|---|
| [**`nina-app/`**](./nina-app) | Flutter Web application (UI, Canvas layout, Firestore client, Vertex AI integration) | [Frontend README](./nina-app/README.md) |
| [**`nina-service/`**](./nina-service) | Go microservice deployed on Cloud Run handling secure token verification | [Backend README](./nina-service/README.md) |
| [**`plans/`**](./plans) | Architecture guides, data flow diagrams, and feature design specifications | [Plans Guide](./plans/layout_guide.md) |

---

## 🚀 Deployment

* **Frontend:** Deployed to Firebase Hosting (`https://editorial-look.web.app`). See [nina-app deployment instructions](./nina-app/README.md#deployment-to-firebase-hosting).
* **Backend:** Deployed to Google Cloud Run (`us-central1`). See [nina-service deployment instructions](./nina-service/README.md#deployment-to-google-cloud-run).

---

## 🤝 Contributing

Contributions, bug reports, and suggestions are welcome! For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the Apache 2.0 License.