import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication_service.dart';
import '../widgets/custom_text_field.dart';
import '../app/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'login_screen.dart'; // To reuse the background image code

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image - reusing the same method from LoginScreen
          Positioned.fill(
            child: _buildBackgroundImage(),
          ),
          // Overlay with semi-transparent color
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Logo/Title
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 40),
                        child: Column(
                          children: [
                            Text(
                              'ALPHA',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              'APP',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: AppTheme.accentColor,
                                letterSpacing: 8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Forgot Password Form Card
                      Container(
                        width: isSmallScreen ? double.infinity : size.width * 0.4,
                        constraints: BoxConstraints(
                          maxWidth: 450,
                        ),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Forgot Password',
                              style: Theme.of(context).textTheme.displayMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Enter your mobile number to reset your password',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30),
                            CustomTextField(
                              controller: _mobileController,
                              hint: 'Mobile Number',
                              prefixIcon: Icons.phone_android,
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () async {
                                // Validate input field
                                if (_mobileController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please enter your mobile number')),
                                  );
                                  return;
                                }

                                final result = await authService.forgotPassword(
                                  _mobileController.text,
                                );
                                if (result) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Password reset instructions sent')),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to send password reset instructions')),
                                  );
                                }
                              },
                              child: Text('RESET PASSWORD'),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Remember your password? ",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Login'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.primaryColor,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusing the background image code from LoginScreen
  Widget _buildBackgroundImage() {
    // Use AssetImage with error handling
    return FutureBuilder<bool>(
      // Check if asset exists by attempting to load its data
      future: _checkAssetExists('assets/images/badminton_bg.jpg'),
      builder: (context, snapshot) {
        // If asset exists and loaded successfully
        if (snapshot.hasData && snapshot.data == true) {
          return Image.asset(
            'assets/images/badminton_bg.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // If there's an error loading the image, use fallback
              print('Error loading background image: $error');
              return _buildGradientBackground();
            },
          );
        } else {
          // Use fallback gradient if asset doesn't exist or is loading
          return _buildGradientBackground();
        }
      },
    );
  }

  // Helper method to create gradient background
  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E5128), // Dark green
            Color(0xFF4E9F3D), // Medium green
          ],
        ),
      ),
    );
  }

  // Helper method to check if an asset exists
  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      // Check if the asset is the missing badminton background image
      if (assetPath == 'assets/images/badminton_bg.jpg') {
        // Return false to use the gradient background instead
        print('Using gradient background instead of missing image: $assetPath');
        return false;
      }
      // For other assets, we'll let the Image.asset widget handle errors
      return true;
    } catch (e) {
      print('Asset check error: $e');
      return false;
    }
  }
}
