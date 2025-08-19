# Plan: Gallery and Settings UI/UX Enhancements

This plan outlines the implementation of two key features to improve the user experience of the Nina application.

### Part 1: Enhance Settings Panel

*   **Phase 1.1: Update Slider Labels**
    *   [x] **Task 1.1.1:** In `nina-app/lib/widgets/settings_panel.dart`, modify the `Text` widget for the "Number of Images" slider to display the current value (e.g., "Number of Images: 3").
    *   [x] **Task 1.1.2:** In the same file, modify the `Text` widget for the "Style" slider to display the current style name (e.g., "Style: Fashion").
*   **Phase 1.2: Verification**
    *   [x] **Task 1.2.1:** Run `flutter build web` to ensure the application compiles without errors.
    *   [x] **Task 1.2.2:** Request user to run the app and confirm that the slider labels in the Settings Panel update correctly.

### Part 2: Enhance Full-Screen Image View

*   **Phase 2.1: Add `url_launcher` dependency**
    *   [x] **Task 2.1.1:** Add `url_launcher` to `nina-app/pubspec.yaml`.
    *   [x] **Task 2.1.2:** Run `flutter pub get` in `nina-app` directory.
*   **Phase 2.2: Create Metadata Panel**
    *   [x] **Task 2.2.1:** Create a new file: `nina-app/lib/widgets/metadata_panel.dart`.
    *   [x] **Task 2.2.2:** Implement the `MetadataPanel` widget. It will accept a Firestore document snapshot and the currently displayed image's URL.
    *   [x] **Task 2.2.3:** The panel will display the `prompt`, `style`, `city`, and `editorialCritique`.
    *   [x] **Task 2.2.4:** Add a "Download Image" button to the panel. The button will use `url_launcher` to open the image URL of the currently displayed image.
*   **Phase 2.3: Update `FullScreenImageView`**
    *   [x] **Task 2.3.1:** In `nina-app/lib/widgets/full_screen_image_view.dart`, modify the widget to accept the full Firestore document snapshot instead of just a list of URLs.
    *   [x] **Task 2.3.2:** Change the layout to a `Row` to accommodate the `PhotoViewGallery` on the left and the new `MetadataPanel` on the right.
    *   [x] **Task 2.3.3:** Pass the relevant data to the `MetadataPanel`, including the URL of the currently visible image.
*   **Phase 2.4: Update `GalleryScreen`**
    *   [x] **Task 2.4.1:** In `nina-app/lib/gallery_screen.dart`, update the `onTap` gesture detector to pass the full document snapshot to the `FullScreenImageView`.
*   **Phase 2.5: Verification**
    *   [x] **Task 2.5.1:** Run `flutter build web` to ensure the application compiles without errors.
    *   [x] **Task 2.5.2:** Request user to run the app, navigate to the gallery, open an image in full-screen, and confirm that the metadata panel and download button are working as expected.