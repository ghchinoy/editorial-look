
import 'package:flutter/material.dart';

/// A widget that displays a stack of images with a playful animation.
class StackedImagePreview extends StatefulWidget {
  /// The list of image URLs to display.
  final List<String> imageUrls;

  /// Creates a new [StackedImagePreview] instance.
  const StackedImagePreview({super.key, required this.imageUrls});

  @override
  _StackedImagePreviewState createState() => _StackedImagePreviewState();
}

/// The state for the [StackedImagePreview].
class _StackedImagePreviewState extends State<StackedImagePreview>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  /// The controller for the animation.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        ...widget.imageUrls.asMap().entries.map((entry) {
          final index = entry.key;
          final imageUrl = entry.value;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final angle = (index == 1)
                  ? -0.1 * _controller.value
                  : (index == 2)
                      ? 0.1 * _controller.value
                      : 0.0;
              final offset = (index > 0) ? 10.0 * index * _controller.value : 0.0;

              return Positioned(
                left: offset,
                top: offset,
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        }),
        if (widget.imageUrls.length > 1)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.pink.withAlpha((255 * 0.7).round()),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '+${widget.imageUrls.length - 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}