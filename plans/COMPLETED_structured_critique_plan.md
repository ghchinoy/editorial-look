# Plan: Structured Editor Critique

This plan outlines the implementation of a structured editor critique feature.

### Part 1: Update the Gemini Prompt (COMPLETED)

*   [x] Modify the `_generateCritique` method.
*   [x] Update the prompt to return a structured JSON object.
*   [x] Set the `responseMimeType` to `application/json`.

### Part 2: Update the `_generateCritique` Method (COMPLETED)

*   [x] Parse the JSON response.
*   [x] Store the structured critique in a new state variable.

### Part 3: Update the `CritiquePanel` Widget (COMPLETED)

*   [x] Modify the widget to accept the new structured critique object.
*   [x] Update the widget to display the intro, per-image critiques, and closing comments.

### Part 4: Implement Aesthetic Score Overlay & Toggle (COMPLETED)

*   **Task 4.1: Add State for Overlay Visibility.**
    *   [x] In `home_screen.dart`, add a new boolean state variable, e.g., `bool _showAestheticScores = true;`. This will control the visibility of the score overlays.

*   **Task 4.2: Add Toggle to `CritiquePanel`.**
    *   [x] Modify the `CritiquePanel` widget to accept the `_showAestheticScores` boolean and a `ValueChanged<bool>` callback function.
    *   [x] In the `CritiquePanel`, add a `Switch` or `Checkbox` widget next to the "Editor's Notes" title.
    *   [x] The value of the switch will be bound to `_showAestheticScores`, and its `onChanged` event will trigger the callback to update the state in `home_screen.dart`.

*   **Task 4.3: Add Score Overlay to `ImageGrid` and `PageView`.**
    *   [x] Pass the `_structuredCritique` data and the `_showAestheticScores` boolean down to the `ImageGrid` widget.
    *   [x] In the `ImageGrid` widget, when building each image tile, check if `_showAestheticScores` is true and if the corresponding score exists in the critique data.
    *   [x] If both are true, wrap the image in a `Stack` and add a positioned overlay (e.g., in a corner) that displays the `aesthetic_score`.
    *   [x] Apply the same logic to the `PageView.builder` in `home_screen.dart`.

### Part 5: Update Firestore Data Model (COMPLETED)

*   **Task 5.1: Add new field to Firestore.**
    *   [x] In `home_screen.dart`, when a new lookbook document is created, add a new field (e.g., `structuredCritique`) to store the entire JSON critique object from the model.
    *   [x] This will allow us to persist the critique and display it later, including the scores.