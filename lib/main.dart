import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/news/news_home.dart';
import 'package:socialize/pages/login.dart';
import 'package:socialize/pages/friendPage.dart';
import 'package:socialize/pages/indexPage.dart';
import 'package:socialize/pages/register.dart';
import 'package:socialize/pages/bioData.dart';
import 'package:socialize/pages/interest.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/globals.dart' as globals;
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  globals.mode = false;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => IndexPage(),
        '/indexPage': (context) => IndexPage(),
        '/register': (context) => RegisterPage(),
        '/interest': (context) => ChooseInterest(),
        '/bioData': (context) => BioData(),
        '/login': (context) => LoginPage(),
        '/feedPage': (context) => FeedPage(),
        '/accountPage': (context) => MyAccount(id: FirebaseAuth.instance.currentUser!.uid,),
        '/friendPage': (context) => FriendPage(),
        '/requestPage': (context) => RequestPage(),
        '/news_home': (context) => HomeNews(),
      },
    )
  );
}