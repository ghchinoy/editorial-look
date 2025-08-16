# Nina Project - Technical Architecture Overview

This document provides a high-level technical overview of the Nina project for developers and system architects. Its purpose is to facilitate onboarding and guide future development.

---

## System Architecture

The Nina project follows a modern monorepo architecture with a clear separation between the frontend client and backend services.

-   **`nina-app` (Frontend):** A Flutter web application responsible for all UI, client-side state management, and direct interaction with Firebase services (Firestore, Storage, and Vertex AI).
-   **`nina-service` (Backend):** A containerized Go service responsible for secure, server-side logic that should not be exposed to the client. Its current role is to handle user authorization.

### Data & Logic Flow: Key Scenarios

1.  **User Authentication & Authorization:**
    -   The Flutter app uses the Google Sign-In package to authenticate a user on the client side.
    -   Upon successful sign-in, the client retrieves the user's Firebase ID Token.
    -   This token is sent in the `Authorization: Bearer` header to the `nina-service` `/checkAuth` endpoint.
    -   The Go service verifies the token using the Firebase Admin SDK, which confirms its authenticity and extracts the user's email.
    -   The service then queries the `lookbook_allowlist` collection in Firestore to check for the user's email.
    -   A boolean `isAuthorized` response is returned to the client, which then grants or denies access.
    -   **Key Takeaway:** This pattern is highly secure. The sensitive `lookbook_allowlist` is never queried directly by the client; the client only asks the trusted backend service for a yes/no decision.

2.  **AI-Assisted Prompt Generation:**
    -   The user selects a Style and City in the `SettingsPanel` widget.
    -   This triggers the `_generateCreativePrompts` method in `home_screen.dart`.
    -   A detailed prompt is constructed, instructing the `gemini-1.5-flash` model to return a valid JSON array.
    -   The `generationConfig` for the model is explicitly set to `responseMimeType: 'application/json'` to ensure a structured response.
    -   The client-side logic includes a robust `try...catch` block to handle potential JSON parsing errors from the model.

3.  **Image Generation & Critique:**
    -   The user submits a prompt via the main text field.
    -   The `_generateImage` method is called, which uses the `firebase_ai` package to call the Imagen model.
    -   The generated image bytes are first uploaded to a unique path in the Firebase Storage bucket (`editorial-look/...`).
    -   The public download URL for each image is retrieved.
    -   A new document is created in the `lookbook` Firestore collection, containing these image URLs and other metadata (prompt, user info, style, city).
    -   Crucially, the `finally` block of the image generation process triggers the `_generateCritique` method.
    -   `_generateCritique` sends the *original prompt* and the *generated image bytes* (as Base64 `InlineDataPart` objects) in a multimodal request to the Gemini model.
    -   The returned critique text is rendered in the UI using the `flutter_markdown` package.

---

## Technical Considerations for Future Development

*   **State Management:** The current state management is handled within `HomeScreenState`. As more features are added, consider adopting a more formal state management solution (like Provider or Riverpod) to manage app-wide state more effectively.
*   **Backend Service Expansion:** The `nina-service` is the ideal place for any future logic that requires elevated privileges or should be hidden from the client. Examples could include: managing user roles, interacting with third-party APIs that require secret keys, or performing heavy computational tasks.
*   **Configuration Management:** All client-facing configuration is stored in `nina-app/lib/config.dart`. All sensitive keys and project identifiers are in `nina-app/lib/firebase_options.dart`, which is correctly gitignored. This separation should be maintained.
*   **Security Rules:** The `firestore.rules` are designed to be as restrictive as possible. The `lookbook_allowlist` is inaccessible from the client, and the `lookbook` collection is currently open to any authenticated user to support a future public gallery feature. Any new collections must have corresponding security rules added.
