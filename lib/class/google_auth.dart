import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static final _googleSignin = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async {
    await _googleSignin.signOut();


    

    return await _googleSignin.signIn();


  }
}
