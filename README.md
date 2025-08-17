# Nina: Your AI-Powered Creative Director

Nina is an experimental web application designed to be a creative partner for generating high-quality, editorial-style images. It goes beyond simple text-to-image by integrating multiple AI features to assist in the creative process, from ideation to critique.

---

### ✨ Features

*   **AI-Assisted Prompt Engineering:** Don't know what to write? Select a high-level style (e.g., "Fashion," "Business") and a city, and Nina's "Editorial" assistant will generate a set of creative, detailed prompts for you.
*   **Advanced Image Generation:** Generate 1-4 images at a time using Google's Imagen models, with controls for aspect ratio and model selection.
*   **AI-Powered Critique:** After generating images, receive an "Editor's Notes" critique from an AI persona that analyzes your images based on prompt alignment, photorealism, and aesthetic qualities.
*   **Dynamic Viewing Experience:** View your creations in multiple layouts, including a standard grid and two "quilted" staggered layouts for a more editorial feel.
*   **Secure, Shareable, and Persistent:** The application is secured with a server-side authorization service, deployed to Firebase Hosting for easy sharing, and saves all your creations to a personal gallery backed by Firestore.

---

### 🖼️ Application Screenshot

![Nina App Screenshot](https://github.com/user-attachments/assets/9478d7f7-28c8-4f57-b15c-dfef4bbf17f9)

![Nina App Screenshot](https://github.com/user-attachments/assets/a7aff66e-4b6d-4fb5-8740-4690f4f52016)

---

### 📂 Project Structure

This repository is a monorepo containing two main components: the Flutter frontend and the Go backend service.

1.  **`nina-app/`**
    *   This is the main Flutter web application that you interact with in the browser. It contains all the UI, state management, and client-side logic.
    *   **[➡️ Go to the `nina-app` README for setup and deployment instructions](./nina-app/README.md)**

2.  **`nina-service/`**
    *   This is a backend service written in Go. Its primary responsibility is to provide secure, server-side user authorization, checking a user's credentials against a Firestore allowlist.
    *   **[➡️ Go to the `nina-service` README for deployment instructions](./nina-service/README.md)**