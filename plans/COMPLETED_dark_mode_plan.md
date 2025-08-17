# Plan: Dark Mode and Theme Choice

## Goal

The user wants to add a dark mode and theme choice to the app, ensuring all UI components are theme-aware.

### Part 1: Define Color Palette & Theme Data

*   **Task 1.1: Define Color Palette.**
    *   [x] Decide on the specific hex color codes for the primary, background, surface, and text colors for both Light and Dark themes.
        *   **Light Theme:**
            *   Primary: `#F20D0D` (Red)
            *   Background: `#FCF8F8` (Light Pinkish)
            *   Surface/Card: `#F4E7E7` (Darker Pinkish)
            *   Text: `#1C0D0D` (Dark Brown/Black)
        *   **Dark Theme (from mock):**
            *   Background: `#231010` (Warm Dark Brown)
            *   Surface/Card: `#492222` (Muted Earthy Red)
            *   Border/Divider: `#683131` (Muted Red)
            *   Primary Text: `#FFFFFF` (White)
            *   Secondary/Accent Text: `#cb9090` (Soft Pinkish-Red)
            *   Primary Action: `#F20D0D` (Vibrant Red)

*   **Task 1.2: Create Custom `ThemeData` Objects.**
    *   [x] Create a new file: `lib/theme.dart`.
    *   [x] In `theme.dart`, create two `ThemeData` objects: `lightTheme` and `darkTheme`.
    *   [x] Use `ColorScheme.fromSeed` with the defined primary color, but override `scaffoldBackgroundColor`, `cardColor`, and text styles to match the palette.

### Part 2: Implement the Theme Provider

*   **Task 2.1: Update `main.dart`.**
    *   [x] The `ValueNotifier` for `themeMode` is already implemented.
    *   [x] Import `theme.dart`.
    *   [x] In the `MaterialApp`, replace the manually created `ThemeData` objects with the new `lightTheme` and `darkTheme` from `theme.dart`.

### Part 3: Refactor UI to Use Theme Colors

*   **Task 3.1: Update `home_screen.dart`.**
    *   [x] Replace all hard-coded colors with theme references.
*   **Task 3.2: Update `gallery_screen.dart`.**
    *   [x] Replace all hard-coded colors with theme references.
*   **Task 3.3: Update `settings_panel.dart`.**
    *   [x] Replace all hard-coded colors with theme references.
*   **Task 3.4: Update `critique_panel.dart`.**
    *   [x] Replace all hard-coded colors with theme references.
*   **Task 3.5: Update `login_screen.dart`.**
    *   [x] Replace all hard-coded colors with theme references.

### Part 4: Implement the Theme Toggle

*   **Task 4.1: Connect the Toggle Button.**
    *   [x] The toggle button is already in the `HomeScreen` app bar.
    *   [x] The `onPressed` callback in `gallery_screen.dart` is connected to the `toggleTheme` function.
    *   [x] Verify the icon correctly switches between `light_mode` and `dark_mode` icons based on the theme's brightness.
