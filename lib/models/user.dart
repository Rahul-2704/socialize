class UserAccount {
  UserAccount({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.id,
    required this.bio,
    required this.password,
    required this.username,
    required this.following,
    required this.followers,
    required this.photoUrl,
    required this.caption,
  });
  late String firstname;
  late String lastname;
  late String username;
  late String bio;
  late List following;
  late List followers;
  late String id;
  late String password;
  late String photoUrl;
  late String caption;
  late String email;

  UserAccount.fromJson(Map<String, dynamic> json) {
    photoUrl = json['photoUrl'] ?? '';
    caption = json['cation'] ?? '';
    followers = json['bio'] ?? '';
    username = json['username'];
    following = json['following'] ?? '';
    followers = json['followers'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    firstname = json['firstname'] ?? '';
    lastname = json['lastname'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['photoUrl'] = photoUrl;
    data['followers'] = followers;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['password'] = password;
    data['username'] = username;
    data['id'] = id;
    data['caption'] = caption;
    data['email'] = email;
    data['bio'] = bio;
    return data;
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class User {
//   final String email;
//   final String uid;
//   final String lastname;
//   final String photoUrl;
//   final String firstname;
//   final List followers;
//   final List following;
//   final String password;
//
//   const User(
//       {
//         required this.firstname,
//         required this.uid,
//         required this.lastname,
//         required this.photoUrl,
//         required this.email,
//         required this.followers,
//         required this.password,
//         required this.following
//       });
//
//   static User fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//
//     return User(
//
//       firstname: snapshot["firstname"],
//       lastname: snapshot["lastname"],
//       uid: snapshot["uid"],
//       email: snapshot["email"],
//       photoUrl: snapshot["photoUrl"],
//       followers: snapshot["followers"],
//       following: snapshot["following"],
//       password:snapshot["password"],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "firstname": firstname,
//     "lastname":lastname,
//     "uid": uid,
//     "email": email,
//     "photoUrl": photoUrl,
//     "followers": followers,
//     "following": following,
//     "password":password,
//   };
// }
