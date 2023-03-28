import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String lastname;
  final String photoUrl;
  final String firstname;
  final List followers;
  final List following;
  final String password;

  const User(
      {required this.firstname,
        required this.uid,
        required this.lastname,
        required this.photoUrl,
        required this.email,
        required this.followers,
        required this.password,
        required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      firstname: snapshot["firstname"],
      lastname: snapshot["lastname"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      password:snapshot["password"],
    );
  }

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
     "lastname":lastname,
    "uid": uid,
    "email": email,
    "photoUrl": photoUrl,
    "followers": followers,
    "following": following,
    "password":password,
  };
}