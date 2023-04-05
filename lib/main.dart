import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialize/pages/login.dart';
import 'package:socialize/pages/friendPage.dart';
import 'package:socialize/pages/indexPage.dart';
import 'package:socialize/pages/register.dart';
import 'package:socialize/pages/bioData.dart';
import 'package:socialize/pages/interest.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/searchNews.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/globals.dart' as globals;
import 'package:firebase_core/firebase_core.dart';
import 'package:socialize/api/user_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  globals.mode = false;
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create:(_) => UserProvider()),
        ],
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => LoginPage(),
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
        )
      )
  );
}