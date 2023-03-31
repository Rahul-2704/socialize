import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialize/pages/addPost.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/post.dart';
import 'package:socialize/pages/globals.dart';

import '../api/apis.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);
  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String ?  _image;
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
                  'User1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                     // _showBottomSheet();
                    // await if(_image!=null){
                       Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) => AddPost(),));
                    // }
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
        body: Container(
          color: mode ? Colors.grey[850] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          'User1',
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
                        Text(
                          '20',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: mode ? Colors.white : Colors.black,
                          ),
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                TabBar(
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
                        MaterialPageRoute(builder: (BuildContext context) => TempScreen(),));
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
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * .03, bottom: MediaQuery.of(context).size.height * .05),
            children: [
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updatePost(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updatePost(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}