import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInMethod {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> logIn() {
    return _googleSignIn.signIn();
  }

  signOut() {
    return _googleSignIn.signOut();
  }
}
