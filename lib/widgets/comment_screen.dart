import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/models/user.dart';
import 'comment_card.dart';

class CommentScreen extends StatefulWidget {
  final UserAccount me;
  const CommentScreen({Key?key, required this.me}):super(key: key);
  @override
  _CommentScreenState createState()=>_CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>{
  String? username;
  late String photoUrl='';
  String? uid;
  String? postId;
  TextEditingController _commentController=TextEditingController();
  @override
  Widget build(BuildContext context){
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("users").
    doc(firebaseUser!.uid)
        .get().then((value){
      username=value.data()!["username"];
      uid=value.data()!["uid"];
        });
    FirebaseFirestore.instance.collection("userPosts")
        .doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
          photoUrl=value.data()!["postUrl"];
          postId=value.data()!["postId"];
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(0,0,0,1),
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body:CommentCard(),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16,right:8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  photoUrl,
                ),
                radius: 18,
              ),
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.only(left:16.0,right: 8.0),
                child:TextField(
                  controller: _commentController,
                   decoration: InputDecoration(
                   hintText: 'Comment as ${username}',
                   border: InputBorder.none,
                ),
              ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: TextButton(
                  onPressed: (){
                  APIs.postComment(widget.me,_commentController.text.trim()).then((value){
                     print("Commented successfully");
                    });
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}