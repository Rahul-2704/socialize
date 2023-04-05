import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/todolist.dart';
import '../widgets/post_card.dart';
import 'globals.dart';
import 'package:socialize/api/apis.dart';

class MyPostsPage extends StatefulWidget {
  final String id;
  const MyPostsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  bool request = true;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          child: AppBar(
            leading: BackButton(
              color: mode ? Colors.white : Colors.black,
            ),
            backgroundColor: mode ? Colors.black : Colors.white,
            elevation: 1,
            title: Text(
              'Posts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: mode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection("userPost/${APIs.user.uid}/post").snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder:(context, index) {
              int reversedList = snapshot.data!.docs.length - 1 - index;
              return PostCard(
                snap: snapshot.data?.docs[reversedList].data(),
              );
            },
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        color: mode ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10,),
          child: Row(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => FeedPage(),));
                },
                icon: Icon(
                  Icons.home_outlined,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => NewsScreen(),));
                },
                icon: Icon(
                  Icons.search,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => ToDoScreen(),));
                },
                icon: Icon(
                  Icons.add,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => RequestPage(),));
                },
                icon: Icon(
                  Icons.favorite_border,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => MyAccount(id: FirebaseAuth.instance.currentUser!.uid,),));
                },
                icon: Icon(
                  Icons.person_outline_outlined,
                  color: mode ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
