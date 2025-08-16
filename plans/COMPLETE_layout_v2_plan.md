# Refactoring and Layout v2 Plan

This plan outlines the next phase of development: refactoring the settings panel and implementing a 3-way layout toggle.

- [x] **Step 1: Refactor Settings Panel**
  - [x] Create new file: `lib/widgets/settings_panel.dart`.
  - [x] Create a new `StatefulWidget` named `SettingsPanel`.
  - [x] Move all settings UI and related state from `home_screen.dart` to `settings_panel.dart`.
  - [x] Pass state values and `onChanged` callbacks from `HomeScreen` to `SettingsPanel` as parameters.
  - [x] Update `home_screen.dart` to use the new `SettingsPanel` widget.

- [x] **Step 2: Implement 3-Way Layout Toggle**
  - [x] Create an `ImageLayout` enum with three values: `quiltedContain`, `quiltedCover`, `standardGrid`.
  - [x] In `home_screen.dart`, replace the `_isStaggeredLayout` boolean with the new `_imageLayout` enum.
  - [x] Update the layout toggle button to cycle through the three enum states, changing the icon for each state.
  - [x] Update the `ImageGrid` widget to accept the `ImageLayout` enum.
  - [x] Update the `ImageGrid`'s build logic to render the correct layout (`quilted` with `BoxFit.contain`, `quilted` with `BoxFit.cover`, or `standard` `GridView`) based on the enum value.

- [x] **Step 3: Final Verification**
  - [x] Confirm the application compiles and runs correctly.
  - [x] Confirm the settings panel still controls the generation parameters.
  - [x] Confirm the new 3-way layout toggle works as expected.
