import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
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

  // static Future<void> sendFirstMessage(ChatUser chatUser, String msg, Type type) async {
  //   await firestore
  //       .collection('users')
  //       .doc(chatUser.id)
  //       .collection('my_users')
  //       .doc(user.uid)
  //       .set({}).then((value) => sendMessage(chatUser, msg, type)
  //   );
  // }
  // static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();
  //   final Message message = Message(
  //       toId: chatUser.id,
  //       msg: msg,
  //       read: '',
  //       type: type,
  //       fromId: user.uid,
  //       sent: time
  //   );
  //   final ref = firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
  //   await ref.doc(time).set(message.toJson()).then((value) =>
  //       sendPushNotification(chatUser),
  //  static Future<void> userPost(File file) async{
  //    final ext = file.path.split('.').last;
  //    log('Extension: $ext');
  //    final ref = storage.ref().child('post_pictures/${user.uid}.$ext');
  //    await ref
  //        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //        .then((p0) {
  //      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //    });
  //  }
  // static Future<void> pickImage() async{
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(
  //       source: ImageSource.gallery, imageQuality: 80);
  //   if (image != null) {
  //     log('Image Path: ${image.path}');
  //     setState(() {
  //       _image = image.path;
  //     });
  // }
  static Future<void> updatePost(File file, String caption) async {
    String? username;
    FirebaseFirestore.instance.collection("users").
    doc(user.uid)
        .get().then((value) {
      username = value.data()!["username"];
    });
    final date = DateTime.now().toString();
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
      //likes:[],
      id: user.uid,
      name: username!,
      time: DateFormat.jm().format(DateTime.now()),
      comment: '',
      date:DateFormat('EEEE,MMM d,yyyy').format(DateTime.now()),
    );
    await firestore
        .collection('userPost')
        .doc(user.uid)
        .collection('post')
        .doc(date)
        .set(
      userPost.toJson(),
    );
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance.collection("posts")
            .doc(postId)
            .update(
            { "likes": FieldValue.arrayRemove([uid]),}
        );
      }
      else {
        await FirebaseFirestore.instance.collection("posts")
            .doc(postId)
            .update(
            {"likes": FieldValue.arrayUnion([uid]),}
        );
      }
    }
    catch (e) {
      print(e.toString());
    }
  }
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