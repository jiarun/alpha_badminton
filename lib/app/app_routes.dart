import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/match_setup_screen.dart';
import '../screens/match_play_screen.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case '/match-setup':
        return MaterialPageRoute(builder: (_) => MatchSetupScreen());
      case '/match-play':
        return MaterialPageRoute(
          builder: (_) => MatchPlayScreen(),
          settings: settings, // Pass the settings to access arguments
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
