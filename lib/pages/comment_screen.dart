import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key?key, required this.snap}):super(key: key);
  @override
  _CommentScreenState createState()=>_CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>{
  String? username;
  String? id;
  bool isLoading = false;
  void initState() {
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("users").
    doc(firebaseUser!.uid)
        .get().then((value){
      username = value.data()!["username"];
      id = value.data()!["id"];
    });
    setState(() {
      isLoading = true;
    });
    super.initState();
  }
  void dispose(){
    _commentController.dispose();
    super.dispose();
  }
  TextEditingController _commentController=TextEditingController();
  @override
  Widget build(BuildContext context){
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
                  'https://picsum.photos/id/237/536/354',
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
              InkWell(
                onTap: () async{
                  APIs.postComment(
                    widget.snap['postId'],
                    _commentController.text.trim(),
                    widget.snap['id'],
                    widget.snap['name'],
                    widget.snap['profUrl'],
                  );
                },
                child:Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}