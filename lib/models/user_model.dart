class UserModel {
  final String name;
  final String uId;
  final String profilePic;
  final String phoneNumber;
  final bool isOnline;
  final List<String> groupId;

  UserModel({
    required this.name,
    required this.uId,
    required this.profilePic,
    required this.phoneNumber,
    required this.isOnline,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uId: map['uId'] ?? '',
      profilePic: map['profilePic'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      isOnline: map['isOnline'] ?? false,
      groupId: List<String>.from(map['groupId']),
    );
  }
}
