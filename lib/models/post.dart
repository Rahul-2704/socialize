class PostPhoto {
  PostPhoto({
    required this.image,
    required this.caption,
   required this.date,
    required this.name,
    required this.id,
    required this.time,
    required this.comment
  });
  late String image;
  late String caption;
  late String date;
  late String name;
  late String id;
  late String time;
  late String comment;

  PostPhoto.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    caption = json['caption'] ?? '';
    id = json['id'] ?? '';
    date = json['date'] ?? '';
    name = json['name'] ?? '';
    time = json['time'] ?? '';
    comment=json['comment']??'';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['caption'] = caption;
    data['name'] = name;
    data['id'] = id;
    data['date'] = date;
    data['time'] =time;
    data['comment']=comment;

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