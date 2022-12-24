class Status{
final String uid;
final String username;
final String phoneNumber;
final List<String> photoUrl;
final DateTime createdAt;
final String profilePic;
final String statusId;
final List<String> whoCanSee;

  Status(
      {
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });


Map<String, dynamic> toMap() {
  return {
    'uid': uid,
    'username': username,
    'phoneNumber': phoneNumber,
    'photoUrl': photoUrl,
    'createdAt': createdAt,
    'profilePic': profilePic,
    'statusId': statusId,
    'whoCanSee': whoCanSee,
  };
}

factory Status.fromMap(Map<String, dynamic> map) {
  return Status(
    uid: map['uid'] as String,
    username: map['username'] as String,
    phoneNumber: map['phoneNumber'] as String,
    photoUrl: List<String>.from(map['photoUrl']),
    createdAt: map['createdAt'] as DateTime,
    profilePic: map['profilePic'] as String,
    statusId: map['statusId'] as String,
    whoCanSee: List<String>.from(map['whoCanSee']),
  );
}

}