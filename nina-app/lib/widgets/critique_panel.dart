import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// A widget that displays the critique text from the model.
class CritiquePanel extends StatelessWidget {
  /// The structured critique to display.
  final Map<String, dynamic>? structuredCritique;

  /// Whether to show the aesthetic scores on the images.
  final bool showAestheticScores;

  /// A callback to handle changes to the aesthetic score visibility.
  final ValueChanged<bool> onShowAestheticScoresChanged;

  /// Creates a new [CritiquePanel] instance.
  const CritiquePanel({
    super.key,
    this.structuredCritique,
    required this.showAestheticScores,
    required this.onShowAestheticScoresChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Editor\'s Notes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Switch(
                value: showAestheticScores,
                onChanged: onShowAestheticScoresChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildCritiqueContent(context),
          ),
        ],
      ),
    );
  }


  Widget _buildCritiqueContent(BuildContext context) {
    if (structuredCritique == null) {
      return const Text('Generate an image to receive an editorial critique.');
    }

    final intro = structuredCritique!['intro'] as String?;
    final imageCritiques = 
        structuredCritique!['image_critiques'] as List<dynamic>?;
    final closing = structuredCritique!['closing'] as String?;

    return ListView(
      children: [
        if (intro != null)
          MarkdownBody(
            data: intro,
            styleSheet: _markdownStyleSheet(context),
          ),
        if (imageCritiques != null)
          ...imageCritiques.map((critique) {
            final critiqueText = critique['critique'] as String?;
            final aestheticScore = critique['aesthetic_score'] as String?;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (critiqueText != null)
                      MarkdownBody(
                        data: critiqueText,
                        styleSheet: _markdownStyleSheet(context),
                      ),
                    if (aestheticScore != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Aesthetic Score: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(aestheticScore),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            );
          }),
        if (closing != null)
          MarkdownBody(
            data: closing,
            styleSheet: _markdownStyleSheet(context),
          ),
      ],
    );
  }

  MarkdownStyleSheet _markdownStyleSheet(BuildContext context) {
    return MarkdownStyleSheet(
      p: TextStyle( 
          fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
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
    );
  }
}

