import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nina/config.dart';
import 'package:nina/gallery_screen.dart';
import 'package:nina/login_screen.dart';
import 'package:nina/widgets/image_grid.dart';
import 'package:nina/widgets/settings_panel.dart';
import 'package:nina/widgets/critique_panel.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  User? _user;
  String _selectedModel = 'imagen-4.0-fast-generate-001';
  String _selectedAspectRatio = '1:1';
  double _numberOfImages = 3;
  final TextEditingController _promptController = TextEditingController();
  List<Uint8List> _generatedImages = [];
  ImageLayout _imageLayout = ImageLayout.quiltedContain;
  String _selectedStyle = 'Fashion';
  String? _selectedCity = 'New York';
  List<Map<String, String>> _creativePrompts = [];
  bool _isGeneratingPrompts = false;
  String _critiqueText = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _showErrorDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(message)]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ImagenAspectRatio _getAspectRatio(String ratio) {
    switch (ratio) {
      case '1:1':
        return ImagenAspectRatio.square1x1;
      case '3:4':
        return ImagenAspectRatio.portrait3x4;
      case '4:3':
        return ImagenAspectRatio.landscape4x3;
      case '9:16':
        return ImagenAspectRatio.portrait9x16;
      case '16:9':
        return ImagenAspectRatio.landscape16x9;
      default:
        return ImagenAspectRatio.square1x1;
    }
  }

  Future<String> _uploadImage(Uint8List imageBytes) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageName =
        'editorial-look/${DateTime.now().millisecondsSinceEpoch}.png';
    final imageRef = storageRef.child(imageName);
    await imageRef.putData(imageBytes);
    return await imageRef.getDownloadURL();
  }

  Future<void> _generateImage() async {
    if (_promptController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _generatedImages = [];
      _critiqueText = ""; // Reset the critique text
    });

    try {
      final ai = FirebaseAI.vertexAI(location: 'us-central1');
      final model = ai.imagenModel(
        model: _selectedModel,
        generationConfig: ImagenGenerationConfig(
          numberOfImages: _numberOfImages.toInt(),
          aspectRatio: _getAspectRatio(_selectedAspectRatio),
        ),
      );

      final response = await model.generateImages(_promptController.text);

      if (response.images.isNotEmpty) {
        final imageUrls = <String>[];
        for (final image in response.images) {
          final imageUrl = await _uploadImage(image.bytesBase64Encoded);
          imageUrls.add(imageUrl);
        }

        setState(() {
          _generatedImages = response.images
              .map((e) => e.bytesBase64Encoded)
              .toList();
        });

        await FirebaseFirestore.instance.collection('lookbook').add({
          'imageUrls': imageUrls,
          'prompt': _promptController.text,
          'uid': _user!.uid,
          'userName': _user!.displayName,
          'userEmail': _user!.email,
          'createdAt': FieldValue.serverTimestamp(),
          'style': _selectedStyle,
          'city': _selectedCity,
          'presetCategory': '', // Kept for future use
          'geminiCategory': '', // Kept for future use
          'geminiRating': '', // Kept for future use
          'editorialCritique': '', // Kept for future use
        });
      } else {
        print('Error: No images were generated.');
        _showErrorDialog('Error Generating Image', 'No images were generated.');
      }
    } catch (e) {
      print('Error generating image: $e');
      _showErrorDialog('Error Generating Image', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
      _generateCritique();
    }
  }

  Future<void> _generateCritique() async {
    if (_generatedImages.isEmpty) return;

    setState(() {
      _critiqueText = 'Generating critique...';
    });

    try {
      final model = FirebaseAI.vertexAI().generativeModel(
        model: 'gemini-2.5-flash',
      );
      final prompt =
          '''
        You're a friendly visual magazine editor who loves AI generated images with Imagen 4, Google's latest image generation model whose quality exceeds all leading external competitors in aesthetics, defect-free, and text image alignment. You are always friendly and positive and not shy to provide critiques with delightfully cheeky, clever streak. You've been presented with these images for your thoughts.

        The prompt used by the author to create these images was: "${_promptController.text}"
            
        Create a few sentence critique and commentary (3-4 sentences) complimenting each these images individually and together, paying special attention to quality of each image such calling out anything you notice in these following areas:
        * Alignment with prompt - how well each image mached the given text prompt
        * Photorealism - how closely the image resembles the type of image requested to be generated
        * Detail - the level of detail and overall clarity
        * Defects - any visible artifacts, distortions, or errors

        Include aesthetic qualities (come up with a score). Include commentary on color, tone, subject, lighting, and composition. You may address the author as "you."
      ''';

      final imageParts = _generatedImages.map((imageBytes) {
        return InlineDataPart('image/png', imageBytes);
      }).toList();

      final response = await model.generateContent([
        Content.multi([TextPart(prompt), ...imageParts]),
      ]);

      if (response.text != null) {
        setState(() {
          _critiqueText = response.text!;
        });
      } else {
        setState(() {
          _critiqueText = 'Could not generate a critique for this image.';
        });
      }
    } catch (e) {
      setState(() {
        _critiqueText = 'Error generating critique: $e';
      });
    }
  }

  Future<void> _generateCreativePrompts() async {
    setState(() {
      _isGeneratingPrompts = true;
      _creativePrompts = [];
    });

    try {
      final model = FirebaseAI.vertexAI().generativeModel(
        model: 'gemini-2.5-flash',
      );
      final prompt =
          '''
        Generate 3-5 creative prompts for images a model shoot that has grain, cinematic, warm lights, etc.
        The editorial style is "$_selectedStyle" and the background location is "$_selectedCity".
        Be specific about editorial locations within the city chosen to add detail and color to the photo shoot, mentioning the area within the city. Utilize the editorial style to determine the additional qualities of what the photo should look like. You may mention a magazine's name as a reference style.

        Return the response as a valid JSON array where each object has a "title" and a "prompt" key.

        Example (Fashion: Vogue, City: New York):
        [
          {
            "title": "SoHo Cobblestones & Cast Iron",
            "prompt": "A high fashion editorial photograph of a model walking down a cobblestone street in SoHo, New York. She wears an avant-garde trench coat. The shot is cinematic, with a noticeable grainy texture, capturing the warm, golden hour light reflecting off the cast-iron buildings. The mood is candid and effortlessly chic, reminiscent of a 90s Vogue photoshoot."
          }
        ]
      ''';

      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        try {
          // The response is often wrapped in markdown, so we need to clean it.
          final cleanJson = response.text!
              .replaceAll('```json\n', '')
              .replaceAll('```', '')
              .trim();
          final decoded = jsonDecode(cleanJson) as List<dynamic>;
          setState(() {
            _isGeneratingPrompts = true;
            _creativePrompts = decoded
                .map(
                  (e) => {
                    'title': e['title'] as String,
                    'prompt': e['prompt'] as String,
                  },
                )
                .toList();
          });
        } catch (e) {
          print('Error parsing JSON response from Gemini:');
          print(response.text);
          _showErrorDialog(
            'Error Parsing Response',
            'The model returned an unexpected response. Please try again.\n\nError: $e',
          );
        }
      } else {
        _showErrorDialog('Error', 'Failed to generate creative prompts.');
      }
    } catch (e) {
      _showErrorDialog('Error Generating Prompts', e.toString());
    } finally {
      setState(() {
        _isGeneratingPrompts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.string(
              '''
              <svg viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g clip-path="url(#clip0_6_330)">
                  <path
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M24 0.757355L47.2426 24L24 47.2426L0.757355 24L24 0.757355ZM21 35.7574V12.2426L9.24264 24L21 35.7574Z"
                    fill="currentColor"
                  ></path>
                </g>
                <defs>
                  <clipPath id="clip0_6_330"><rect width="48" height="48" fill="white"></rect></clipPath>
                </defs>
              </svg>
              ''',
              width: 24,
              height: 24,
              color: const Color(0xFF1C0D0D),
            ),
            const SizedBox(width: 8),
            const Text(
              'Editorial Look',
              style: TextStyle(
                color: Color(0xFF1C0D0D),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 32),
            TextButton(
              onPressed: () {},
              child: Text(
                'Create',
                style: TextStyle(
                  color: Color(0xFF1C0D0D),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GalleryScreen(),
                  ),
                );
              },
              child: Text(
                'Gallery',
                style: TextStyle(
                  color: Color(0xFF1C0D0D),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _imageLayout =
                    ImageLayout.values[(_imageLayout.index + 1) %
                        ImageLayout.values.length];
              });
            },
            icon: Icon(
              _imageLayout == ImageLayout.quiltedContain
                  ? Icons.view_quilt_outlined
                  : _imageLayout == ImageLayout.quiltedCover
                  ? Icons.view_quilt
                  : Icons.grid_view,
              color: const Color(0xFF1C0D0D),
            ),
          ),
          if (_user?.photoURL != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'logout') {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen(toggleTheme: widget.toggleTheme),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(_user!.photoURL!),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                  child: (_user?.photoURL == null || _user!.photoURL!.isEmpty)
                      ? Text(_user!.displayName![0])
                      : null,
                ),
              ),
            ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promptController,
                          style: TextStyle(color: Colors.black),
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter your prompt',
                            hintStyle: TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Color(0xFFF4E7E7),
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _generateImage,
                        child: Text('Generate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF20D0D),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      if (_selectedCity != null)
                        Chip(
                          avatar: const Icon(Icons.location_city),
                          label: Text(_selectedCity!),
                        ),
                      Chip(
                        avatar: const Icon(Icons.style),
                        label: Text(_selectedStyle),
                      ),
                      if (_isGeneratingPrompts)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: List.generate(
                              3,
                              (_) => const Chip(label: Text('          ')),
                            ),
                          ),
                        )
                      else
                        ..._creativePrompts.map(
                          (prompt) => TextButton(
                            onPressed: () {
                              _promptController.text = prompt['prompt']!;
                            },
                            child: Text(prompt['title']!),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ImageGrid(
                      isLoading: _isLoading,
                      layout: _imageLayout,
                      generatedImages: _generatedImages,
                      numberOfImages: _numberOfImages,
                      selectedAspectRatio: _selectedAspectRatio,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Latest Looks',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C0D0D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('lookbook')
                          .where('uid', isEqualTo: _user!.uid)
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No saved images yet.'));
                        }

                        final documents = snapshot.data!.docs;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final doc = documents[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SizedBox(
                                width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.network(
                                          doc['imageUrls'][0],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              elevation: 0,
              color: const Color(0xFFF4E7E7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SettingsPanel(
                      selectedModel: _selectedModel,
                      selectedAspectRatio: _selectedAspectRatio,
                      numberOfImages: _numberOfImages,
                      selectedStyle: _selectedStyle,
                      selectedCity: _selectedCity,
                      isGeneratingPrompts: _isGeneratingPrompts,
                      onModelChanged: (value) {
                        setState(() {
                          _selectedModel = value!;
                        });
                      },
                      onAspectRatioChanged: (value) {
                        setState(() {
                          _selectedAspectRatio = value!;
                        });
                      },
                      onNumberOfImagesChanged: (value) {
                        setState(() {
                          _numberOfImages = value;
                        });
                      },
                      onStyleChanged: (value) {
                        setState(() {
                          _selectedStyle = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                      onGeneratePrompts: _generateCreativePrompts,
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE8CECE)),
                  Expanded(child: CritiquePanel(critiqueText: _critiqueText)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
