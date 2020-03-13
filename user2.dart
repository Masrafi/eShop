import 'package:cloud_firestore/cloud_firestore.dart';

class User2 {
  final String username;
  final String displayName;
  final String photoUrl;

  User2({this.displayName, this.photoUrl, this.username});

  factory User2.fromDocument(DocumentSnapshot doc) {
    return User2(
      username: doc['username'],
      displayName: doc['displayName'],
      photoUrl: doc['photoUrl'],
    );
  }
}
