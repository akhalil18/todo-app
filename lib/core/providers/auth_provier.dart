import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  var _authService = AuthService();
  String userKey = 'userData';

  /// Implement signIn with google service.
  /// Create user from returned firebase user.
  /// Save user to shared preference.
  /// Return user is success or throw error if fail.
  Future<User> signInWithGoogle() async {
    try {
      final firebaseUser = await _authService.signInWithGoogle();
      final user = User(
        displayName: firebaseUser.displayName,
        email: firebaseUser.email,
        id: firebaseUser.uid,
        photoUrl: firebaseUser.photoUrl,
      );
      // save user to shared preference
      saveUser(user);
      return user;
    } catch (e) {
      throw e;
    }
  }

  /// Implement signIn with facebook service.
  /// Create user from returned firebase user.
  /// Save user to shared preference.
  /// Return user is success or throw error if fail.
  Future<User> signInWithFacebook() async {
    try {
      final firebaseUser = await _authService.loginWithFacebook();
      final user = User(
        displayName: firebaseUser.displayName,
        email: firebaseUser.email,
        id: firebaseUser.uid,
        photoUrl: firebaseUser.photoUrl,
      );
      // save user to shared preference
      saveUser(user);
      return user;
    } catch (e) {
      throw e;
    }
  }

  // Try to auto login.
  Future<User> tryAutoLogIn() async {
    final pref = await SharedPreferences.getInstance();
    // Check if user exist
    if (!pref.containsKey(userKey)) {
      return null;
    }
    // If user exist, return user.
    final extractedData = pref.getString(userKey);
    return User.fromJson(json.decode(extractedData));
  }

  // Save user data to shared preference.
  Future<void> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(userKey, json.encode(user.toJson()));
  }

  /// Implement sign out service.
  /// Remove user data from shared preference.
  /// Return true if signout success, false if fail.
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
