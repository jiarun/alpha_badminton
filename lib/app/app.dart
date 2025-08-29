import 'package:flutter/material.dart';
import 'app_routes.dart'; // Corrected path
import 'app_theme.dart';  // Corrected path

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha App',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
