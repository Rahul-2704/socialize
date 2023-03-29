import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/addPost.dart';
import 'package:socialize/providers/userProvider.dart';
import 'package:socialize/widgets/post_card.dart';
import 'globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialize/models/user.dart' as model;

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  bool request = true;
  String username="";
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  void initState(){
    getUsername();
    super.initState();
  }
  void getUsername() async{
    DocumentSnapshot snap=await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username=(snap.data() as Map<String,dynamic>)['first name'];
    });
    print(username);
  }

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
            automaticallyImplyLeading: false,
            backgroundColor: mode ? Colors.black : Colors.white,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Socialize',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: mode ? Colors.white : Colors.black,
                ),
              ),
            ),
            actions:[
              IconButton(
                  onPressed: (){},
                  icon:const Icon(
                    Icons.messenger_outline,
                    color: Colors.black,
                  )
              )
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.teal,
      // ),
    body:StreamBuilder(
      stream: FirebaseFirestore.instance.collection("posts").snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder:(context,index)=>PostCard(
           snap:snapshot.data?.docs[index].data(),
          ),
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
                  color: mode ? Colors.white : Colors.black,
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
                      MaterialPageRoute(builder: (BuildContext context) => AddPostScreen(),));
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
                      MaterialPageRoute(builder: (BuildContext context) => MyAccount(),));
                },
                icon: Icon(
                  Icons.person_outline_outlined,
                  color: mode ? Colors.white54 : Colors.grey[700],
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
