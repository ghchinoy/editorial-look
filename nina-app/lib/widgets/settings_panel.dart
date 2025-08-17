import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays the settings panel.
class SettingsPanel extends StatefulWidget {
  /// The currently selected Imagen model.
  final String selectedModel;

  /// The currently selected aspect ratio for image generation.
  final String selectedAspectRatio;

  /// The number of images to generate.
  final double numberOfImages;

  /// The currently selected editorial style.
  final String selectedStyle;

  /// The currently selected city for the editorial style.
  final String? selectedCity;

  /// Whether the creative prompts are currently being generated.
  final bool isGeneratingPrompts;

  /// A callback to handle changes to the selected model.
  final ValueChanged<String?> onModelChanged;

  /// A callback to handle changes to the selected aspect ratio.
  final ValueChanged<String?> onAspectRatioChanged;

  /// A callback to handle changes to the number of images.
  final ValueChanged<double> onNumberOfImagesChanged;

  /// A callback to handle changes to the selected style.
  final ValueChanged<String> onStyleChanged;

  /// A callback to handle changes to the selected city.
  final ValueChanged<String?> onCityChanged;

  /// A callback to generate creative prompts.
  final VoidCallback onGeneratePrompts;

  /// Creates a new [SettingsPanel] instance.
  const SettingsPanel({
    super.key,
    required this.selectedModel,
    required this.selectedAspectRatio,
    required this.numberOfImages,
    required this.selectedStyle,
    required this.selectedCity,
    required this.isGeneratingPrompts,
    required this.onModelChanged,
    required this.onAspectRatioChanged,
    required this.onNumberOfImagesChanged,
    required this.onStyleChanged,
    required this.onCityChanged,
    required this.onGeneratePrompts,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

/// The state for the [SettingsPanel].
class _SettingsPanelState extends State<SettingsPanel>
    with SingleTickerProviderStateMixin {
  /// The controller for the tabs.
  late TabController _tabController;

  /// The value of the style slider.
  late double _styleValue;

  /// The currently selected city.
  String? _selectedCity;

  /// The labels for the style slider.
  final List<String> _styleLabels = ['Business', 'Fashion', 'High Fashion'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _selectedCity = widget.selectedCity;
    _styleValue = _styleLabels.indexOf(widget.selectedStyle).toDouble();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Generation'),
                Tab(text: 'Editorial'),
              ],
              labelColor: Theme.of(context).colorScheme.onSurface,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Generation Tab
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: widget.selectedModel,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          decoration: InputDecoration(
                            labelText: 'Model',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'imagen-4.0-fast-generate-001',
                              child: Text('Imagen 4 Fast'),
                            ),
                            DropdownMenuItem(
                              value: 'imagen-4.0-generate-001',
                              child: Text('Imagen 4'),
                            ),
                          ],
                          onChanged: widget.onModelChanged,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: widget.selectedAspectRatio,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          decoration: InputDecoration(
                            labelText: 'Aspect Ratio',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: '1:1',
                              child: Row(
                                children: [
                                  Icon(Icons.crop_square, color: Theme.of(context).colorScheme.onSurface),
                                  SizedBox(width: 8),
                                  Text('1:1 (1024x1024)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '3:4',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.crop_portrait,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  SizedBox(width: 8),
                                  Text('3:4 (896x1280)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '4:3',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.crop_landscape,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  SizedBox(width: 8),
                                  Text('4:3 (1280x896)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '9:16',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.crop_portrait,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  SizedBox(width: 8),
                                  Text('9:16 (768x1408)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '16:9',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.crop_landscape,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  SizedBox(width: 8),
                                  Text('16:9 (1408x768)'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: widget.onAspectRatioChanged,
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Number of Images',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            Slider(
                              value: widget.numberOfImages,
                              min: 1,
                              max: 4,
                              divisions: 3,
                              label: widget.numberOfImages.round().toString(),
                              onChanged: widget.onNumberOfImagesChanged,
                              activeColor: Theme.of(context).colorScheme.primary,
                              inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Editorial Tab
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Style',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            Slider(
                              value: _styleValue,
                              min: 0,
                              max: 2,
                              divisions: 2,
                              label: _styleLabels[_styleValue.round()],
                              onChanged: (value) {
                                setState(() {
                                  _styleValue = value;
                                });
                                widget.onStyleChanged(
                                  _styleLabels[_styleValue.round()],
                                );
                              },
                              activeColor: Theme.of(context).colorScheme.primary,
                              inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCity,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                          items:
                              const [
                                'London',
                                'Milan',
                                'New York',
                                'Chicago',
                                'LA',
                                'Miami',
                                'Paris',
                                'Santorini',
                                'Tokyo',
                                'Cape Town',
                                'Bali',
                                'Venice',
                                'Iceland',
                                'Dubai',
                                'Marrakech',
                                'Rio de Janeiro',
                                'Rome',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCity = newValue;
                            });
                            widget.onCityChanged(newValue);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildGenerateButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    if (widget.isGeneratingPrompts) {
      return Shimmer.fromColors(
        baseColor: Colors.red[300]!,
        highlightColor: Colors.red[100]!,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text('Generating...'),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: _selectedCity == null ? null : widget.onGeneratePrompts,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        child: const Text('Generate Prompts'),
      );
    }
  }
}
