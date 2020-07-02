import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provier.dart';
import '../../../core/routes/routing_constants.dart';

enum LoginType { Facebook, Google }

class LoginScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Todo List',
              style: TextStyle(fontFamily: 'Signatra', fontSize: 80.0),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                signIn(context, LoginType.Google);
              },
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                signIn(context, LoginType.Facebook);
              },
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/facebook.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context, LoginType type) async {
    final authProvider = context.read<AuthProvider>();
    String error = "Something's wrong, try again later!";

    // try to login
    try {
      final currentUser = (type == LoginType.Facebook)
          ? await authProvider.signInWithFacebook()
          : await authProvider.signInWithGoogle();
      Navigator.of(context)
          .pushReplacementNamed(TasksScreenRoute, arguments: currentUser);

      // if there is an error
    } on PlatformException catch (e) {
      // if email is exist
      if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        showSnack('User already exist!');
      } else {
        showSnack(error);
      }

      // unknown error
    } catch (e) {
      showSnack(error);
    }
  }

  void showSnack(String message) {
    final snackbar =
        SnackBar(content: Text(message), duration: Duration(seconds: 2));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
