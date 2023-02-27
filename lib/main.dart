import 'package:flutter/material.dart';
import 'package:socialize/pages/friendPage.dart';
import 'package:socialize/pages/indexPage.dart';
import 'package:socialize/pages/login.dart';
import 'package:socialize/pages/register.dart';
import 'package:socialize/pages/bioData.dart';
import 'package:socialize/pages/interest.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/pages/searchNews.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/views/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      // '/': (context) => HomeScreen(),
      '/':(context) => IndexPage(),
      '/indexPage': (context) => IndexPage(),
      '/register': (context) => RegisterPage(),
      '/interest': (context) => ChooseInterest(),
      '/bioData': (context) => BioData(),
      '/login': (context) => LoginPage(),
      '/searchNews': (context) => SearchNews(),
      '/accountPage': (context) => MyAccount(),
      '/friendPage': (context) => FriendPage(),
      '/requestPage': (context) => RequestPage(),
      '/home': (context) => HomeScreen(),
    },
  ));
}