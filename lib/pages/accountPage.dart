import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/pages/addPost.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/myPostsPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/todolist.dart';
import 'package:socialize/pages/globals.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/pages/updateProfile.dart';

class MyAccount extends StatefulWidget {
  final snap;
  const MyAccount({Key? key, this.snap}) : super(key: key);
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  bool isLoading1 = true;
  bool isLoading2 = true;
  late String username = '';
  late String pfp = '';
  late String feedImage = '';

  @override
  void initState() {
    FirebaseFirestore.instance.collection("users").
    doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value){
      username = value.data()!["username"];
      pfp = value.data()!["photoUrl"];
      setState(() {
        isLoading1 = false;
      });
    });

    var snapshots = FirebaseFirestore.instance
      .collection('userPost')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('post').get();
    snapshots.then((value1){
      final listOfPhotos = value1.docs;
      listOfPhotos.forEach((value) {
        feedImage = value.data()["image"];
      });
      setState(() {
        isLoading2 = false;
      });
    });

    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                     Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) => AddPost(),
                        )
                     );
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: mode ? Colors.white : Colors.black,
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mode = !mode;
                    });
                  },
                  icon: Icon(
                    mode ? Icons.light_mode : Icons.dark_mode,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      isLoading1 ? Center(child: CircularProgressIndicator()):
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          pfp,
                        ),
                      ),
                      Text(
                        username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: mode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("userPost/${APIs.user.uid}/post").snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          return Text(
                            snapshot.data!.docs.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: mode ? Colors.white : Colors.black,
                            ),
                          );
                        }
                      ),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: mode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Column(
                      children: [
                        Text(
                          '500',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: mode ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          'Friends',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: mode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) => UpdateProfile(),
                                )
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: mode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: mode ? Colors.white : Colors.grey,),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Share Profile',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: mode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: mode ? Colors.white : Colors.grey,),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  TabBar(
                    controller: tabController,
                    indicatorColor: mode ? Colors.grey : Colors.black,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.grid_on_sharp,
                          color: mode ? Colors.white : Colors.black,
                          size: 25,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.person_pin_outlined,
                          color: mode ? Colors.white : Colors.black,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("userPost/${APIs.user.uid}/post").snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  return Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        snapshot.data!.docs.length == 0
                        ?
                        Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 105,vertical: 100),
                        child: Text(
                          'No posts available!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        :
                        GridView.count(
                          controller: scrollController,
                          crossAxisCount: 2,
                          children: [
                            for (int i = 0; i < snapshot.data!.docs.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) => MyPostsPage(),
                                      )
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 3, top: 3),
                                  child: isLoading2 ?
                                  Center(child: CircularProgressIndicator()) :
                                  Image.network(
                                    feedImage,
                                    fit:BoxFit.cover,
                                  ),
                                ),
                              )
                          ],
                        ),
                        GridView.count(
                          controller: scrollController,
                          crossAxisCount: 2,
                          // children: [
                          //   for (int i = 0; i < 9; i++)
                          //     Container(
                          //       margin: const EdgeInsets.only(right: 3, top: 3),
                          //       child: Image.asset(
                          //         "images/profilePicture.png",
                          //         fit: BoxFit.cover,
                          //       ),
                          //     )
                          // ],
                        )
                      ],
                    ),
                  );
                }
              ),
            ],
          ),
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
                        MaterialPageRoute(builder: (BuildContext context) => MyAccount(),));
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
      ),
    );
  }
}