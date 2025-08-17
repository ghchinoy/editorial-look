# Plan: Full Image Set Gallery View

This plan outlines the implementation of a new screen to display a full-page grid of images from a single generation, along with their metadata.

### Part 1: Create the `ImageSetScreen`

*   **Task 1.1: Create the new screen file.**
    *   [ ] Create a new file: `lib/image_set_screen.dart`.
    *   [ ] This will be a new route that accepts a document snapshot of a "lookbook" entry as a parameter.

### Part 2: Implement the Layout

*   **Task 2.1: Design the two-column layout.**
    *   [ ] The main layout will consist of two columns.
    *   [ ] The left column will be dedicated to the image grid.
    *   [ ] The right column will serve as a sidebar for metadata.

### Part 3: Implement the Image Grid

*   **Task 3.1: Display all images.**
    *   [ ] The grid will display all images from the `imageUrls` list in the provided document snapshot.
    *   [ ] The grid should be scrollable to accommodate a variable number of images.

### Part 4: Implement the Metadata Sidebar

*   **Task 4.1: Display metadata.**
    *   [ ] The sidebar will display the `prompt`, `editorialCritique`, and other relevant fields from the document snapshot.

### Part 5: Navigation

*   **Task 5.1: Enable navigation from the gallery.**
    *   [ ] In `gallery_screen.dart`, wrap the `StackedImagePreview` widget in a `GestureDetector`.
    *   [ ] When a user taps on the `StackedImagePreview`, navigate to the new `ImageSetScreen`, passing the corresponding document snapshot.