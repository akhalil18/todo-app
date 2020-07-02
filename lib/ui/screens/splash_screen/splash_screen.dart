import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provier.dart';
import '../../../core/routes/routing_constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenOrientation = MediaQuery.of(context).orientation;

    Future.delayed(Duration(seconds: 2), () async {
      final authProvider = context.read<AuthProvider>();
      // try to auto sign in
      final currentUser = await authProvider.tryAutoLogIn();
      if (currentUser != null) {
        Navigator.of(context).pushReplacementNamed(
          TasksScreenRoute,
          arguments: currentUser,
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          LoginScreenRoute,
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Todo List',
                style: TextStyle(
                  fontFamily: 'Signatra',
                  color: Colors.green,
                  fontSize:
                      _screenOrientation == Orientation.landscape ? 40 : 60,
                ),
              ),
              Container(
                height: _screenHeight * 0.65,
                child: Image.asset('assets/images/splash.jpg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
