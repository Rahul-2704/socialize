import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialize/models/comment.dart';
import '../models/post.dart';
import 'package:socialize/models/user.dart';
import 'package:intl/intl.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;
  static late UserAccount me;

  static Future<void> profileUpdate(File file) async{
    final ext = file.path
        .split('.')
        .last;
    log('Extension: $ext');
    final ref = storage.ref().child('photos/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    String url = await ref.getDownloadURL();
    final firestoreInstance = FirebaseFirestore.instance;
    FirebaseAuth _auth=FirebaseAuth.instance;
    firestoreInstance.collection("users").doc(_auth.currentUser!.uid).set(
        {
          "photoUrl" : url,
        },
        SetOptions(merge: true)).then((_){
      print(url);
    });
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'username' : me.username,
      'bio' : me.bio,
    });
  }

  static Future<void> updatePost(File file, String caption) async {
    String? username;
    FirebaseFirestore.instance.collection("users").
    doc(user.uid)
        .get().then((value) {
      username = value.data()!["username"];
    });
    final momentOfPost = DateTime.now().toString();
    final ext = file.path
        .split('.')
        .last;
    log('Extension: $ext');
    final ref = storage.ref().child('post_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    String pUrl = await ref.getDownloadURL();
    final PostPhoto userPost = PostPhoto(
      image: pUrl,
      caption: caption,
      id: user.uid,
      name: username!,
      time: DateFormat.jm().format(DateTime.now()),
      date: DateFormat('EEEE,MMM d,yyyy').format(DateTime.now()),
    );
    await firestore
        .collection('userPost')
        .doc(user.uid)
        .collection('post')
        .doc(momentOfPost)
        .set(
      userPost.toJson(),
    );
  }

  // Future<void> likePost(String postId, String uid, List likes) async {
  //   try {
  //     if (likes.contains(uid)) {
  //       await FirebaseFirestore.instance.collection("posts")
  //           .doc(postId)
  //           .update(
  //           { "likes": FieldValue.arrayRemove([uid]),}
  //       );
  //     }
  //     else {
  //       await FirebaseFirestore.instance.collection("posts")
  //           .doc(postId)
  //           .update(
  //           {"likes": FieldValue.arrayUnion([uid]),}
  //       );
  //     }
  //   }
  //   catch (e) {
  //     print(e.toString());
  //   }
  // }

  static Future<void> postComment(UserAccount commentor,String comment)async{
    String? username;
    FirebaseFirestore.instance.collection("users").
    doc(user.uid)
        .get().then((value) {
      username = value.data()!["username"];
    });
    final date = DateTime.now().toString();
    final Comment comments =Comment(
      id: user.uid,
      username: username!,
      time: DateFormat.jm().format(DateTime.now()),
      comment:comment,
    );
    await firestore
        .collection('userPost')
        .doc(user.uid)
        .collection('post')
        .doc(date)
        .collection("comments")
        .doc(commentor.id)
        .set(
        comments.toJson(),
    );
  }
}