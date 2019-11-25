// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
//import 'home.dart';
//import 'auth.dart';


class LoginPage extends StatefulWidget {

  LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  String _username;
  String _password;

  // TODO: Add text editing controllers (101)
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool validateAndSave(){
    final form = _formKey.currentState;

    if (form.validate()){
      form.save();
      print('Form is valid');
      return true;
    } else {
      print('Form is invalid');
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()){
     try {
       var auth = Provider.of<AuthProvider>(context).auth;
       String userId = await auth.signInWithEmailAndPassword(_username, _password);
       print('Signed In: ${userId}');
       // TODO: Navigate to Homepage
       // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId: userId)));
       widget.onSignedIn();
     } catch(e){
        print(e.message);
     }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/spiral.png'),
                SizedBox(height: 16.0),
                Text('SPIRAL'),
              ],
            ),
            SizedBox(height: 90.0),
            // TODO: Wrap Username with AccentColorOverride (103)
            // TODO: Remove filled: true values (103)
            // TODO: Wrap Password with AccentColorOverride (103)
            // TODO: Add TextField widgets (101)
            // [Name]
            Form(
             key: _formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: buildInputs(),
             ),
            ),
            SizedBox(height: 10.0),
            Text('Don\'t have an account yet? Register Here'),
            // TODO: Add button bar (101)
            ButtonBar(
              // TODO: Add a beveled rectangular border to CANCEL (103)
              children: buildSubmitButtons(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildInputs(){
    return [
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          filled: true,
          labelText: 'Username',
        ),
        validator: (value) => value.isEmpty ? 'username can\'t be empty' : null,
        onSaved: (value) => _username = value,

      ),
      // spacer
      SizedBox(height: 12.0),
      // [Password]
      TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          filled: true,
          labelText: 'Password',
        ),
        validator: (value) => value.isEmpty ? 'password can\'t be empty' : null,
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons(){
     return [
       FlatButton(
         child: Text('CANCEL'),
         onPressed: () {
           // TODO: Clear the text fields (101)
           _usernameController.clear();
           _passwordController.clear();
         },
       ),
       // TODO: Add an elevation to NEXT (103)
       // TODO: Add a beveled rectangular border to NEXT (103)
       RaisedButton(
         child: Text('LOGIN'),
         onPressed: () {
           // TODO: Show the next page (101)
           // validate and submit the credentials
           validateAndSubmit();

         },
       ),
     ];
    }
  }
// TODO: Add AccentColorOverride (103)
