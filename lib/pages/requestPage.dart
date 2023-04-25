import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/news/news_home.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/todos/ToDo.dart';
import '../api/global_variable.dart';
import 'globals.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController _searchController=TextEditingController();
  bool isShowUser = false;
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mode ? Colors.black87 : Colors.white60,
        elevation: 1,
        title:TextFormField(
          style: TextStyle(
            color: !mode ? Colors.black : Colors.white,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: mode ? Colors.white : Colors.black,
            ),
            labelText: 'Search a user',
            labelStyle: TextStyle(
              color: mode ? Colors.white : Colors.black,
            )
          ),
          controller: _searchController,
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              isShowUser = true;
            });
          },
        ) ,
      ),
      body: isShowUser
          ?
      GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection("users")
              .where('username', isGreaterThanOrEqualTo: _searchController.text)
              .get(),
            builder:(context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return (snapshot.data! as dynamic).docs.length == 0
                  ?
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 78,
                ),
                child: Text(
                  'No such user exists!!',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black
                  ),
                ),
              )
                  :
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  color: mode ? Colors.grey[900] : Colors.white,
                  child: ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => MyAccount(id:(snapshot.data! as dynamic).docs[index]['id']),
                              )
                          );
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              imageUrl: (snapshot.data! as dynamic).docs[index]['photoUrl'],
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(Icons.person)
                              ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(right: 100),
                            child: Text(
                              (snapshot.data! as dynamic).docs[index]['username'],
                              style: TextStyle(
                                color: !mode ? Colors.black54 : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ),
              );
            }
        ),
      )
          :
      GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: mode ? Colors.grey[900] : Colors.white,
          padding: EdgeInsets.only(top: 8),
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('date')
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => CachedNetworkImage(
                  imageUrl: (snapshot.data! as dynamic).docs[index]['image'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const CircleAvatar(
                    child: Icon(Icons.error)
                  ),
                ),
                staggeredTileBuilder: (index) => MediaQuery.of(context)
                    .size
                    .width >
                    webScreenSize
                    ? StaggeredTile.count(
                    (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                    : StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              );
            },
          ),
        ),
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
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) => HomeNews(),));
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
                  color: mode ? Colors.white : Colors.black,
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