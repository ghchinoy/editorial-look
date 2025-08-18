import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

/// An enum that represents the different layouts for the image grid.
enum ImageLayout {
  /// A quilted layout where the images are contained within their tiles.
  quiltedContain,

  /// A quilted layout where the images cover their tiles.
  quiltedCover,

  /// A standard grid layout.
  standardGrid,
}

// Private data class to hold tile dimensions
class _TileData {
  const _TileData(this.crossAxisCellCount, this.mainAxisCellCount);
  final int crossAxisCellCount;
  final int mainAxisCellCount;
}

/// A widget that displays a grid of images.
class ImageGrid extends StatelessWidget {
  /// Whether the images are currently being loaded.
  final bool isLoading;

  /// The layout of the grid.
  final ImageLayout layout;

  /// The list of generated images.
  final List<Uint8List> generatedImages;

  /// The number of images to display.
  final double numberOfImages;

  /// The aspect ratio of the images.
  final String selectedAspectRatio;

  /// The structured critique data.
  final Map<String, dynamic>? structuredCritique;

  /// Whether to show the aesthetic scores on the images.
  final bool showAestheticScores;

  /// Creates a new [ImageGrid] instance.
  const ImageGrid({
    super.key,
    required this.isLoading,
    required this.layout,
    required this.generatedImages,
    required this.numberOfImages,
    required this.selectedAspectRatio,
    this.structuredCritique,
    this.showAestheticScores = false,
  });

  // Helper method to get quilted layout patterns
  List<_TileData> _getQuiltedGridTiles(int count) {
    switch (count) {
      case 1:
        return [const _TileData(4, 4)];
      case 2:
        return [const _TileData(2, 4), const _TileData(2, 4)];
      case 3:
        return [
          const _TileData(4, 2),
          const _TileData(2, 2),
          const _TileData(2, 2),
        ];
      case 4:
        return [
          const _TileData(2, 2),
          const _TileData(2, 2),
          const _TileData(2, 2),
          const _TileData(2, 2),
        ];
      default:
        return [const _TileData(4, 4)];
    }
  }

  // Helper method to get aspect ratio for GridView
  double _getAspectRatioForLayout(String ratio) {
    switch (ratio) {
      case '1:1':
        return 1.0;
      case '3:4':
        return 3 / 4;
      case '4:3':
        return 4 / 3;
      case '9:16':
        return 9 / 16;
      case '16:9':
        return 16 / 9;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  for (int i = 0; i < numberOfImages; i++)
                    StaggeredGridTile.count(
                      crossAxisCellCount: _getQuiltedGridTiles(
                        numberOfImages.toInt(),
                      )[i].crossAxisCellCount,
                      mainAxisCellCount: _getQuiltedGridTiles(
                        numberOfImages.toInt(),
                      )[i].mainAxisCellCount,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                ],
              ),
            )
          : generatedImages.isNotEmpty
          ? _buildImageGrid()
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface, //Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Icon(
                  Icons.photo_size_select_actual_outlined,
                  color: Colors.grey[400],
                  size: 100,
                ),
              ),
            ),
    );
  }

  Widget _buildImageGrid() {
    switch (layout) {
      case ImageLayout.quiltedContain:
      case ImageLayout.quiltedCover:
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (int i = 0; i < generatedImages.length; i++)
              StaggeredGridTile.count(
                crossAxisCellCount: _getQuiltedGridTiles(
                  generatedImages.length,
                )[i].crossAxisCellCount,
                mainAxisCellCount: _getQuiltedGridTiles(
                  generatedImages.length,
                )[i].mainAxisCellCount,
                child: _buildImageTile(i),
              ),
          ],
        );
      case ImageLayout.standardGrid:
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numberOfImages.toInt(),
            childAspectRatio: _getAspectRatioForLayout(selectedAspectRatio),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: generatedImages.length,
          itemBuilder: (context, index) {
            return _buildImageTile(index);
          },
        );
    }
  }

  Widget _buildImageTile(int index) {
    final imageCritiques =
        structuredCritique?['image_critiques'] as List<dynamic>?;
    final aestheticScore =
        (showAestheticScores &&
            imageCritiques != null &&
            index < imageCritiques.length)
        ? imageCritiques[index]['aesthetic_score'] as String?
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            generatedImages[index],
            fit: layout == ImageLayout.quiltedCover
                ? BoxFit.cover
                : BoxFit.contain,
          ),
          if (aestheticScore != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Chip(
                label: Text(aestheticScore),
                backgroundColor: Colors.black.withAlpha(128),
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
