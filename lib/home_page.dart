import 'package:Spiral/auth_provider.dart';
import 'package:Spiral/model/user_location.dart';
import 'package:Spiral/spiral_map.dart';
import 'package:Spiral/spiral_map_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Spiral/services/location_service.dart';

//Home page which switches between home_map page and spiral_map page
// home_map : default page with a button to chat with someone
// spiral_map: map with list of nearby location with potential matches

enum WidgetSelector { home_map_page, spiral_map_page }

class HomePage extends StatefulWidget {

  HomePage({this.onSignedOut});

  final VoidCallback onSignedOut;


  void _signOut(BuildContext context) async {
    var auth = Provider
        .of<AuthProvider>(context)
        .auth;
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

  class _HomePageState extends State<HomePage>{

  WidgetSelector selectedWidget = WidgetSelector.home_map_page;

  void _switchhome(){

    if (selectedWidget == WidgetSelector.home_map_page) {
      setState(() {
        selectedWidget = WidgetSelector.spiral_map_page;
      });
    }
    else if (selectedWidget == WidgetSelector.spiral_map_page){
      setState(() {
        selectedWidget = WidgetSelector.home_map_page;
      });
    }
  }

  Widget _getHomeWidget(){
      return SpiralMapHome(switchHome: _switchhome);
    }
    Widget _getSpiralWidget(){
      return SpiralMap(switchHome: _switchhome);
    }
    Widget _getSelectedContainer() {
      switch (selectedWidget) {
        case WidgetSelector.home_map_page:
          return _getHomeWidget();
        case WidgetSelector.spiral_map_page:
          return _getSpiralWidget();
      }
      return _getHomeWidget();
    }

  @override
  Widget build(BuildContext context){
    // Stream of userlocation is created once logged in
    // This can be used by backend to calculate nearby locations and
    // create a stream of locations with potential matches
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
          // TODO: need to make this animation more interesting
          body: Center(
                    child: AnimatedContainer(
                    // Use the properties stored in the State class.
                    // Define how long the animation should take.
                    duration: Duration(seconds: 1),
                   // Provide an optional curve to make the animation feel smoother.
                   curve: Curves.fastOutSlowIn,
                   child:_getSelectedContainer(),
                  ),
            ),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                // TODO:  Need to get user info from the firebase database. Currently it is static
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
                  onTap: () => widget._signOut(context),
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