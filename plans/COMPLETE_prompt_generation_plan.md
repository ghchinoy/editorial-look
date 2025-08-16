# Plan: AI-Assisted Prompt Generation

This plan outlines the implementation of a new feature to generate creative prompts using Gemini 2.5 Flash, organized within a new tabbed interface in the settings panel.

### Part 1: Refactor Settings Panel into a Tabbed Interface

- [x] **Task 1.1: Convert `SettingsPanel` to use a `TabController`.**
  - [x] Modify `settings_panel.dart` to make its `State` class use a `TickerProviderStateMixin`.
  - [x] Initialize a `TabController` in `initState`.

- [x] **Task 1.2: Implement `TabBar` and `TabBarView`.**
  - [x] Add a `TabBar` widget to the top of the settings panel with two tabs: "Generation" and "Editorial".
  - [x] Wrap the main content in a `TabBarView`.

- [x] **Task 1.3: Move Existing Controls.**
  - [x] Move the existing settings (Model, Aspect Ratio, Number of Images) into the first view of the `TabBarView` corresponding to the "Generation" tab.

### Part 2: Build the "Editorial" Tab and Prompt Generation Logic

- [x] **Task 2.1: Create the UI Controls for the "Editorial" Tab.**
  - [x] In the second view of the `TabBarView`, add the new UI controls:
    - [x] A `Slider` for "Style" with 3 stops (Business, Fashion, High Fashion).
    - [x] A `DropdownButtonFormField` for "City" with the specified list of cities.
    - [x] An `ElevatedButton` labeled "Generate Prompts".

- [x] **Task 2.2: Manage State for New Controls.**
  - [x] Add new state variables to `HomeScreenState` for the selected style and city.
  - [x] Pass the new state values and `onChanged` callbacks down to the `SettingsPanel`.

- [x] **Task 2.3: Implement the Gemini Prompt Generation Method.**
  - [x] In `home_screen.dart`, create a new method `_generateCreativePrompts()`.
  - [x] This method will construct a detailed prompt for the Gemini 2.5 Flash model.
  - [x] The prompt will instruct the model to return a valid JSON array of objects, each with a "title" and "prompt" key. *Example: `"Generate 3 creative prompts for a high fashion editorial photoshoot in Paris. Return the response as a valid JSON array..."`*
  - [x] The method will call the Gemini API and handle the response.

### Part 3: Display and Use Generated Prompts

- [x] **Task 3.1: Manage and Display Prompt Suggestions.**
  - [x] Create a new state variable in `HomeScreenState` to hold the list of generated prompt suggestions (e.g., `List<Map<String, String>> _creativePrompts`).
  - [x] In the main UI of `home_screen.dart`, below the primary prompt input, create a `Wrap` widget that maps over `_creativePrompts`.
  - [x] For each item, render a `TextButton` with the prompt's "title".

- [x] **Task 3.2: Implement Button Action.**
  - [x] The `onPressed` action for each generated prompt button will update the `_promptController.text` with the corresponding "prompt" value.

### Part 4: Final Verification

- [x] **Task 4.1: Run `flutter build web`** to ensure the project compiles without errors.
- [ ] **Task 4.2: Test the UI and Logic.**
  - [x] Confirm the tabbed interface works correctly.
  - [x] Confirm the prompt generation button calls the Gemini API.
  - [x] Confirm the suggested prompts are displayed as clickable buttons.
  - [x] Confirm clicking a button populates the main prompt field.
