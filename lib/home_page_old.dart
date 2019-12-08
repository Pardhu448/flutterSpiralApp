import 'package:Spiral/auth_provider.dart';
import 'package:Spiral/model/user_location.dart';
import 'package:Spiral/spiral_map_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Spiral/services/location_service.dart';



class HomePage extends StatelessWidget {

  HomePage({this.onSignedOut});

  final VoidCallback onSignedOut;

  void _signOut(BuildContext context) async {
    var auth = Provider.of<AuthProvider>(context).auth;
    try {
     await auth.signOut();
     onSignedOut();
    } catch(e){
     print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    //Stack widget not working for some reason, so using scaffold only
    return StreamProvider<UserLocation>(
     builder: (context) => LocationService().locationStream,
     initialData: UserLocation(latitude: 19.118427, longitude: 72.912080),
     child: Scaffold(
          appBar: AppBar(
           centerTitle: true,
           //backgroundColor: Colors.transparent,
           title: Text('Sprial'),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text('Logout', style: TextStyle(fontSize: 17.0)),
          //     onPressed: () => _signOut(context)
          //   )
          // ],
          ),
          body: SpiralMapHome(),
          drawer: Drawer(
           // Add a ListView to the drawer. This ensures the user can scroll
           // through the options in the drawer if there isn't enough vertical
           // space to fit everything.
              child: ListView(
               // Important: Remove any padding from the ListView.
               padding: EdgeInsets.zero,
               children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text("Partha E"),
                    accountEmail: Text("pardhuuvce@gmail.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                      child: Text(
                        "PE",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Meetings'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer

                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    onTap: () => _signOut(context),
                     //{

                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      //Navigator.pop(context);
                    //},
                  ),
               ],
        ),
       ),
      )
    );
    }
}
