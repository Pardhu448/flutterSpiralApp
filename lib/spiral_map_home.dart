import 'package:Spiral/model/user_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// Home map once user logs into app
//Has a button to fetch a list of locations nearby with potential matches

class SpiralMapHome extends StatefulWidget {

  SpiralMapHome({this.switchHome});
  final VoidCallback switchHome;

  @override
  _SpiralMapHomeState createState() => _SpiralMapHomeState();
}

class _SpiralMapHomeState extends State<SpiralMapHome> {
  GoogleMapController mapController;

  static final LatLng _center = const LatLng(19.118427, 72.912080);

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    var currentUserLocation = Provider.of<UserLocation>(context);
    return
      Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentUserLocation.latitude, currentUserLocation.longitude),
              zoom: 17.0,
              bearing: 15,
              tilt: 0,
            ),
            myLocationEnabled: true,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Align(
            alignment: Alignment(0.3, 0.7),
            child : FloatingActionButton.extended(
              onPressed: () {
                widget.switchHome();
                 },
              label: Text('Chat with People Nearby!'),
              icon: Icon(Icons.people),
              backgroundColor: Colors.amberAccent,
            ),
          )
        ],
      );
  }
}