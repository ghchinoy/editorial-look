# Plan: Flexible Quilted Grid

This plan outlines the implementation of new features to make the quilted grid more flexible and interactive.

### Part 1: Full-Screen Image View with `photo_view`

*   **Task 1.1: Add `photo_view` dependency.**
    *   [x] Add the `photo_view` package to `pubspec.yaml`.
    *   [x] Run `flutter pub get`.

*   **Task 1.2: Implement Full-Screen View.**
    *   [x] Create a new `FullScreenImageView` widget that uses the `PhotoView` widget to display a single image.
    *   [x] In `gallery_screen.dart`, wrap the `StackedImagePreview` widget in a `GestureDetector`.
    *   [x] On tap, navigate to a new route that displays the `FullScreenImageView` with the selected image.
    *   [x] Add a close button to the full-screen view.

*   **Task 1.3: Add image navigation to Full-Screen View.**
    *   [x] Modify the `FullScreenImageView` widget to accept a list of image URLs and an initial index.
    *   [x] Use a `PageView` to display the images.
    *   [x] Add a thumbnail list for navigation.