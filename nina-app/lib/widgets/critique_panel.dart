import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CritiquePanel extends StatelessWidget {
  final String critiqueText;

  const CritiquePanel({super.key, required this.critiqueText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Editor\'s Notes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
                p: const TextStyle(fontSize: 16, color: Colors.black87),
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
