import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/match_service.dart';
import '../services/authentication_service.dart';
import '../app/app_theme.dart';
import '../models/user.dart';
import '../widgets/custom_text_field.dart';
import 'dart:math';

class MatchSetupScreen extends StatefulWidget {
  @override
  _MatchSetupScreenState createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  bool _isSingles = true;
  int _targetPoints = 21;
  String? _selectedPartnerId;
  String? _partnerName;
  String? _selectedOpponentId;
  String? _opponentName;
  // For doubles matches
  String? _selectedOpponent1Id;
  String? _opponent1Name;
  String? _selectedOpponent2Id;
  String? _opponent2Name;
  bool _isLoading = false;
  List<Map<String, dynamic>> _players = [];
  final TextEditingController _partnerNameController = TextEditingController();
  final TextEditingController _opponentNameController = TextEditingController();
  final TextEditingController _opponent1NameController = TextEditingController();
  final TextEditingController _opponent2NameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthenticationService>(context, listen: false);
      final matchService = Provider.of<MatchService>(context, listen: false);

      // Get current user
      final currentUser = authService.currentUser;
      final players = await matchService.getPlayers();

      // Filter out the current user from the player list
      final filteredPlayers = players.where((player) => 
        currentUser == null || player['id'].toString() != currentUser.id
      ).toList();

