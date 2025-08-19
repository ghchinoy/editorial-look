import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MetadataPanel extends StatelessWidget {
  final DocumentSnapshot document;
  final String currentImageUrl;

  const MetadataPanel({
    super.key,
    required this.document,
    required this.currentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final data = document.data() as Map<String, dynamic>;
    final prompt = data['prompt'] as String?;
    final style = data['style'] as String?;
    final city = data['city'] as String?;
    final userName = data['userName'] as String?;
    final model = data['model'] as String?;
    final aspectRatio = data['aspectRatio'] as String?;
    final createdAt = data['createdAt'] as Timestamp?;
    final critiqueData = data['editorialCritique'];

    Map<String, dynamic>? critique;
    if (critiqueData is Map<String, dynamic>) {
      critique = critiqueData;
    }

    return Container(
      width: 300,
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (prompt != null) ...[
            Text('Prompt', style: Theme.of(context).textTheme.titleMedium),
            Text(prompt),
            const SizedBox(height: 16),
          ],
          if (userName != null) ...[
            Text('Author', style: Theme.of(context).textTheme.titleMedium),
            Text(userName),
            const SizedBox(height: 16),
          ],
          if (style != null) ...[
            Text('Style', style: Theme.of(context).textTheme.titleMedium),
            Text(style),
            const SizedBox(height: 16),
          ],
          if (city != null) ...[
            Text('City', style: Theme.of(context).textTheme.titleMedium),
            Text(city),
            const SizedBox(height: 16),
          ],
          if (model != null) ...[
            Text('Model', style: Theme.of(context).textTheme.titleMedium),
            Text(model),
            const SizedBox(height: 16),
          ],
          if (aspectRatio != null) ...[
            Text('Aspect Ratio', style: Theme.of(context).textTheme.titleMedium),
            Text(aspectRatio),
            const SizedBox(height: 16),
          ],
          if (createdAt != null) ...[
            Text('Created At', style: Theme.of(context).textTheme.titleMedium),
            Text(DateFormat.yMMMd().add_jm().format(createdAt.toDate())),
            const SizedBox(height: 16),
          ],
          if (critique != null) ...[
            Text('Critique', style: Theme.of(context).textTheme.titleMedium),
            if (critique['intro'] != null) Text(critique['intro']),
            const SizedBox(height: 8),
            if (critique['closing'] != null) Text(critique['closing']),
            const SizedBox(height: 16),
          ] else if (critiqueData is String) ...[
            Text('Critique', style: Theme.of(context).textTheme.titleMedium),
            Text(critiqueData),
            const SizedBox(height: 16),
          ],
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                final url = Uri.parse(currentImageUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw Exception('Could not launch $url');
                }
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error downloading image: $e')),
                );
              }
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Image'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
