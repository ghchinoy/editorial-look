# Plan: Gemini Critique Feature

This plan outlines the implementation of a new feature that provides an AI-powered critique of the generated images.

### Part 1: Refactor HomeScreen UI for Critique Panel

- [x] **Task 1.1: Create a new `CritiquePanel` widget.**
  - [x] Create a new file: `lib/widgets/critique_panel.dart`.
  - [x] Define a `StatelessWidget` named `CritiquePanel` that accepts a `String` for the critique text.
  - [x] The UI will be a styled container that displays the critique, or a placeholder if no critique is available.

- [x] **Task 1.2: Split the `HomeScreen` side panel.**
  - [x] In `home_screen.dart`, wrap the `Expanded` widget holding the `SettingsPanel` in a `Column`.
  - [x] This `Column` will contain two `Expanded` children (top and bottom).
  - [x] The top `Expanded` will hold the `SettingsPanel`.
  - [x] The bottom `Expanded` will hold the new `CritiquePanel` widget.

### Part 2: Implement Gemini Critique Generation

- [x] **Task 2.1: Add state management for the critique.**
  - [x] In `HomeScreenState`, add a new state variable: `String _critiqueText = "";`.
  - [x] Pass this variable to the new `CritiquePanel` widget.

- [x] **Task 2.2: Create the `_generateCritique` method.**
  - [x] In `HomeScreenState`, create a new `async` method named `_generateCritique`.
  - [x] This method will be called from the `finally` block of a successful `_generateImage` operation.

- [x] **Task 2.3: Implement the multimodal Gemini call.**
  - [x] Inside `_generateCritique`, construct the detailed prompt using the user-provided template, injecting the original prompt text.
  - [x] Convert the `Uint8List` images from `_generatedImages` into the Base64 `DataPart` format required by the API.
  - [x] Create a `Content` object containing both the text part and the list of image parts.
  - [x] Call the `gemini-1.5-flash` model with this multimodal content.
  - [x] On success, parse the response and update the `_critiqueText` state variable using `setState`.
  - [x] Add appropriate `try...catch` error handling.

### Part 3: Final Verification

- [ ] **Task 3.1: Run `flutter build web`** to ensure the project compiles without errors.
- [ ] **Task 3.2: Test the full feature flow.**
  - [ ] Confirm the UI splits correctly.
  - [ ] Generate an image and confirm the `_generateCritique` method is called.
  - [ ] Verify the critique appears in the `CritiquePanel`.
