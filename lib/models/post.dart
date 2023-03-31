class PostPhoto {
  PostPhoto({
    required this.image,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.name,
    required this.uid,
    required this.date,
  });
  late String image;
  late String caption;
  late int likes;
  late String comments;
  late String name;
  late String uid;
  late String date;

  PostPhoto.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    caption = json['caption'] ?? '';
    uid = json['uid'] ?? '';
    likes = json['likes'] ?? '';
    name = json['name'] ?? '';
    comments = json['comments'] ?? '';
    date = json['date'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['caption'] = caption;
    data['name'] = name;
    data['uid'] = uid;
    data['likes'] = likes;
    data['comments'] = comments;
    data['date'] = date;

    return data;
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Post{
//   final String description;
//   final String uid;
//   final String username;
//   final likes;
//   final String postId;
//   final DateTime datePublished;
//   final String postUrl;
//   final String profImage;
//
//   const Post({
//     required this.description,
//     required this.uid,
//     required this.username,
//     required this.likes,
//     required this.postId,
//     required this.datePublished,
//     required this.postUrl,
//     required this.profImage,
// });
//   Map<String, dynamic> toJson() => {
//     "description":description,
//     "uid":uid,
//     "username":username,
//     "postId":postId,
//     "datePublished":datePublished,
//     "profImage":profImage,
//     "likes":likes,
//     "postUrl":postUrl,
//   };
//
//   static Post fromSnap(DocumentSnapshot snap){
//     var snapshot=snap.data() as Map<String,dynamic>;
//     return Post(
//         description: snapshot["description"],
//         uid: snapshot["uid"],
//         likes: snapshot["likes"],
//         postId: snapshot["postId"],
//         datePublished: snapshot["datePublished"],
//         username: snapshot["username"],
//         postUrl: snapshot['postUrl'],
//         profImage: snapshot['profImage']
//     );
//   }
// }