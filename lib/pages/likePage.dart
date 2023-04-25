import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialize/widgets/likeCard.dart';

import 'globals.dart';

class LikePage extends StatefulWidget {
  final postId;
  const LikePage({Key? key, this.postId}) : super(key: key);

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: !mode ? Colors.black : Colors.white,
        ),
        title: Text(
          'Likes',
          style: TextStyle(
            color: !mode ? Colors.black : Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            color: mode ? Colors.grey[900] : Colors.white,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                return LikeUsers(
                  snap: snapshot.data!.docs[index].data(),
                );
              },
            ),
          );
        }
      ),
    );
  }
}