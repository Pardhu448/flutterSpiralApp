import 'package:Spiral/selectMeetingPlace.dart';
import 'package:Spiral/suggestMeetingPlace.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
//import 'package:permission/permission.dart';
//import 'package:permission_handler/permission_handler.dart';

class SpiralMap extends StatefulWidget {

  //SpiralMap({this.onSignedOut});
  //final VoidCallback onSignedOut;

  @override
  _SpiralMapState createState() => _SpiralMapState();
}

class _SpiralMapState extends State<SpiralMap> {
  GoogleMapController mapController;

  static final LatLng _center = const LatLng(19.118427, 72.912080);
  static const String _API_KEY = '{{AIzaSyBHvK437lRhXvxqWROVeT85T1UBt5KFkOQ}}';

  var _currentLocation;

  //List<Marker> markers = <Marker>[];
  final Set<Marker> _markers = {};
  //double _width = 100;
  var _height;
  //Color _color = Colors.white;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(4);

  @override
  void initState() {
    _getLocation().then((currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
        _height = 0.0;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _openMeetingPlaceEntry(double height) {
    setState(() {
      _height = height;
    });
  }

//  void _onAddMarkerButtonPressed() {
//    setState(() {
//      _markers.add(Marker(
//        // This marker id can be anything that uniquely identifies each marker.
//        markerId: MarkerId(_lastMapPosition.toString()),
//        position: _lastMapPosition,
//        infoWindow: InfoWindow(
//          title: 'Really cool place',
//          snippet: '5 Star Rating',
//        ),
//        icon: BitmapDescriptor.defaultMarker,
//      ));
//    });
//  }

  Future<LocationData> _getLocation() async {
    LocationData currentLocation;
    var location = Location();

    // returns a map with unreadable numbers which make no sense
    //var t = await PermissionHandler()
    //    .requestPermissions([PermissionGroup.location]);

    // returns false
    var test = await location.requestPermission();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
          children: <Widget>[
            GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17.0,
                  bearing: 15,
                  tilt: 45,
                ),
              myLocationEnabled: true,
              markers: _markers,
              onCameraMove: _onCameraMove,
              ),
            Container(
              alignment: Alignment(0.0, 1.0),
              child: RaisedButton(
                child: Text('Chat with Someone Nearby!'),
                onPressed: () {
                _openMeetingPlaceEntry(200.0);
                },
                color: Theme.of(context).primaryColorLight,
                ),
                ),
            Container(
              alignment: Alignment(0.0, 1.0),
              child: AnimatedContainer(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: <Widget>[
                     SizedBox(height: 4,),
                     Text('Hello Partha,', textAlign: TextAlign.center,
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22 ), ),
                     Divider(height: 2.0, thickness: 3.0,),
                    // SizedBox(height: 2.0,),
                  AutoComplete(),
                   ],
                 ),
                // Use the properties stored in the State class.
                decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: _borderRadius,
                ),
               // Define how long the animation should take.
               duration: Duration(seconds: 2),
               // Provide an optional curve to make the animation feel smoother.
               curve: Curves.fastOutSlowIn,
               height: _height,
               ),
              ),
              ],
             );
  }
}