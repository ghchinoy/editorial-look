# Refactoring Plan: Image Grid

This plan outlines the steps to refactor the image grid from `home_screen.dart` into its own widget.

- [x] **Step 1: Create File Structure**
  - [x] Create `lib/widgets` directory.
  - [x] Create `lib/widgets/image_grid.dart` file.

- [x] **Step 2: Create `ImageGrid` Widget Shell**
  - [x] Define a new `StatelessWidget` named `ImageGrid`.
  - [x] Define the parameters it will accept from `HomeScreen`.

- [x] **Step 3: Move and Fix Logic**
  - [x] Move the `AnimatedSwitcher` and all related grid logic from `home_screen.dart` to `image_grid.dart`.
  - [x] Move helper methods (`_getQuiltedGridTiles`, `_getAspectRatioForLayout`).
  - [x] Create a `_TileData` class to hold grid dimensions.
  - [x] Fix `_getQuiltedGridTiles` to return `List<_TileData>`.
  - [x] Fix all `StaggeredGridTile.count` calls to use the correct named parameters.

- [x] **Step 4: Update `HomeScreen`**
  - [x] Remove the old grid code and helper methods from `home_screen.dart`.
  - [x] Import `package:nina/widgets/image_grid.dart`.
  - [x] Instantiate the new `ImageGrid` widget in the `build` method.

- [x] **Step 5: Final Verification**
  - [x] Confirm the application compiles and runs correctly.
  - [x] Confirm the layout toggling works as expected.
