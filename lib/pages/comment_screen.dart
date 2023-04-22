import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget{
  final snap;
  const CommentScreen({Key?key,required this.snap}):super(key:key);
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>{
  late String username = '';
  late String pfp = '';
  late String id = '';
  late bool isLoading1 = true;
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("users").
    doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value) {
      username = value.data()!["username"];
      pfp = value.data()!["photoUrl"];
      id = value.data()!['id'];
      setState(() {
        isLoading1 = false;
      });
    });
  }
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
            'Comments',
        ),
        centerTitle: false,
      ),
      body:StreamBuilder(

        stream: FirebaseFirestore.instance.collection("posts")
            .doc(widget.snap['postId'])
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount:(snapshot.data! as dynamic).docs.length,
            itemBuilder:(context,index) => CommentCard(
              snap:(snapshot.data! as dynamic).docs[index].data(),
            )
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children:[
              isLoading1 ? Center(child:const CircularProgressIndicator()):
              CircleAvatar(
                backgroundImage:NetworkImage(
                  pfp,
                ) ,
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 8.0),
                  child:isLoading1 ? Center(child:const CircularProgressIndicator()):
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Comment as ${username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  await APIs.postComment(
                    widget.snap['postId'],
                    _commentController.text.trim(),
                    id,
                    username,
                    pfp,
                  );
                  setState(() {
                    _commentController.text='';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
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