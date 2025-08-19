# Plan: Generation Performance Improvements

This plan outlines the refactoring of the image generation process to improve actual and perceived performance.

### Part 1: Parallelize Network Operations

*   **Phase 1.1: Refactor Generation Method**
    *   [x] **Task 1.1.1:** In `nina-app/lib/home_screen.dart`, modify the `_generateImagesAndCritique` method.
    *   [x] **Task 1.1.2:** Use `Future.wait` to execute the Firebase Storage uploads and the Gemini critique generation concurrently.
*   **Phase 1.2: Verification**
    *   [x] **Task 1.2.1:** Run `flutter build web` to ensure the application compiles without errors.
    *   [x] **Task 1.2.2:** Request user to run the app and confirm that image generation still works correctly. The speed improvement may be noticeable.

### Part 2: Implement Optimistic UI Update

*   **Phase 2.1: Decouple UI Update from Firestore Write**
    *   [x] **Task 2.1.1:** In `_generateImagesAndCritique`, move the `setState` call to happen immediately after `Future.wait` completes.
    *   [x] **Task 2.1.2:** Remove the `await` from the `FirebaseFirestore.instance.collection('lookbook').add()` call, allowing it to run in the background.
    *   [x] **Task 2.1.3:** Attach a `.catchError()` block to the Firestore `add` call to log any potential save failures.
*   **Phase 2.2: Verification**
    *   [x] **Task 2.2.1:** Run `flutter build web` to ensure the application compiles without errors.
    *   [x] **Task 2.2.2:** Request user to run the app and confirm that the UI now updates almost instantly after generation finishes, before the data is saved to the gallery.
