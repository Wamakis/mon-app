import "package:cloud_firestore/cloud_firestore.dart";

class User {
  String uid;
  String email;
  List<String> friends;

  User({
    required this.uid,
    required this.email,
    required this.friends,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc['uid'],
      email: doc['email'],
      friends: List<String>.from(doc['friends']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'friends': friends,
    };
  }
}
