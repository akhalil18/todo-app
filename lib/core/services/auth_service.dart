import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Auth service class handle autantication requests and return response or error.

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _facebookLogin = FacebookLogin();

  /// Sign in with google.
  /// create user in firebase if it is not exist.
  /// Return firebase user.
  /// Throws an error if fail.
  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      final authentication = await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      // Sign in to firebase
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      // return firebase user
      return authResult.user;
    } catch (e) {
      throw e;
    }
  }

  /// Login in with facebook.
  /// create user in firebase if it is not exist.
  /// Return firebase user.
  /// Throws an error if fail.
  Future<FirebaseUser> loginWithFacebook() async {
    try {
      final result = await _facebookLogin.logIn(['email']);
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      // Sign in to firebase
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      // return firebase user
      return authResult.user;
    } catch (e) {
      throw e;
    }
  }

  /// Signout from google and facebook.
  /// If success return true else return false.
  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _facebookLogin.logOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
