import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/todolist.dart';
import 'package:socialize/widgets/postCard.dart';
import 'feedPage.dart';
import 'globals.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool showSplash = true;
  late bool isLogin = false;
  late String id = '';

  LoadHome(){
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showSplash = false;
      });
    });
  }

  @override
  void initState() {
  FirebaseFirestore
    .instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get().then((value) {
      isLogin = value.data()!['login'];
      id = value.data()!['id'];
  });
    super.initState();
    LoadHome();
  }

  @override
  Widget build(BuildContext context) {
    return showSplash ? splash() : (isLogin) ? feed() : index();
  }

  Widget splash() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/indexBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Image(
                height: 80,
                image: AssetImage('images/logo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget index() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/indexBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image(
                        height: 50,
                        image: AssetImage('images/logo.png'),
                      ),
                    ),
                  ),
                  Text(
                    'Socialize',
                    style: TextStyle(
                      fontFamily: 'Lobster',
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Text(
                  '- Stay connected and updated',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        icon: Icon(
                            Icons.login
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        label: Text(
                            'Login'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        icon: Icon(
                            Icons.add_box_rounded
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        label: Text(
                            'Register'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget feed() {
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
                  onPressed: () {},
                  icon:const Icon(
                    Icons.messenger_outline,
                    color: Colors.black,
                  )
              )
            ],
          ),
        ),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder:(context,index) {
                return PostCard(
                  snap: snapshot.data?.docs[index].data(),
                );
              }
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