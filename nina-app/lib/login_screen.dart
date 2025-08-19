import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nina/home_screen.dart';
import 'package:nina/config.dart';

/// A screen that provides a login interface for the user.
class LoginScreen extends StatefulWidget {
  /// A callback to toggle the theme of the application.
  final VoidCallback toggleTheme;

  /// Creates a new [LoginScreen] instance.
  const LoginScreen({super.key, required this.toggleTheme});

  @override
  LoginScreenState createState() => LoginScreenState();
}

/// The state for the [LoginScreen].
class LoginScreenState extends State<LoginScreen> {
  /// The Firebase Authentication instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// The Google Sign-In instance.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '64774088793-td1p6p05f27mjn0elqpo0kifol3kk6hn.apps.googleusercontent.com',
    scopes: ['email'],
  );

  // TODO: Refactor to use renderButton instead of signIn.
  // The signIn method is deprecated on the web and will be removed in a future version.
  // See: https://pub.dev/packages/google_sign_in_web#migrating-to-v011-and-v012-google-identity-services
  /// Signs the user in with Google and returns the user's credentials.
  Future<UserCredential> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  /// Checks if the user is authorized to access the application.
  Future<bool> _isUserAuthorized(User user) async {
    final idToken = await user.getIdToken();
    final url = Uri.parse(authServiceUrl);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $idToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isAuthorized'] ?? false;
    } else {
      // Handle error or assume not authorized
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Editorial Look',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAMpgdKg11pMNOwDhmvIqu_77Y0ls8ZRr_0bKeMMK_i3AxhtuxsqrkKuTG7NdDlInKaqUqSvrHkmGI7RmZRoSAfvDChkOHNFa333rKjaQmlmks7383tqnvMKbLle6lXmtHNLAec9qVlb76g20GwRiIXBHblvnnuw7rBMRbEwcgFpGv4vD5EizJQivM9iWd67jWNZ1HrmPPdVSC2IBa9csZEXpKNKx84PJs2-n4cBtkyXlDfOGW1FUJgGr56Ce-oE6XSIHfebpgybSM',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'AI-Powered Runway Looks',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);
                    try {
                      final userCredential = await _signInWithGoogle();
                      if (!mounted) return;

                      final isAuthorized = await _isUserAuthorized(
                        userCredential.user!,
                      );

                      if (!mounted) return;
                      if (isAuthorized) {
                        // ignore: use_build_context_synchronously
                        navigator.pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(toggleTheme: widget.toggleTheme),
                          ),
                        );
                      } else {
                        await _googleSignIn.signOut();
                        await _auth.signOut();
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Access Denied: This account is not authorized.',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;
                      // ignore: use_build_context_synchronously
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('Error during sign-in: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
