class Match {
  final String id;
  final String userId;
  final bool isSingles;
  final int targetPoints;
  final String? partnerId; // Only for doubles
  final String? partnerName; // Only for doubles
  final String? opponentId; // For singles matches
  final String? opponentName; // For singles matches
  final bool isCompleted;
  final bool isWin;
  final int playerScore;
  final int opponentScore;
  final DateTime date;

  Match({
    required this.id,
    required this.userId,
    required this.isSingles,
    required this.targetPoints,
    this.partnerId,
    this.partnerName,
    this.opponentId,
    this.opponentName,
    required this.isCompleted,
    required this.isWin,
    required this.playerScore,
    required this.opponentScore,
    required this.date,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      isSingles: json['is_singles'] == 1,
      targetPoints: json['target_points'],
      partnerId: json['partner_id']?.toString(),
      partnerName: json['partner_name'],
      opponentId: json['opponent_id']?.toString(),
      opponentName: json['opponent_name'],
      isCompleted: json['is_completed'] == 1,
      isWin: json['is_win'] == 1,
      playerScore: json['player_score'],
      opponentScore: json['opponent_score'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_singles': isSingles ? 1 : 0,
      'target_points': targetPoints,
      'partner_id': partnerId,
      'partner_name': partnerName,
      'opponent_id': opponentId,
      'opponent_name': opponentName,
      'is_completed': isCompleted ? 1 : 0,
      'is_win': isWin ? 1 : 0,
      'player_score': playerScore,
      'opponent_score': opponentScore,
      'date': date.toIso8601String(),
    };
  }
}
