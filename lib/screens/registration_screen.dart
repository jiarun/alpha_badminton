import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication_service.dart';
import '../widgets/custom_text_field.dart';
import '../app/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'login_screen.dart'; // To reuse the background image code
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? _imageFile;
  String? _base64Image;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Read bytes directly from XFile instead of creating a File object
        final bytes = await pickedFile.readAsBytes();

        setState(() {
          // Store the image bytes for display
          _imageBytes = bytes;

          // Only create File object on non-web platforms
          if (!kIsWeb) {
            try {
              _imageFile = File(pickedFile.path);
            } catch (e) {
              print('Error creating File object: $e');
              // Continue without File object, we still have the bytes
            }
          }

          // Convert image to base64 for sending to server
          _base64Image = base64Encode(bytes);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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

                      // Registration Form Card
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
                              'Create Account',
                              style: Theme.of(context).textTheme.displayMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Join our badminton community',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30),
                            // Profile Picture Selection
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _showImageSourceActionSheet,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: _imageBytes != null 
                                          ? MemoryImage(_imageBytes!) 
                                          : null,
                                      child: _imageBytes == null
                                          ? Icon(
                                              Icons.add_a_photo,
                                              size: 30,
                                              color: Colors.grey.shade700,
                                            )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add Profile Picture',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'JPG, JPEG or PNG',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            CustomTextField(
                              controller: _nameController,
                              hint: 'Full Name',
                              prefixIcon: Icons.person,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: _mobileController,
                              hint: 'Mobile Number',
                              prefixIcon: Icons.phone_android,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: _passwordController,
                              hint: 'Password',
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: _confirmPasswordController,
                              hint: 'Confirm Password',
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () async {
                                // Validate input fields
                                if (_nameController.text.isEmpty ||
                                    _mobileController.text.isEmpty || 
                                    _passwordController.text.isEmpty ||
                                    _confirmPasswordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please fill in all fields')),
                                  );
                                  return;
                                }

                                // Check if passwords match
                                if (_passwordController.text != _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Passwords do not match')),
                                  );
                                  return;
                                }

                                final result = await authService.register(
                                  _mobileController.text,
                                  _passwordController.text,
                                  name: _nameController.text,
                                  profilePicture: _base64Image,
                                );
                                if (result) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Registration successful')),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Registration failed')),
                                  );
                                }
                              },
                              child: Text('REGISTER'),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
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
