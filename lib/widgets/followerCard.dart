import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/globals.dart';
class FollowerUsers extends StatefulWidget {
  final snap;
  const FollowerUsers({Key? key, this.snap}) : super(key: key);

  @override
  State<FollowerUsers> createState() => _FollowerUsersState();
}

class _FollowerUsersState extends State<FollowerUsers> {
  bool isLoading = false;
  List<String> userFollowerList = [];
  int follower = 0;
  late String userName = '';
  late String firstName = '';
  late String lastName = '';
  late String img = '';
  late String id = '';

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      follower = userSnap.data()!['followers'].length;
      for(int i=0;i<follower;i++){
        userFollowerList.add(userSnap.data()!['followers'][i].toString());
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadData() async {
    await getData();
    setState(() {});
  }

  Future<void> updateData(String userId) async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get().then((value) {
      id = value.data()!["id"];
      userName = value.data()!["username"];
      firstName = value.data()!["firstname"];
      lastName = value.data()!["lastname"];
      img = value.data()!["photoUrl"];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    updateData(widget.snap['id']);
  }

  @override
  Widget build(BuildContext context) {
    return userFollowerList.contains(id) ?
    SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height*0.098,
        width: double.maxFinite,
        padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.03,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: CachedNetworkImage(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    imageUrl: img,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(
                        child: Icon(Icons.person)
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: mode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.015,
                    ),
                    Container(
                      child: Text(
                        firstName + ' ' + lastName,
                        style: TextStyle(
                          color: mode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: mode ? Colors.white60 : Colors.black,
            ),
          ],
        ),
      ),
    ) : Container();
  }
}