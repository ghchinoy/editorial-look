import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SettingsPanel extends StatefulWidget {
  final String selectedModel;
  final String selectedAspectRatio;
  final double numberOfImages;
  final String selectedStyle;
  final String? selectedCity;
  final bool isGeneratingPrompts;
  final ValueChanged<String?> onModelChanged;
  final ValueChanged<String?> onAspectRatioChanged;
  final ValueChanged<double> onNumberOfImagesChanged;
  final ValueChanged<String> onStyleChanged;
  final ValueChanged<String?> onCityChanged;
  final VoidCallback onGeneratePrompts;

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

class _SettingsPanelState extends State<SettingsPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late double _styleValue;
  String? _selectedCity;
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
      color: const Color(0xFFF4E7E7),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Generation'),
                Tab(text: 'Editorial'),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black,
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
                          value: widget.selectedModel,
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Model',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE8CECE)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE8CECE)),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFCF8F8),
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
                          value: widget.selectedAspectRatio,
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Aspect Ratio',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE8CECE)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE8CECE)),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFCF8F8),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: '1:1',
                              child: Row(
                                children: [
                                  Icon(Icons.crop_square, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('1:1 (1024x1024)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '3:4',
                              child: Row(
                                children: [
                                  Icon(Icons.crop_portrait, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('3:4 (896x1280)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '4:3',
                              child: Row(
                                children: [
                                  Icon(Icons.crop_landscape, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('4:3 (1280x896)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '9:16',
                              child: Row(
                                children: [
                                  Icon(Icons.crop_portrait, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('9:16 (768x1408)'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: '16:9',
                              child: Row(
                                children: [
                                  Icon(Icons.crop_landscape, color: Colors.black),
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
                            const Text(
                              'Number of Images',
                              style: TextStyle(color: Colors.black),
                            ),
                            Slider(
                              value: widget.numberOfImages,
                              min: 1,
                              max: 4,
                              divisions: 3,
                              label: widget.numberOfImages.round().toString(),
                              onChanged: widget.onNumberOfImagesChanged,
                              activeColor: const Color(0xFFF20D0D),
                              inactiveColor: const Color(0xFFE8CECE),
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
                            const Text(
                              'Style',
                              style: TextStyle(color: Colors.black),
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
                                widget.onStyleChanged(_styleLabels[_styleValue.round()]);
                              },
                              activeColor: const Color(0xFFF20D0D),
                              inactiveColor: const Color(0xFFE8CECE),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCity,
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE8CECE)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFFE8CECE)),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFCF8F8),
                          ),
                          items: const [
                            'London', 'Milan', 'New York', 'LA', 'Miami', 'Paris', 'Santorini', 'Tokyo', 'Cape Town', 'Bali', 'Venice', 'Iceland', 'Dubai', 'Marrakech', 'Rio de Janeiro', 'Rome'
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
                        ElevatedButton(
                          onPressed: _selectedCity == null || widget.isGeneratingPrompts
                              ? null
                              : widget.onGeneratePrompts,
                          child: widget.isGeneratingPrompts
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: const Text('Generating...'),
                                )
                              : const Text('Generate Prompts'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF20D0D),
                            foregroundColor: Colors.white,
                          ),
                        ),
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
}