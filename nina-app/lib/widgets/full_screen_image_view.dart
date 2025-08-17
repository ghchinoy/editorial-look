import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// A widget that displays a full-screen image view with a gallery of images.
class FullScreenImageView extends StatefulWidget {
  /// The list of image URLs to display.
  final List<String> imageUrls;

  /// The initial index of the image to display.
  final int initialIndex;

  /// Creates a new [FullScreenImageView] instance.
  const FullScreenImageView({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

/// The state for the [FullScreenImageView].
class _FullScreenImageViewState extends State<FullScreenImageView> {
  /// The controller for the [PageView].
  late PageController _pageController;

  /// The current index of the image being displayed.
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PhotoViewGallery.builder(
              itemCount: widget.imageUrls.length,
              pageController: _pageController,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Container(
            height: 80,
            color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(index);
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
