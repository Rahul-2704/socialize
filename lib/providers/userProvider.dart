import 'package:flutter/widgets.dart';
import 'package:socialize/models/user.dart';
import 'package:socialize/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserAccount? _user;
  final Authmethods _authMethods = Authmethods();

  UserAccount get getUser => _user!;

  Future<void> refreshUser() async {
    UserAccount user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
