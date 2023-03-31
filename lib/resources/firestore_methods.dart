// import 'dart:typed_data';
// import 'package:socialize/models/post.dart';
// import 'package:socialize/resources/auth_methods.dart' as model;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:socialize/resources/storage_methods.dart';
// import 'package:uuid/uuid.dart';
//
// class FirestoreMethods {
//   final FirebaseFirestore _firestore=FirebaseFirestore.instance;
//   //upload post
//   Future<String> uploadPost(
//       String description,
//       Uint8List file,
//       String uid,
//       String username,
//       //String postUrl,
//       String profImage,
//       ) async{
//     String res='Some error occurred';
//     try{
//       String photoUrl=
//       await StorageMethods().uploadImageToStorage('posts',file,true);
//       String postId=const Uuid().v1();
//       Post post=Post(
//           description: description,
//           uid: uid,
//           username: username,
//           postId:postId ,
//           datePublished:DateTime.now(),
//          postUrl: photoUrl,
//           profImage: profImage,
//          likes:[],
//       );
//       _firestore.collection('posts').doc(postId).set(
//         post.toJson(),
//       );
//       res="success";
//     }catch(err){
//      res=err.toString();
//     }
//     return res;
// }
// }