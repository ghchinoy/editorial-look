# Plan: Structured Editor Critique

This plan outlines the implementation of a structured editor critique feature.

### Part 1: Update the Gemini Prompt

*   **Task 1.1: Modify the `_generateCritique` method.**
    *   [ ] In `home_screen.dart`, locate the `_generateCritique` method.
    *   [ ] Update the prompt to instruct the Gemini model to return a JSON object with the following structure:
        ```json
        {
          "intro": "...",
          "image_critiques": [
            {
              "critique": "...",
              "aesthetic_score": "..."
            }
          ],
          "closing": "..."
        }
        ```

### Part 2: Update the `_generateCritique` Method

*   **Task 2.1: Parse the JSON response.**
    *   [ ] Update the method to parse the JSON response from the Gemini model.
    *   [ ] Store the structured critique in a new state variable (e.g., a `Map<String, dynamic>`).

### Part 3: Update the `CritiquePanel` Widget

*   **Task 3.1: Modify the `CritiquePanel` widget.**
    *   [ ] The widget will now accept the new structured critique object.
    *   [ ] Update the widget to display the intro, per-image critiques, and closing comments in a structured format.

### Part 4: Display the Aesthetic Score

*   **Task 4.1: Add score overlay to images.**
    *   [ ] In the `ImageGrid` widget, add an overlay to each image to display the aesthetic score.
    *   [ ] The score will be retrieved from the structured critique object.

### Part 5: Update Firestore Data Model

*   **Task 5.1: Add new field to Firestore.**
    *   [ ] Add a new field to the `lookbook` documents in Firestore to store the structured critique.
    *   [ ] This will allow us to persist the critique and display it later.