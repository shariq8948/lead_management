import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'email',
  'https://www.googleapis.com/auth/calendar',
]);

// Sign in with Google and authenticate with Firebase
Future<User?> signInWithGoogle() async {
  try {
    // Trigger the Google sign-in flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // User canceled sign-in

    // Obtain the authentication details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Check if the tokens are null
    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      print("Error: Missing Google Auth Tokens");
      return null;
    }

    // Create a new credential for Firebase authentication
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase using the Google credentials
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential.user;
  } catch (error) {
    print("Error signing in with Google: $error");
    return null;
  }
}

// Sign out
Future<void> signOut() async {
  await _auth.signOut();
  await _googleSignIn.signOut();
}
