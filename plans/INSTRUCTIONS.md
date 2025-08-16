# nina - an image generation application

Let's create a Flutter web application that's protected by Google Login with Firebase that is a generative ai image creator using Gemini and Imagen 4 and has the following features:

* User-entered prompt
* preset prompts
* image generation animation
* settings dialog that has advanced controls
* Generated image
* Save to Google Cloud Storage & Firebase metadata
* gallery of saved images using Firebase metadata


This will use Vertex AI + Firebase AI Logic

https://firebase.google.com/docs/ai-logic/get-started?api=vertex#initialize-service-and-model


```dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Initialize FirebaseApp
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Vertex AI Gemini API backend service
// Create a `GenerativeModel` instance with a model that supports your use case
final model =
      FirebaseAI.vertexAI().generativeModel(model: 'gemini-2.5-flash');

```



https://firebase.google.com/docs/ai-logic/generate-images-imagen?api=vertex

```dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Initialize FirebaseApp
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Vertex AI Gemini API backend service
// Optionally specify a location to access the model (for example, `us-central1`)
final ai = FirebaseAI.vertexAI(location: 'us-central1');

// Create an `ImagenModel` instance with an Imagen model that supports your use case
final model = ai.imagenModel(model: 'imagen-3.0-generate-002');

// Provide an image generation prompt
const prompt = 'An astronaut riding a horse.';

// To generate an image, call `generateImages` with the text prompt
final response = await model.generateImages(prompt);

if (response.images.isNotEmpty) {
  final image = response.images[0];
  // Process the image
} else {
  // Handle the case where no images were generated
  print('Error: No images were generated.');
}
```

```dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Initialize FirebaseApp
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Vertex AI Gemini API backend service
// Optionally specify a location to access the model (for example, `us-central1`)
final ai = FirebaseAI.vertexAI(location: 'us-central1');

// Create an `ImagenModel` instance with an Imagen model that supports your use case
final model = ai.imagenModel(
  model: 'imagen-3.0-generate-002',
  // Configure the model to generate multiple images for each request
  // See: https://firebase.google.com/docs/ai-logic/model-parameters
  generationConfig: ImagenGenerationConfig(numberOfImages: 4),
);

// Provide an image generation prompt
const prompt = 'An astronaut riding a horse.';

// To generate images, call `generateImages` with the text prompt
final response = await model.generateImages(prompt);

// If fewer images were generated than were requested,
// then `filteredReason` will describe the reason they were filtered out
if (response.filteredReason != null) {
  print(response.filteredReason);
}

if (response.images.isNotEmpty) {
  final images = response.images;
  for(var image in images) {
  // Process the image
  }
} else {
  // Handle the case where no images were generated
  print('Error: No images were generated.');
}

```


Project: `ghchinoy-genai-sa`

web app: `nina`

Firebase hosting: editorial-look.web.app

Deploy with

```bash
firebase deploy --only hosting:editorial-look
```


```
const firebaseConfig = {
    apiKey: "***REMOVED***",
    authDomain: "ghchinoy-genai-sa.firebaseapp.com",
    projectId: "ghchinoy-genai-sa",
    storageBucket: "ghchinoy-genai-sa.appspot.com",
    messagingSenderId: "64774088793",
    appId: "1:64774088793:web:178a6acf55131ca707a948",
    measurementId: "G-CSDCDX4C8G"
  };
```

For `firebase.json`:

```
{ 
    "hosting":
    "site": "editorial-look",
}
```

