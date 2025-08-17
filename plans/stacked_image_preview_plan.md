# Plan: Stacked Image Preview

This plan outlines the implementation of a new widget to display a stacked preview of generated images.

### Part 1: Research & Analysis

*   **Task 1.1: Evaluate `flutter_image_stack` and `image_stack` packages.**
    *   [x] Review the documentation and examples for both packages to determine which one is a better fit.
    *   [x] Look at the level of customization, ease of use, and overall code quality.
    *   [x] Check their null-safety support and compatibility with our current Flutter version.

*   **Task 1.2: Choose an implementation path.**
    *   [x] If one of the packages is suitable, the plan will be to use it.
    *   [x] If neither package meets our needs, or if they are too restrictive, we will proceed with a custom widget.

### Part 2: Implementation

*   **Task 2.1: Implement the `StackedImagePreview` widget.**
    *   **If using a package:**
        *   [x] Add the chosen package to `pubspec.yaml`.
        *   [x] Create a new widget that wraps the package's widget and provides the necessary styling (2px solid black border).
    *   **If creating a custom widget:**
        *   [x] Create a new file: `lib/widgets/stacked_image_preview.dart`.
        *   [x] The widget will take a list of image URLs as input.
        *   [x] It will use a `Stack` and `Positioned` widgets to create the stacked effect (8px offset, 5-degree rotation).
        *   [x] It will have a 2px solid black border.

*   **Task 2.2: Integrate the `StackedImagePreview` widget.**
    *   [x] In `home_screen.dart`, locate the `ListView` for the "Latest Looks".
    *   [x] Replace the existing `Image.network` widget with the new `StackedImagePreview` widget, passing the `imageUrls` list.
    *   [x] In `gallery_screen.dart`, locate the `GridView`.
    *   [x] Replace the existing `Image.network` widget with the new `StackedImagePreview` widget, passing the `imageUrls` list.

### Part 3: UI/UX Refinements

*   **Task 3.1: Add Image Count Indicator.**
    *   [x] Add a small, styled text overlay on the widget to indicate the number of images in the stack (e.g., "+3").

*   **Task 3.2: Refine styling based on feedback.**
    *   [x] Remove border from the stack.
    *   [x] Add a white border to each individual image.
    *   [x] Change the image count indicator background to pink.

*   **Task 3.3: Fix `RenderFlex` overflow on gallery page.**
    *   [x] Remove the prompt text from the gallery page.

*   **Task 3.4: Add entrance animation.**
    *   [~] Convert the `StackedImagePreview` widget to a `StatefulWidget`.
    *   [~] Use an `AnimationController` and a `Tween` to animate the rotation and offset of the images.
    *   [~] The animation will play when the widget is first loaded, creating a "fanning out" effect.

**Note:** The animation still re-triggers in the 'Latest Looks' `ListView` when the parent widget rebuilds. This is a known issue and will be addressed in a future iteration.