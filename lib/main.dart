import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart'; // Corrected path
import 'services/authentication_service.dart';
import 'services/api_service.dart';
import 'services/match_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<AuthenticationService>(create: (_) => AuthenticationService()),
        ChangeNotifierProvider<MatchService>(create: (_) => MatchService()),
      ],
      child: App(), // Use App instead of MaterialApp
    );
  }
}
