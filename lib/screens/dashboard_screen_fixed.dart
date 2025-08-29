import 'package:flutter/material.dart';
import '../app/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../services/authentication_service.dart';
import '../services/match_service.dart';
import '../models/user.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _userStats = {
    'totalMatches': 0,
    'winLoss': {'wins': 0, 'losses': 0},
    'winRate': 0,
    'matchTypes': {'singles': 0, 'doubles': 0},
    'recentMatches': 0
  };
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthenticationService>(context, listen: false);
      final matchService = Provider.of<MatchService>(context, listen: false);

      _currentUser = authService.currentUser;

      if (_currentUser != null) {
        final stats = await matchService.getUserStats(_currentUser!.id);
        setState(() {
          _userStats = stats;
        });
      }
    } catch (e) {
      print('Error loading user stats: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: _buildBackgroundImage(),
          ),
          // Overlay with semi-transparent color
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(context),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Section
                          _buildWelcomeSection(context),

                          SizedBox(height: 30),

                          // Stats Cards
                          _buildStatsSection(context),

                          SizedBox(height: 30),

                          // Upcoming Events
                          _buildUpcomingEventsSection(context),

                          SizedBox(height: 30),

                          // New Match Button
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ready to Play?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Start a new badminton match and track your scores.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondaryTextColor,
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/match-setup');
                                    },
                                    icon: Icon(Icons.sports_tennis),
                                    label: Text(
                                      'NEW MATCH',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentColor,
                                      foregroundColor: Colors.black87,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ALPHA APP',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          _buildProfilePicture(),
          SizedBox(width: 15),
          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser != null 
                      ? 'Welcome Back, ${_currentUser!.name ?? _currentUser!.mobileNumber}!' 
                      : 'Welcome Back!',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 10),
                Text(
                  'Your badminton journey continues. Check out your stats and upcoming events below.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: _currentUser?.profilePicture != null && _currentUser!.profilePicture!.isNotEmpty
            ? Image.network(
                _currentUser!.profilePicture!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading profile image: $error');
                  return _buildDefaultAvatar();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.2),
      child: Icon(
        Icons.person,
        size: 50,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    context, 
                    'Games Played', 
                    _userStats['totalMatches'].toString(), 
                    Icons.sports_tennis
                  ),
                  _buildStatCard(
                    context, 
                    'Win Rate', 
                    '${_userStats['winRate']}%', 
                    Icons.emoji_events
                  ),
                  _buildStatCard(
                    context, 
                    'Singles/Doubles', 
                    '${_userStats['matchTypes']['singles']}/${_userStats['matchTypes']['doubles']}', 
                    Icons.people
                  ),
                  _buildStatCard(
                    context, 
                    'Recent Matches', 
                    _userStats['recentMatches'].toString(), 
                    Icons.calendar_today
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: AppTheme.primaryColor),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        _buildEventCard(
          context,
          'Club Tournament',
          'May 15, 2023 • 10:00 AM',
          'Local Sports Center',
          Icons.emoji_events,
        ),
        SizedBox(height: 15),
        _buildEventCard(
          context,
          'Training Session',
          'May 18, 2023 • 6:00 PM',
          'Main Court',
          Icons.fitness_center,
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, String title, String date, String location, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 30),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppTheme.secondaryTextColor),
                    SizedBox(width: 5),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Background image methods
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