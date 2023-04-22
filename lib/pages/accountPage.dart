import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/news/news_home.dart';
import 'package:socialize/pages/addPost.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/followersPage.dart';
import 'package:socialize/pages/indexPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/todos/ToDo.dart';
import 'package:socialize/pages/globals.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/pages/myPostsPage.dart';
import 'package:socialize/pages/updateProfile.dart';
import 'package:socialize/widgets/follow_button.dart';
import 'package:socialize/api/colors.dart';
import 'package:socialize/api/dialogs.dart';
import 'package:socialize/pages/followingPage.dart';

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
  int followers = 0;
  int following = 0;
  bool isFollowing = false;

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
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
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
                bottom: !mode ? BorderSide(
                  color: Colors.grey,
                )
                :
                BorderSide(
                  color: Colors.white60,
                ),
              ),
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: mode ? Colors.grey[900] : Colors.white,
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
                userData['id'] == FirebaseAuth.instance.currentUser?.uid ? IconButton(
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
                ) : Container(),
                userData['id'] == FirebaseAuth.instance.currentUser?.uid ? IconButton(
                  onPressed: () {
                    setState(() {
                      mode = !mode;
                    });
                  },
                  icon: Icon(
                    mode ? Icons.light_mode : Icons.dark_mode,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
        body: Container(
          color: !mode ? Colors.white : Colors.grey[800],
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: MediaQuery.of(context).size.width * 0.25,
                                fit: BoxFit.cover,
                                imageUrl: userData['photoUrl'],
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                    child: Icon(Icons.person)
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        postLen.toString(),
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height*0.025,
                                          fontWeight: FontWeight.bold,
                                          color: !mode ? Colors.black : Colors.white,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'posts',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height*0.02,
                                            fontWeight: FontWeight.w400,
                                            color: mode ? Colors.white60 : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                            FollowersPage(),
                                        )
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          followers.toString(),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height*0.025,
                                            fontWeight: FontWeight.bold,
                                            color: !mode ? Colors.black : Colors.white,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'followers',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height*0.02,
                                              fontWeight: FontWeight.w400,
                                              color: mode ? Colors.white60 : Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FollowingPage(),
                                          )
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          following.toString(),
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height*0.025,
                                            fontWeight: FontWeight.bold,
                                            color: !mode ? Colors.black : Colors.white,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'following',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.height*0.02,
                                              fontWeight: FontWeight.w400,
                                              color: mode ? Colors.white60 : Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid == widget.id
                                  ?
                                  Row(
                                    children: [
                                      FollowButton(
                                        text: 'Update Profile',
                                        backgroundColor:
                                        mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: () {
                                          Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                UpdateProfile(),
                                            )
                                          );
                                        },
                                      ),
                                      FollowButton(
                                        text: 'Log Out',
                                        backgroundColor:
                                        mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await AuthMethods().signOut().then((value) {
                                            Dialogs.showSnackBar(context, "You have been logged out!");
                                          });
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    IndexPage(),
                                              )
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                  : isFollowing
                                  ? FollowButton(
                                    text: 'Unfollow',
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    borderColor: Colors.grey,
                                    function: () async {
                                      await APIs()
                                          .followUser(
                                        FirebaseAuth.instance
                                            .currentUser!.uid,
                                        userData['id'],
                                      );
                                      setState(() {
                                        isFollowing = false;
                                        followers--;
                                      });
                                    },
                                  )
                                  :
                                  FollowButton(
                                    text: 'Follow',
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    borderColor: Colors.blue,
                                    function: () async {
                                      await APIs()
                                          .followUser(
                                        FirebaseAuth.instance
                                            .currentUser!.uid,
                                        userData['id'],
                                      );
                                      setState(() {
                                        isFollowing = true;
                                        followers++;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.007,
                          ),
                          Text(
                            '${userData['firstname']} ${userData['lastname']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: MediaQuery.of(context).size.height*0.022,
                              color: mode ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            userData['bio'],
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height*0.018,
                              fontWeight: FontWeight.w400,
                              color: mode ? Colors.white : Colors.black,
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
                                size: MediaQuery.of(context).size.width*0.07,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.person_pin_outlined,
                                color: mode ? Colors.white : Colors.black,
                                size: MediaQuery.of(context).size.width * 0.07,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: !mode ? BorderSide(
                                color: Colors.grey,
                              )
                              :
                              BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.004,),
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
                                        fontSize: MediaQuery.of(context).size.height*0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                      :
                                  GridView.builder(
                                      controller: scrollController,
                                      itemCount: (snapshot.data! as dynamic).docs.length,
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
                                              MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                MyPostsPage(id: widget.id),
                                              )
                                            );
                                          },
                                          child: ClipRRect(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: snap['image'],
                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                              const CircleAvatar(
                                                  child: Icon(Icons.error)
                                              ),
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
                    size: MediaQuery.of(context).size.width*0.095,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomeNews(),));
                  },
                  icon: Icon(
                    Icons.search,
                    color: mode ? Colors.white54 : Colors.grey[700],
                    size: MediaQuery.of(context).size.width*0.095,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ToDo(),));
                  },
                  icon: Icon(
                    Icons.add,
                    color: mode ? Colors.white54 : Colors.grey[700],
                    size: MediaQuery.of(context).size.width*0.095,
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
                    size: MediaQuery.of(context).size.width*0.095,
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
                    size: MediaQuery.of(context).size.width*0.095,
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