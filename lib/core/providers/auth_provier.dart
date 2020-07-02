import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  var _authService = AuthService();
  String userKey = 'userData';

  Future<User> signInWithGoogle() async {
    try {
      final firebaseUser = await _authService.signInWithGoogle();
      final user = User(
        displayName: firebaseUser.displayName,
        email: firebaseUser.email,
        id: firebaseUser.uid,
        photoUrl: firebaseUser.photoUrl,
      );
      saveUser(user);
      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<User> signInWithFacebook() async {
    try {
      final firebaseUser = await _authService.loginWithFacebook();
      final user = User(
        displayName: firebaseUser.displayName,
        email: firebaseUser.email,
        id: firebaseUser.uid,
        photoUrl: firebaseUser.photoUrl,
      );
      saveUser(user);
      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<User> tryAutoLogIn() async {
    final pref = await SharedPreferences.getInstance();
    // check user data
    if (!pref.containsKey(userKey)) {
      return null;
    }
    final extractedData = pref.getString(userKey);
    return User.fromJson(json.decode(extractedData));
  }

  Future<void> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(userKey, json.encode(user.toJson()));
  }

  // Future<User> signInSiligntly() async {
  //   final signedInUser = await _authService.signInSiligntly();
  //   if (signedInUser != null) {
  //     var user = User(
  //       displayName: signedInUser.displayName,
  //       email: signedInUser.email,
  //       id: signedInUser.id,
  //       photoUrl: signedInUser.photoUrl,
  //     );
  //     currentUser = user;
  //   }
  //   return currentUser;
  // }

  Future<bool> signOut() async {
    bool out = false;
    bool logout = await _authService.signOut();

    if (logout) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove(userKey).then((value) {
        out = value;
      });
    }

    return out;
  }
}
