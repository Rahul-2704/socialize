import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socialize/todos/AddToDo.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/todos/viewToDo.dart';
import 'package:socialize/todos/ToDoCard.dart';
import 'package:socialize/news/news_home.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/globals.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List<Select> selected = [];
  late String firstName = '';
  bool fetch = false;

  @override
  void initState() {
    FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get().then((value){
      firstName = value.data()!['firstname'];
    });
    print(firstName);
    setState(() {
      fetch = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Text(
          'Hello ' + firstName,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AddToDo(),
                  )
                );
              },
              icon: Icon(
                Icons.add_box_outlined,
                size: 25,
              )),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            backgroundImage: AssetImage('images/profilePicture.png'),
          ),
          SizedBox(
            width: 10,
          )
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Row(
                children: [
                  Text(
                    DateFormat.MMMMd().format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                  ),
                  IconButton(
                    onPressed: () {
                      // FirebaseFirestore.instance.collection("Todo").doc(widget.snap['todoId']).delete()
                      //     .then((value){
                      //   Navigator.pop(context);
                      // });
                      //  var instance=FirebaseFirestore.instance.collection("Todo");
                      // for(int i=0;i<selected.length;i++){
                      //   instance.delete();
                      // }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: mode ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Row(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => FeedPage(),
                      ));
                },
                icon: Icon(
                  Icons.home_outlined,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomeNews(),
                      ));
                },
                icon: Icon(
                  Icons.search,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ToDo(),
                      ));
                },
                icon: Icon(
                  Icons.add,
                  color: mode ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => RequestPage(),
                      ));
                },
                icon: Icon(
                  Icons.favorite_border,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyAccount(
                          id: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ));
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Todo').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                IconData iconData;
                Color iconColor;
                switch (snapshot.data!.docs[index]['Category']) {
                  case 'Work':
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.red;
                    break;
                  case 'WorkOut':
                    iconData = Icons.alarm;
                    iconColor = Colors.red;
                    break;
                  case 'Food':
                    iconData = Icons.local_grocery_store;
                    iconColor = Colors.green;
                    break;
                  case 'Code':
                    iconData = Icons.code;
                    iconColor = Colors.yellow;
                    break;
                  case 'Run':
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.blue;
                    break;
                  case 'Entertainment':
                    iconData = Icons.movie;
                    iconColor = Colors.black38;
                    break;
                  default:
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.red;
                }
                selected.add(
                  Select(
                      id: snapshot.data!.docs[index]['todoId'],
                  ),
                );
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => viewToDo(
                          snap: snapshot.data!.docs[index].data(),
                        )
                      )
                    );
                  },
                  child: ToDoCard(
                    title: snapshot.data!.docs[index]['title'],
                    iconData: iconData,
                    iconColor: iconColor,
                    check: snapshot.data!.docs[index]['check'],
                    iconBgColor: Colors.white,
                    time: snapshot.data!.docs[index]['time'],
                    index: index,
                    todoId: snapshot.data!.docs[index]['todoId'],
                  ),
                );
              });
        },
      ),
    );
  }
}

class Select {
  String id;
  Select({required this.id});
}
