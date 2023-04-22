import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:socialize/models/post.dart';
import 'package:socialize/models/user.dart';
import 'package:intl/intl.dart';
import 'package:socialize/models/user.dart' as model;

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.UserAccount> getUserDetails() async{
    User? currentUser = _auth.currentUser;
    DocumentSnapshot snap = await _firestore.collection("users")
        .doc(currentUser!.uid).get();
    return model.UserAccount.fromJson(json as Map<String, dynamic>);
  }
  Future<String> signupUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required List followers,
    required List following,
    required String photoUrl,
    required String bio,
    required String username,
    required bool login,
  })async{
    String res='Some error occurred';
    try{
      if(email.isNotEmpty||password.isNotEmpty||firstName.isNotEmpty||lastName.isNotEmpty){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        model.UserAccount user = model.UserAccount(
          firstname: firstName,
          lastname: lastName,
          username: username,
          login: true,
          bio : bio,
          id: cred.user!.uid,
          password: password,
          email: email,
          following: following,
          followers: followers,
          photoUrl: photoUrl,
        );
        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson(),);
        res="success";
      }
    }catch(err){
      res=err.toString();
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password
  })async{
    String res="Some error occurred";

    try{
      if(email.isNotEmpty||password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,

        );
        res="success";
        FirebaseFirestore
            .instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'login': true,
        });
      }else{
        res="Please enter all the fields";
      }
    }catch(err){
      res=err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await FirebaseFirestore
      .instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        'login': false,
    });
  }
}

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User get user => auth.currentUser!;
  static late UserAccount me;

  static Future<void> profileUpdate(File file) async{
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('photos/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    String url = await ref.getDownloadURL();
    final firestoreInstance = FirebaseFirestore.instance;

    FirebaseAuth _auth=FirebaseAuth.instance;

    firestoreInstance.collection("users").doc(_auth.currentUser!.uid).update(
      {
        "photoUrl" : url,
      },
    );
    // firestoreInstance.collection("posts").doc(postId).update(
    //     {
    //       "profUrl": url,
    //     } );
  }

  static Future<void> deletePost(String postId)async {
    try{
      FirebaseFirestore.instance.collection("posts").doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }

  static Future<void> addPost(File file, String caption) async {
    var uuid = Uuid();
    var pid = uuid.v1();
    String? username;
    String? profUrl;
    FirebaseFirestore.instance.collection("users").
    doc(user.uid)
        .get().then((value) {
      username = value.data()!["username"];
      profUrl = value.data()!["photoUrl"];
    });
    final ext = file.path
        .split('.')
        .last;
    log('Extension: $ext');
    final ref = storage.ref().child('PostOfUsers/${user.uid}/${pid}.$ext');
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
      postId: pid,
      profUrl: profUrl!,
      likes: [],
      name: username!,
      time: DateFormat.jm().format(DateTime.now()),
      date: DateFormat('EEEE,MMM d,yyyy').format(DateTime.now()),
    );
    await firestore
        .collection('userPost')
        .doc(user.uid)
        .collection('post')
        .doc(pid)
        .set(
      userPost.toJson(),
    );
    await firestore
        .collection('posts')
        .doc(pid)
        .set(
        userPost.toJson()
    );
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

  Future<void> followUser(
      String uid,
      String followId
      ) async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }

  static Future<void> likePost(String postId, String id, List likes) async {
    try {
      if (likes.contains(FirebaseAuth.instance.currentUser?.uid)) {
        await FirebaseFirestore.instance.collection("userPost")
            .doc(id)
            .collection("post")
            .doc(postId)
            .update({
          "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid]),
        }
        );
        await FirebaseFirestore.instance.collection("posts")
            .doc(postId)
            .update({
          "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid]),
        });
      }
      else {
        await FirebaseFirestore.instance.collection("userPost")
            .doc(id)
            .collection("post")
            .doc(postId)
            .update({
          "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
        }
        );
        await FirebaseFirestore.instance.collection("posts")
            .doc(postId)
            .update({
          "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
        });
      }
    }
    catch (e) {
      print(e.toString());
    }
  }

  static Future<void> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await FirebaseFirestore.instance.collection("posts").doc(postId)
            .collection("comments").doc(commentId).set({
          "profUrl" : profilePic,
          "comment" : text,
          "username" : name,
          "id" : uid,
          "commentId" : commentId,
          "datePublished" : DateTime.now(),
        });
      }
      else{
        print("Text is empty");
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

}
