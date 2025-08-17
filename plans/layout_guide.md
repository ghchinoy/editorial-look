# Layout Guide

This document describes the three available image grid layouts in the application.

### 1. Quilted Contain

*   **Icon:** `view_quilt_outlined` (the quilt with a border)
*   **Widget:** `StaggeredGrid`
*   **Configuration:** This layout uses a dynamic quilting pattern. The key feature is `BoxFit.contain`, which ensures the **entire image is always visible** within its tile. If the image's aspect ratio doesn't match the tile, you will see empty space (letterboxing).

### 2. Quilted Cover (Full Bleed)

*   **Icon:** `view_quilt` (the solid quilt)
*   **Widget:** `StaggeredGrid`
*   **Configuration:** This uses the same dynamic quilting pattern as above. The key feature is `BoxFit.cover`, which makes the image **completely fill the tile**, creating a seamless edge-to-edge look. Some parts of the image may be clipped if its aspect ratio doesn't match the tile.

### 3. Standard Grid

*   **Icon:** `grid_view`
*   **Widget:** `GridView.builder`
*   **Configuration:** This is a standard grid where all tiles are the same size. The number of columns matches the "Number of Images" slider, and the aspect ratio of the tiles is determined by the "Aspect Ratio" setting.

### 4. Page View

*   **Icon:** `pageview`
*   **Widget:** `PageView.builder`
*   **Configuration:** This layout displays one image at a time, with the ability to swipe or use buttons to navigate between them.
