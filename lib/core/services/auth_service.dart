import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _facebookLogin = FacebookLogin();

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      final authentication = await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      final authResult = await _firebaseAuth.signInWithCredential(credential);

      return authResult.user;
    } catch (e) {
      throw e;
    }
  }

  Future<FirebaseUser> loginWithFacebook() async {
    try {
      final result = await _facebookLogin.logIn(['email']);
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      final authResult = await _firebaseAuth.signInWithCredential(credential);

      return authResult.user;
    } catch (e) {
      throw e;
    }
  }

  Future<GoogleSignInAccount> signInSiligntly() async {
    final account = await _googleSignIn.signInSilently();
    return account;
  }

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

  // Future<void> createUserInFirestore(FirebaseUser user) async {
  //   DocumentSnapshot doc = await userRef.document(user.uid).get();
  //   // check if the user exists in user collection in database according to their id
  //   if (!doc.exists) {
  //     // make new user in fire store
  //     User currentUser = User(
  //       displayName: user.displayName,
  //       email: user.email,
  //       photoUrl: user.photoUrl,
  //       id: user.uid,
  //     );

  //     userRef.document(user.uid).setData(currentUser.toMap());
  //   }
  // }
}
