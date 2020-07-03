import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/auth_provier.dart';
import 'core/providers/tasks_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/routes/router_generator.dart';
import 'core/routes/routing_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  // Get stored theme from sharedPreference befor runnig app.
  await themeProvider.fetchTheme();

  runApp(ChangeNotifierProvider.value(
    value: themeProvider,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<TasksProvider>(create: (_) => TasksProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, ch) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          theme: themeProvider.theme,
          onGenerateRoute: RouterGenerator.generateRoute,
          initialRoute: SplashScreenRoute,
        ),
      ),
    );
  }
}
