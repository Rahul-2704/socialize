import 'package:flutter/material.dart';
import 'package:socialize/pages/indexPage.dart';
import 'package:socialize/pages/login.dart';
import 'package:socialize/pages/register.dart';
import 'package:socialize/pages/bioData.dart';
import 'package:socialize/pages/interest.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => BioData(),
      // '/':(context) => ChooseInterest(),
      '/register': (context) => RegisterPage(),
      '/login': (context) => LoginPage(),
      // '/bioData': (context) => BioData(),
      '/interest': (context) => ChooseInterest(),
    },
  ));
}