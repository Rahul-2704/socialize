import 'package:flutter/widgets.dart';
import 'package:socialize/models/user.dart';
import 'package:socialize/api/apis.dart';

class UserProvider with ChangeNotifier {
  UserAccount? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserAccount get getUser => _user!;

  Future<void> refreshUser() async {
    UserAccount user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}