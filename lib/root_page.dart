import 'package:Spiral/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Spiral/login.dart';
import 'package:Spiral/home_page.dart';
//Root page of the app, where switching between home and login page is done based on
// authentication status of the user

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
  // ignore: missing_return
  Widget build(BuildContext context){
    switch(_authStatus){
      case AuthStatus.notSignedInd:
        return LoginPage(onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return HomePage(onSignedOut: _signedOut);
    }

  }
}