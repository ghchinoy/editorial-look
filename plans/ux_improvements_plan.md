# Plan: UX Improvements for Image Display

This document captures potential UX improvements for how generated images are displayed and interacted with on the home screen.

### Part 1: Enable Vertical Scrolling for Image Grids

*   **The Problem:** The current `ImageGrid` and `PageView` layouts are constrained by the vertical height of the main panel. This can cause images to be cut off, especially for non-square aspect ratios, and prevents viewing the aesthetic score overlays if they are out of view.

*   **Task 1.1: Implement Scrolling (Option 1 - Recommended)**
    *   [ ] In `home_screen.dart`, wrap the main `Column` inside the `body`'s `Padding` with a `SingleChildScrollView`.
    *   **Goal:** This will make the entire left-hand panel scrollable, allowing the user to see all generated images and their scores regardless of screen height.

*   **Task 1.2: Investigate Independent Scrolling (Option 2 - Future Consideration)**
    *   [ ] Explore restructuring the layout with `Expanded` and `ListView`/`CustomScrollView` to allow the `ImageGrid` to scroll independently of the prompt and settings panel.
    *   **Goal:** This would provide a more advanced UI where the top panel remains fixed while the image grid scrolls, but it is more complex to implement.

### Part 2: "View All" Button (UX Alternative)

*   **Task 2.1: Add an "Expand" or "View All" Button.**
    *   [ ] Consider adding a button near the `ImageGrid`.
    *   [ ] This button would navigate the user to the dedicated `GalleryScreen` for a full-screen, optimized browsing experience.
    *   **Goal:** Keeps the main creation screen clean while providing a clear path to a more detailed view.
