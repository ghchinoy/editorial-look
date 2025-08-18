# Plan: UX Improvements for Image Display

This document captures potential UX improvements for how generated images are displayed and interacted with on the home screen.

### Part 1: Implement Independent Scrolling `ImageGrid` (High Priority) - IN PROGRESS

*   **The Goal:** Restructure the `home_screen.dart` layout so that the `ImageGrid` can scroll vertically, independent of the prompt input and settings panels above it.

*   **Task 1.1: Refactor the Layout with `Expanded`.**
    *   [x] In `home_screen.dart`, the main `Column` for the left panel needs to be restructured.
    *   [x] The `Row` containing the `TextField` and "Generate" button will remain as is.
    *   [x] The `Wrap` containing the chips will also remain as is.
    *   [x] The `Expanded` widget that currently contains the `Stack` with the `ImageGrid` and `PageView` will be the target of our changes. We will wrap its child in a `Column`.

*   **Task 1.2: Create a Scrollable `ImageGrid`.**
    *   [ ] Inside the new `Column` from the previous step, the `ImageGrid` will be wrapped in an `Expanded` widget. This tells the `ImageGrid` to take up all *available* remaining vertical space, which is the key to making it scrollable.
    *   [ ] The `ImageGrid` itself, being a `GridView` or `StaggeredGrid`, has scrolling built-in. By placing it inside an `Expanded` widget within a `Column`, it will automatically know its boundaries and enable vertical scrolling when its content exceeds that boundary.

*   **Task 1.3: Fix Layout Constraints**
    *   [x] The previous implementation incorrectly used a `SingleChildScrollView` which caused layout issues. This has been removed.
    *   [x] The `ImageGrid`'s container is now correctly wrapped in an `Expanded` widget to ensure it fills the available space and scrolls independently.

*   **Issues & Lessons Learned:**
    *   The initial attempts to implement the scrolling behavior resulted in several layout errors, including `RenderBox was not laid out` and duplicated widgets. This was caused by incorrect assumptions about the widget tree and a series of brittle `replace` commands.
    *   The key lesson learned is that for complex layout changes, it is better to carefully construct the correct widget tree and replace the entire relevant section of code, rather than trying to make a series of small, incremental changes. This avoids leaving the application in a broken state.
    *   The final, stable state of the application has the correct layout, but the scrolling functionality is not yet implemented. This will be the next task to tackle.

### Part 2: Add "View in Gallery" Button (Medium Priority)

*   **The Goal:** Provide a clear call-to-action that takes the user from the generated image set to the full gallery view, pre-filtered or focused on the images they just created.

*   **Task 2.1: Add a "View in Gallery" Button.**
    *   [ ] In `home_screen.dart`, we will add a new `TextButton` or `IconButton` that appears *after* images have been generated. A good place for this would be next to the "Latest Looks" title or directly above the `ImageGrid`.
    *   [ ] The button will be initially hidden and will only become visible when `_generatedImages.isNotEmpty`.

*   **Task 2.2: Implement Navigation to Gallery.**
    *   [ ] The `onPressed` action for this new button will use `Navigator.push`.
    *   [ ] It will navigate to the `GalleryScreen`.
    *   **Crucially,** we will need to modify the `GalleryScreen` to accept an optional parameter: the `id` of the Firestore document for the newly created set of images.
    *   [ ] When the `GalleryScreen` receives this `id`, it can highlight or automatically scroll to that specific set of images, creating that seamless experience you described.
