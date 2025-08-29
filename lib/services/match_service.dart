import 'package:flutter/material.dart';
import '../models/match.dart';
import 'api_service.dart';
import 'dart:convert';

class MatchService with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Match> _matches = [];

  List<Match> get matches => _matches;

  // Create a new match
  Future<Map<String, dynamic>> createMatch({
    required String userId,
    required bool isSingles,
    required int targetPoints,
    String? partnerId,
    String? partnerName,
    String? opponentId,
    String? opponentName,
  }) async {
    try {
      final response = await _apiService.postData('matches', {
        'user_id': userId,
        'is_singles': isSingles ? 1 : 0,
        'target_points': targetPoints,
        'partner_id': partnerId,
        'partner_name': partnerName,
        'opponent_id': opponentId,
        'opponent_name': opponentName,
      });

      if (response['success']) {
        final match = Match.fromJson(response['match']);
        _matches.add(match);
        notifyListeners();
        return {'success': true, 'match': match};
      } else {
        return {'success': false, 'error': response['error'] ?? 'Unknown error'};
      }
    } catch (e) {
      print('Create match error: ${e.toString()}');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Get matches for a user
  Future<bool> getMatches(String userId) async {
    try {
      final response = await _apiService.getData('matches/$userId');

      if (response['success']) {
        _matches = (response['matches'] as List)
            .map((matchJson) => Match.fromJson(matchJson))
            .toList();
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Get matches error: ${e.toString()}');
    }
    return false;
  }

  // Update a match with results
  Future<bool> updateMatch({
    required String matchId,
    required bool isCompleted,
    required bool isWin,
    required int playerScore,
    required int opponentScore,
  }) async {
    try {
      final response = await _apiService.putData('matches/$matchId', {
        'is_completed': isCompleted ? 1 : 0,
        'is_win': isWin ? 1 : 0,
        'player_score': playerScore,
        'opponent_score': opponentScore,
      });

      if (response['success']) {
        // Update the match in the local list
        final index = _matches.indexWhere((m) => m.id == matchId);
        if (index != -1) {
          // Create a new match with updated values
          final updatedMatch = Match(
            id: _matches[index].id,
            userId: _matches[index].userId,
            isSingles: _matches[index].isSingles,
            targetPoints: _matches[index].targetPoints,
            partnerId: _matches[index].partnerId,
            partnerName: _matches[index].partnerName,
            opponentId: _matches[index].opponentId,
            opponentName: _matches[index].opponentName,
            isCompleted: isCompleted,
            isWin: isWin,
            playerScore: playerScore,
            opponentScore: opponentScore,
            date: _matches[index].date,
          );

          _matches[index] = updatedMatch;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      print('Update match error: ${e.toString()}');
    }
    return false;
  }

  // Get all players (for partner selection)
  Future<List<Map<String, dynamic>>> getPlayers() async {
    try {
      final response = await _apiService.getData('players');

      if (response['success']) {
        return List<Map<String, dynamic>>.from(response['players']);
      }
    } catch (e) {
      print('Get players error: ${e.toString()}');
    }
    return [];
  }

  // Get user statistics for dashboard
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final response = await _apiService.getData('user-stats/$userId');

      if (response['success']) {
        return response['stats'];
      }
    } catch (e) {
      print('Get user stats error: ${e.toString()}');
    }
    return {
      'totalMatches': 0,
      'winLoss': {'wins': 0, 'losses': 0},
      'winRate': 0,
      'matchTypes': {'singles': 0, 'doubles': 0},
      'recentMatches': 0
    };
  }
}
