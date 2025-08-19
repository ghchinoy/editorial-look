import 'dart:math';

import 'package:flutter/material.dart';

/// A widget that displays a stack of images with a playful animation.
class StackedImagePreview extends StatefulWidget {
  /// The list of image URLs to display.
  final List<String> imageUrls;

  /// Creates a new [StackedImagePreview] instance.
  const StackedImagePreview({super.key, required this.imageUrls});

  @override
  StackedImagePreviewState createState() => StackedImagePreviewState();
}

/// The state for the [StackedImagePreview].
class StackedImagePreviewState extends State<StackedImagePreview>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  /// The controller for the animation.
  late AnimationController _controller;
  late List<double> _randomRotations;
  late List<double> _randomOffsets;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Seed the random number generator with the hash code of the image URLs
    // to ensure that the "random" rotation and offset are consistent for
    // the same stack of images.
    final seed = widget.imageUrls.toString().hashCode;
    final random = Random(seed);

    _randomRotations = List.generate(widget.imageUrls.length, (index) {
      // Generate a random rotation between -0.1 and 0.1 radians
      // (approximately -5.7 to 5.7 degrees).
      return (random.nextDouble() - 0.5) * 0.2;
    });

    _randomOffsets = List.generate(widget.imageUrls.length, (index) {
      // Generate a random offset between 0 and 5 pixels.
      return random.nextDouble() * 5.0;
    });

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
              final angle = _randomRotations[index] * _controller.value;
              final offset = (index > 0)
                  ? (10.0 * index + _randomOffsets[index]) * _controller.value
                  : 0.0;

              return Positioned(
                left: offset,
                top: offset,
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(75),
                          blurRadius: 4,
                          offset: const Offset(4, 4),
                        ),
                      ],
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
