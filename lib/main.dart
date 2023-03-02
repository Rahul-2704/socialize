import 'package:flutter/material.dart';
import 'package:socialize/pages/friendPage.dart';
import 'package:socialize/pages/indexPage.dart';
import 'package:socialize/pages/login.dart';
import 'package:socialize/pages/register.dart';
import 'package:socialize/pages/bioData.dart';
import 'package:socialize/pages/interest.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/searchNews.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/feedPage.dart';

void main() {
  bool mode=false;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => IndexPage(),
      // '/':(context) => IndexPage(),
      '/indexPage': (context) => IndexPage(),
      '/register': (context) => RegisterPage(),
      '/interest': (context) => ChooseInterest(),
      '/bioData': (context) => BioData(),
      '/login': (context) => LoginPage(),
      '/feedPage': (context) => FeedPage(),
      '/searchNews': (context) => SearchNews(),
      '/accountPage': (context) => MyAccount(),
      '/friendPage': (context) => FriendPage(),
      '/requestPage': (context) => RequestPage(),
      '/home': (context) => NewsScreen(),
    },
  ));
}