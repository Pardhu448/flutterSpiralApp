//import 'dart:ffi';

import 'package:Spiral/auth_provider.dart';
import 'package:Spiral/selectMeetingPlace.dart';
import 'package:Spiral/suggestMeetingPlace.dart';
import 'package:Spiral/spiral_map.dart';
//import 'package:Spiral/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
//import 'auth.dart';
import 'home_page.dart';

class RootPage extends StatefulWidget {

  @override
  _RootPageState createState() => _RootPageState();
  }

enum AuthStatus {
  notSignedInd,
  signedIn
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedInd;

 @override
 void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var auth = Provider.of<AuthProvider>(context);
    auth.auth.currentUser().then((userId) {
     setState(() {
       _authStatus = userId == null ? AuthStatus.notSignedInd : AuthStatus.signedIn;
     });
    });
  }

  void _signedIn(){
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      _authStatus = AuthStatus.notSignedInd;
    });
  }

  @override
  Widget build(BuildContext context){
    switch(_authStatus){
      case AuthStatus.notSignedInd:
        return LoginPage(onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return HomePage(onSignedOut: _signedOut);
        //return SuggestionsPage();
    }
  }
}