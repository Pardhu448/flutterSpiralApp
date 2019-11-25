import 'package:Spiral/auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final BaseAuth auth = Auth();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
  }