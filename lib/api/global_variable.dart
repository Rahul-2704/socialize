import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/addPost.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/requestPage.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedPage(),
  const RequestPage(),
  const AddPost(),
  const Text('notifications'),
  MyAccount(
    id: FirebaseAuth.instance.currentUser!.uid,
  ),
];
