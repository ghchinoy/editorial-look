import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// A widget that displays the critique text from the model.
class CritiquePanel extends StatelessWidget {
  /// The critique text to display.
  final String critiqueText;

  /// Creates a new [CritiquePanel] instance.
  const CritiquePanel({super.key, required this.critiqueText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editor\'s Notes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Markdown(
              data: critiqueText.isEmpty
                  ? 'Generate an image to receive an editorial critique.'
                  : critiqueText,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface),
                h1: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
                h2: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
                h3: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
