import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/news/news_home.dart';
import 'package:socialize/pages/suggestionPage.dart';
import 'package:socialize/todos/ToDo.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/widgets/postCard.dart';
import 'globals.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
            backgroundColor: mode ? Colors.black87 : Colors.white,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Container(
                    child: Image(
                      height: 25,
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                  SizedBox(width: 1,),
                  Text(
                    'Socialize',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mode ? Colors.white : Colors.black,
                    ),
                  ),
                ]
              ),
            ),
            actions:[
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SuggestionPage(),
                    )
                  );
                },
                icon: Icon(
                  Icons.messenger_outline,
                  color: !mode ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            color: mode ? Colors.grey[900] : Colors.white,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder:(context,index) {
                return PostCard(
                  snap: snapshot.data?.docs[index].data(),
                );
              }
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: mode ? Colors.black87 : Colors.white,
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
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeNews(),
                    )
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) => ToDo(),));
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
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                        MyAccount(
                          id: FirebaseAuth.instance.currentUser!.uid,
                        ),
                    )
                  );
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
