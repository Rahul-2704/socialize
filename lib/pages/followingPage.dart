import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialize/widgets/followingCard.dart';

import 'globals.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: !mode ? Colors.black : Colors.white,
        ),
        title: Text(
          'Following',
          style: TextStyle(
            color: !mode ? Colors.black : Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            color: mode ? Colors.grey[900] : Colors.white,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                return FollowingUsers(
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