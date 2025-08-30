import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app_theme.dart';
import 'services/authentication_service.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'services/match_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Print the API base URL for debugging (remove in production)
  debugPrint('API Base URL: ${dotenv.env['API_BASE_URL']}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<AuthenticationService>(create: (_) => AuthenticationService()),
        ChangeNotifierProvider<MatchService>(create: (_) => MatchService()),
      ],
      child: MaterialApp(
        title: 'Alpha Badminton',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const App(), // Use App instead of LoginScreen
      ),
    );
  }
}
