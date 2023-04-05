import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/pages/addPost.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/todolist.dart';
import 'package:socialize/pages/globals.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/pages/updateProfile.dart';
import 'package:socialize/pages/myPostsPage.dart';

class MyAccount extends StatefulWidget {
  final String id;
  const MyAccount({Key? key, required this.id}) : super(key: key);
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  var userData = {};
  int postLen = 0;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.id)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('id', isEqualTo: widget.id)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    const Center(
      child: CircularProgressIndicator(),
    )
        :
    DefaultTabController(
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
                  userData['username'],
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
                        MaterialPageRoute(
                          builder: (BuildContext context) => AddPost(),
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
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                          ),
                          Text(
                            userData['username'],
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
                              stream: FirebaseFirestore.instance.collection(
                                  "userPost/${APIs.user.uid}/post").snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot<
                                  Map<String, dynamic>>> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Text(
                                  postLen.toString(),
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
                        onPressed: () {},
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
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          UpdateProfile(),
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
                                        color: mode ? Colors.white : Colors
                                            .black,
                                      ),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: mode ? Colors.white : Colors.grey,),
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
                                border: Border.all(
                                  color: mode ? Colors.white : Colors.grey,),
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
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('id', isEqualTo: widget.id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 105, vertical: 100),
                                  child: Text(
                                    'No posts available!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    :
                                GridView.builder(
                                    controller: scrollController,
                                    itemCount: (snapshot.data! as dynamic).docs
                                        .length,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.5,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot snap =
                                      (snapshot.data! as dynamic).docs[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) =>
                                                  MyPostsPage(id: FirebaseAuth.instance.currentUser!.uid),
                                              )
                                          );
                                        },
                                        child: Container(
                                          child: Image(
                                            image: NetworkImage(snap['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }
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
                                ),
                              ]
                          )
                      );
                    },
                  ),
                ]
            )
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
                        MaterialPageRoute(
                          builder: (BuildContext context) => FeedPage(),));
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
                        MaterialPageRoute(
                          builder: (BuildContext context) => NewsScreen(),));
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
                        MaterialPageRoute(
                          builder: (BuildContext context) => ToDoScreen(),));
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
                        MaterialPageRoute(
                          builder: (BuildContext context) => RequestPage(),)
                    );
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
                          builder: (BuildContext context) => MyAccount(
                            id: FirebaseAuth.instance.currentUser!.uid,),
                        )
                    );
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

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}