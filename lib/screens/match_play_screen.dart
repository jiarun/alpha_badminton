import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/match_service.dart';
import '../models/match.dart';
import '../app/app_theme.dart';

class MatchPlayScreen extends StatefulWidget {
  @override
  _MatchPlayScreenState createState() => _MatchPlayScreenState();
}

class _MatchPlayScreenState extends State<MatchPlayScreen> {
  late Match match;
  int playerScore = 0;
  int opponentScore = 0;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the match from the arguments
    match = ModalRoute.of(context)!.settings.arguments as Match;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMatchPoint = playerScore >= match.targetPoints - 1 || 
                             opponentScore >= match.targetPoints - 1;
    final bool isMatchOver = playerScore >= match.targetPoints || 
                            opponentScore >= match.targetPoints;
    final bool playerWon = playerScore >= match.targetPoints;

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
                          // Match Info
                          Container(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  match.isSingles ? 'Singles Match' : 'Doubles Match',
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'First to ${match.targetPoints} points wins',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                if (!match.isSingles && match.partnerName != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Partner: ${match.partnerName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          // Score Display
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
                              children: [
                                Text(
                                  'SCORE',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // Player Score
                                    Column(
                                      children: [
                                        Text(
                                          'YOU',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$playerScore',
                                              style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: isMatchOver
                                              ? null
                                              : () {
                                                  setState(() {
                                                    playerScore++;
                                                  });
                                                },
                                          child: Text('+1'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.primaryColor,
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor: Colors.grey.shade300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // VS
                                    Text(
                                      'VS',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    // Opponent Score
                                    Column(
                                      children: [
                                        Text(
                                          'OPPONENT',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade700,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$opponentScore',
                                              style: TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        ElevatedButton(
                                          onPressed: isMatchOver
                                              ? null
                                              : () {
                                                  setState(() {
                                                    opponentScore++;
                                                  });
                                                },
                                          child: Text('+1'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red.shade700,
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor: Colors.grey.shade300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Match Status
                          if (isMatchPoint && !isMatchOver)
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.amber.shade900),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      playerScore > opponentScore
                                          ? 'Match Point! You need 1 more point to win.'
                                          : 'Danger! Opponent needs 1 more point to win.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (isMatchOver)
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: playerWon
                                    ? AppTheme.primaryColor.withOpacity(0.9)
                                    : Colors.red.shade700.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    playerWon ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    playerWon ? 'You Won!' : 'You Lost!',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Final Score: $playerScore - $opponentScore',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          SizedBox(height: 30),

                          // Action Buttons
                          Row(
                            children: [
                              // Reset Button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      playerScore = 0;
                                      opponentScore = 0;
                                    });
                                  },
                                  icon: Icon(Icons.refresh),
                                  label: Text('RESET'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade700,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              // Save Button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: isLoading || (!isMatchOver && (playerScore > 0 || opponentScore > 0))
                                      ? () => _saveMatch(context)
                                      : null,
                                  icon: Icon(isLoading ? Icons.hourglass_empty : Icons.save),
                                  label: Text(isLoading ? 'SAVING...' : 'SAVE'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (isMatchOver)
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/dashboard',
                                      (route) => false,
                                    );
                                  },
                                  icon: Icon(Icons.home),
                                  label: Text('RETURN TO DASHBOARD'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black87,
                                  ),
                                ),
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

  Future<void> _saveMatch(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final matchService = Provider.of<MatchService>(context, listen: false);

      final bool isMatchOver = playerScore >= match.targetPoints || 
                              opponentScore >= match.targetPoints;
      final bool playerWon = playerScore >= match.targetPoints;

      final result = await matchService.updateMatch(
        matchId: match.id,
        isCompleted: isMatchOver,
        isWin: playerWon,
        playerScore: playerScore,
        opponentScore: opponentScore,
      );

      setState(() {
        isLoading = false;
      });

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match saved successfully')),
        );

        if (isMatchOver) {
          // If match is over, show a dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(playerWon ? 'Congratulations!' : 'Better luck next time!'),
              content: Text(
                playerWon
                    ? 'You won the match with a score of $playerScore-$opponentScore.'
                    : 'You lost the match with a score of $playerScore-$opponentScore.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save match')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
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
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _showExitConfirmation(context),
          ),
          SizedBox(width: 8),
          Text(
            'Match in Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    if (playerScore == 0 && opponentScore == 0) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Match?'),
        content: Text(
          'Your current match progress will be lost if you exit without saving. Do you want to save before exiting?'
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit match screen
            },
            child: Text('EXIT WITHOUT SAVING'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _saveMatch(context);
              Navigator.pop(context); // Exit match screen
            },
            child: Text('SAVE AND EXIT'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog only
            },
            child: Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  // Background image methods - reused from other screens
  Widget _buildBackgroundImage() {
    return FutureBuilder<bool>(
      future: _checkAssetExists('assets/images/badminton_bg.jpg'),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Image.asset(
            'assets/images/badminton_bg.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading background image: $error');
              return _buildGradientBackground();
            },
          );
        } else {
          return _buildGradientBackground();
        }
      },
    );
  }

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