      setState(() {
        _players = filteredPlayers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading players: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _generateRandomName() {
    final names = [
      'Alex', 'Jamie', 'Jordan', 'Taylor', 'Casey', 'Riley',
      'Avery', 'Quinn', 'Morgan', 'Dakota', 'Reese', 'Emerson'
    ];
    final random = Random();
    return names[random.nextInt(names.length)];
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
                          // Title
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
                                  'New Match',
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Set up your badminton match details below.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),

                          // Match Type Selection
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
                                  'Match Type',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isSingles = true;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: _isSingles
                                                ? AppTheme.primaryColor
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: _isSingles
                                                    ? Colors.white
                                                    : Colors.grey.shade700,
                                                size: 30,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Singles',
                                                style: TextStyle(
                                                  color: _isSingles
                                                      ? Colors.white
                                                      : Colors.grey.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isSingles = false;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: !_isSingles
                                                ? AppTheme.primaryColor
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.people,
                                                color: !_isSingles
                                                    ? Colors.white
                                                    : Colors.grey.shade700,
                                                size: 30,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Doubles',
                                                style: TextStyle(
                                                  color: !_isSingles
                                                      ? Colors.white
                                                      : Colors.grey.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Target Points Selection
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
                                  'Target Points',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [11, 15, 21].map((points) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _targetPoints = points;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _targetPoints == points
                                              ? AppTheme.primaryColor
                                              : Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$points',
                                          style: TextStyle(
                                            color: _targetPoints == points
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),

                          // Partner Selection (only for doubles) or Opponent Selection (for singles)
                          SizedBox(height: 20),
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
                                  _isSingles ? 'Your Opponent' : 'Your Partner',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                SizedBox(height: 15),
                                _isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : Column(
                                        children: [
                                          // Dropdown for selecting existing players
                                          if (_players.isNotEmpty)
                                            DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                labelText: 'Select from existing players',
                                                border: OutlineInputBorder(),
                                              ),
                                              value: _isSingles ? _selectedOpponentId : _selectedPartnerId,
                                              items: [
                                                DropdownMenuItem<String>(
                                                  value: null,
                                                  child: Text('-- Select a player --'),
                                                ),
                                                ..._players.map((player) {
                                                  return DropdownMenuItem<String>(
                                                    value: player['id'].toString(),
                                                    child: ConstrainedBox(
                                                      constraints: BoxConstraints(maxWidth: 300), 
                                                      child: Row(
                                                        children: [
                                                          // Profile picture
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            margin: EdgeInsets.only(right: 10),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: AppTheme.primaryColor,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: ClipOval(
                                                              child: player['profile_picture'] != null && player['profile_picture'].toString().isNotEmpty
                                                                  ? Image.network(
                                                                      player['profile_picture'],
                                                                      fit: BoxFit.cover,
                                                                      errorBuilder: (context, error, stackTrace) {
                                                                        return _buildDefaultAvatar(small: true);
                                                                      },
                                                                    )
                                                                  : _buildDefaultAvatar(small: true),
                                                            ),
                                                          ),
                                                          // Player name
                                                          Expanded(
                                                            child: Text(
                                                              player['name'],
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  if (_isSingles) {
                                                    _selectedOpponentId = value;
                                                    if (value != null) {
                                                      final player = _players.firstWhere(
                                                        (p) => p['id'].toString() == value,
                                                      );
                                                      _opponentName = player['name'];
                                                      _opponentNameController.text = '';
                                                    }
                                                  } else {
                                                    _selectedPartnerId = value;
                                                    if (value != null) {
                                                      final player = _players.firstWhere(
                                                        (p) => p['id'].toString() == value,
                                                      );
                                                      _partnerName = player['name'];
                                                      _partnerNameController.text = '';
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          SizedBox(height: 15),
                                          Text(
                                            'OR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 15),
                                          // Text field for entering a new name
                                          CustomTextField(
                                            controller: _isSingles ? _opponentNameController : _partnerNameController,
                                            hint: _isSingles ? 'Enter opponent name' : 'Enter partner name',
                                            prefixIcon: Icons.person_add,
                                          ),
                                          SizedBox(height: 15),
                                          // Random name generator button
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                if (_isSingles) {
                                                  _selectedOpponentId = null;
                                                  _opponentNameController.text = _generateRandomName();
                                                  _opponentName = _opponentNameController.text;
                                                } else {
                                                  _selectedPartnerId = null;
                                                  _partnerNameController.text = _generateRandomName();
                                                  _partnerName = _partnerNameController.text;
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.shuffle),
                                            label: Text('Generate Random Name'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),

                          // Opponents Selection (only for doubles)
                          if (!_isSingles) ...[
                            SizedBox(height: 20),
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
                                    'Opponent Team',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  _isLoading
                                      ? Center(child: CircularProgressIndicator())
                                      : Column(
                                          children: [
                                            // First opponent
                                            Text(
                                              'Opponent 1',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textColor,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            // Dropdown for selecting existing players
                                            if (_players.isNotEmpty)
                                              DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  labelText: 'Select from existing players',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: _selectedOpponent1Id,
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: null,
                                                    child: Text('-- Select a player --'),
                                                  ),
                                                  ..._players.map((player) {
                                                    return DropdownMenuItem<String>(
                                                      value: player['id'].toString(),
                                                      child: ConstrainedBox(
                                                        constraints: BoxConstraints(maxWidth: 300), 
                                                        child: Row(
                                                          children: [
                                                            // Profile picture
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              margin: EdgeInsets.only(right: 10),
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                border: Border.all(
                                                                  color: AppTheme.primaryColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: ClipOval(
                                                                child: player['profile_picture'] != null && player['profile_picture'].toString().isNotEmpty
                                                                    ? Image.network(
                                                                        player['profile_picture'],
                                                                        fit: BoxFit.cover,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          return _buildDefaultAvatar(small: true);
                                                                        },
                                                                      )
                                                                    : _buildDefaultAvatar(small: true),
                                                              ),
                                                            ),
                                                            // Player name
                                                            Expanded(
                                                              child: Text(
                                                                player['name'],
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedOpponent1Id = value;
                                                    if (value != null) {
                                                      final player = _players.firstWhere(
                                                        (p) => p['id'].toString() == value,
                                                      );
                                                      _opponent1Name = player['name'];
                                                      _opponent1NameController.text = '';
                                                    }
                                                  });
                                                },
                                              ),
                                            SizedBox(height: 15),
                                            Text(
                                              'OR',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 15),
                                            // Text field for entering a new name
                                            CustomTextField(
                                              controller: _opponent1NameController,
                                              hint: 'Enter opponent 1 name',
                                              prefixIcon: Icons.person_add,
                                            ),
                                            SizedBox(height: 15),
                                            // Random name generator button
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                setState(() {
                                                  _selectedOpponent1Id = null;
                                                  _opponent1NameController.text = _generateRandomName();
                                                  _opponent1Name = _opponent1NameController.text;
                                                });
                                              },
                                              icon: Icon(Icons.shuffle),
                                              label: Text('Generate Random Name'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.amber,
                                              ),
                                            ),

                                            SizedBox(height: 30),

                                            // Second opponent
                                            Text(
                                              'Opponent 2',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textColor,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            // Dropdown for selecting existing players
                                            if (_players.isNotEmpty)
                                              DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  labelText: 'Select from existing players',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: _selectedOpponent2Id,
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: null,
                                                    child: Text('-- Select a player --'),
                                                  ),
                                                  ..._players.map((player) {
                                                    return DropdownMenuItem<String>(
                                                      value: player['id'].toString(),
                                                      child: ConstrainedBox(
                                                        constraints: BoxConstraints(maxWidth: 300), 
                                                        child: Row(
                                                          children: [
                                                            // Profile picture
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              margin: EdgeInsets.only(right: 10),
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                border: Border.all(
                                                                  color: AppTheme.primaryColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: ClipOval(
                                                                child: player['profile_picture'] != null && player['profile_picture'].toString().isNotEmpty
                                                                    ? Image.network(
                                                                        player['profile_picture'],
                                                                        fit: BoxFit.cover,
                                                                        errorBuilder: (context, error, stackTrace) {
                                                                          return _buildDefaultAvatar(small: true);
                                                                        },
                                                                      )
                                                                    : _buildDefaultAvatar(small: true),
                                                              ),
                                                            ),
                                                            // Player name
                                                            Expanded(
                                                              child: Text(
                                                                player['name'],
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedOpponent2Id = value;
                                                    if (value != null) {
                                                      final player = _players.firstWhere(
                                                        (p) => p['id'].toString() == value,
                                                      );
                                                      _opponent2Name = player['name'];
                                                      _opponent2NameController.text = '';
                                                    }
                                                  });
                                                },
                                              ),
                                            SizedBox(height: 15),
                                            Text(
                                              'OR',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 15),
                                            // Text field for entering a new name
                                            CustomTextField(
                                              controller: _opponent2NameController,
                                              hint: 'Enter opponent 2 name',
                                              prefixIcon: Icons.person_add,
                                            ),
                                            SizedBox(height: 15),
                                            // Random name generator button
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                setState(() {
                                                  _selectedOpponent2Id = null;
                                                  _opponent2NameController.text = _generateRandomName();
                                                  _opponent2Name = _opponent2NameController.text;
                                                });
                                              },
                                              icon: Icon(Icons.shuffle),
                                              label: Text('Generate Random Name'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],

                          SizedBox(height: 30),

                          // Start Match Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _createMatch(context),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'START MATCH',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  Future<void> _createMatch(BuildContext context) async {
    // Validate partner selection for doubles or opponent selection for singles
    if (_isSingles) {
      if (_selectedOpponentId == null && _opponentNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select or enter an opponent name')),
        );
        return;
      }

      // Set opponent name based on selection or text field
      if (_selectedOpponentId != null) {
        final player = _players.firstWhere(
          (p) => p['id'].toString() == _selectedOpponentId,
        );
        _opponentName = player['name'];
      } else {
        _opponentName = _opponentNameController.text;
      }
    } else {
      // For doubles, validate partner and both opponents
      if (_selectedPartnerId == null && _partnerNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select or enter a partner name')),
        );
        return;
      }

      // Set partner name based on selection or text field
      if (_selectedPartnerId != null) {
        final player = _players.firstWhere(
          (p) => p['id'].toString() == _selectedPartnerId,
        );
        _partnerName = player['name'];
      } else {
        _partnerName = _partnerNameController.text;
      }

      // Validate opponent 1
      if (_selectedOpponent1Id == null && _opponent1NameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select or enter opponent 1 name')),
        );
        return;
      }

      // Set opponent 1 name based on selection or text field
      if (_selectedOpponent1Id != null) {
        final player = _players.firstWhere(
          (p) => p['id'].toString() == _selectedOpponent1Id,
        );
        _opponent1Name = player['name'];
      } else {
        _opponent1Name = _opponent1NameController.text;
      }

      // Validate opponent 2
      if (_selectedOpponent2Id == null && _opponent2NameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select or enter opponent 2 name')),
        );
        return;
      }

      // Set opponent 2 name based on selection or text field
      if (_selectedOpponent2Id != null) {
        final player = _players.firstWhere(
          (p) => p['id'].toString() == _selectedOpponent2Id,
        );
        _opponent2Name = player['name'];
      } else {
        _opponent2Name = _opponent2NameController.text;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthenticationService>(context, listen: false);
      final matchService = Provider.of<MatchService>(context, listen: false);

      // Get current user
      final user = authService.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to create a match')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // For doubles, combine opponent names
      String? combinedOpponentName;
      if (!_isSingles && _opponent1Name != null && _opponent2Name != null) {
        combinedOpponentName = "${_opponent1Name} & ${_opponent2Name}";
      }

      final result = await matchService.createMatch(
        userId: user.id,
        isSingles: _isSingles,
        targetPoints: _targetPoints,
        partnerId: _isSingles ? null : _selectedPartnerId,
        partnerName: _isSingles ? null : _partnerName,
        opponentId: _isSingles ? _selectedOpponentId : null,
        opponentName: _isSingles ? _opponentName : combinedOpponentName,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        // Navigate to match play screen
        Navigator.pushNamed(
          context, 
          '/match-play',
          arguments: result['match'],
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Failed to create match')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
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
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 8),
          Text(
            'New Match',
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

  // Default avatar for missing profile pictures
  Widget _buildDefaultAvatar({bool small = false}) {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.2),
      child: Icon(
        Icons.person,
        size: small ? 20 : 50,
        color: AppTheme.primaryColor,
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
