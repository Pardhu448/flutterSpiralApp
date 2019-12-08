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

//import 'package:Spiral/auth.dart';
import 'package:Spiral/auth_provider.dart';
import 'package:Spiral/spiral_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'auth.dart';
import 'root_page.dart';

// TODO: Convert SpiralApp to stateful widget (104)
class SpiralApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPIRAL',
      // TODO: Change home: to a Backdrop with a HomePage frontLayer (104)
      // Provide authorization as a service from top
      home: ChangeNotifierProvider<AuthProvider>(
        builder: (context) => AuthProvider(),
        child: RootPage(),
      ),
      // TODO: Make currentCategory field take _currentCategory (104)
      // TODO: Pass _currentCategory for frontLayer (104)
      // TODO: Change backLayer field value to CategoryMenuPage (104)
      // TODO: Add a theme (103)
      theme: ThemeData(
        primaryColor: Color(0xFFFFB300),
        primaryColorLight: Color(0xFFFFE54C),
        primaryColorDark: Color(0xFFC68400),
        accentColor: Colors.amberAccent,
        primaryTextTheme: TextTheme(
          body1: TextStyle(color: Color(0xFF000000), fontFamily: 'Rubik')
        ),
      ),

    );
  }
}

//  Route<dynamic> _getRoute(RouteSettings settings) {
//    if (settings.name != '/login') {
//      return null;
//    }

//    return MaterialPageRoute<void>(
//      settings: settings,
//      builder: (BuildContext context) => LoginPage(auth: Auth()),
//      fullscreenDialog: true,
//    );
//  }
//}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)
