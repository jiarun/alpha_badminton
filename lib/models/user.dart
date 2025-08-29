class User {
  final String id;
  final String mobileNumber;
  final String? name;
  final String? profilePicture;

  User({
    required this.id, 
    required this.mobileNumber,
    this.name,
    this.profilePicture
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // Convert id to String to handle both int and String types
      mobileNumber: json['mobile'],
      name: json['name'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobileNumber,
      'name': name,
      'profile_picture': profilePicture,
    };
  }
}
