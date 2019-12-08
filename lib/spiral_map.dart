
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'api_key.dart';

// spiral map is user specific map with the list of nearby locations populated as a list

// Hue used by the Google Map Markers to match the theme
const _pinkHue = 350.0;
// Places API client used for Place Photos
final _placesApiClient = GoogleMapsPlaces(apiKey: googleMapsApiKey);

class SpiralMap extends StatefulWidget {

  SpiralMap({this.switchHome});
  final VoidCallback switchHome;

  @override
  _SpiralMapState createState() => _SpiralMapState();
}

class _SpiralMapState extends State<SpiralMap> {

  static const LatLng initialPosition = LatLng(19.118427, 72.912080);
  //static final String _API_KEY = ;

  Stream<QuerySnapshot> _userLocations;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _userLocations = Firestore.instance
        .collection('UserLocations')
        .orderBy('distance')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    //  receiving userlocations which are calculated for this user as a stream
    return StreamBuilder<QuerySnapshot>(
      stream: _userLocations,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: const Text('Loading...'));
        }
        return WillPopScope(
        onWillPop: (){
          widget.switchHome();
        },
        child: Column(
            children: [
              Flexible(
                flex: 3,
                child: StoreMap(
                  documents: snapshot.data.documents,
                  initialPosition: initialPosition,
                  mapController: _mapController,
                ),
              ),
              Flexible(
                flex: 2,
                child: StoreList(
                    documents: snapshot.data.documents,
                    mapController: _mapController),
              )
            ]
        ),
        );
      }
      );
      }
  }

class StoreList extends StatelessWidget {
  const StoreList({
    Key key,
    @required this.documents,
    @required this.mapController,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 340,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Card(
              child: Center(
                child: StoreListTile(
                  document: documents[index],
                  mapController: mapController,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    Key key,
    @required this.document,
    @required this.mapController,
  }) : super(key: key);

  final DocumentSnapshot document;
  final Completer<GoogleMapController> mapController;


  @override
  State<StatefulWidget> createState() {
    return _StoreListTileState();
  }
}

class _StoreListTileState extends State<StoreListTile> {
  String _placePhotoUrl = '';
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _retrievePlacesDetails();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _retrievePlacesDetails() async {
    final details = await _placesApiClient
        .getDetailsByPlaceId(widget.document['PlaceId'] as String);
    if (!_disposed) {
      setState(() {
        _placePhotoUrl = _placesApiClient.buildPhotoUrl(
          photoReference: details.result.photos[0].photoReference,
          maxHeight: 300,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.document['Name'] as String),
      subtitle: Text(widget.document['Address'] as String),
      leading: Container(
        width: 100,
        height: 120,
        child: _placePhotoUrl.isNotEmpty
            ? ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          child: Image.network(_placePhotoUrl, fit: BoxFit.cover),
        )
            : Container(),
      ),
      onTap: () async {
        final controller = await widget.mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.document['location']['latitude'] as double,
                widget.document['location']['longitude'] as double,
              ),
              zoom: 18,
            ),
          ),
        );
      },
    );
  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 15,
      ),
      markers: documents
          .map((document) => Marker(
        markerId: MarkerId(document['PlaceId'] as String),
        icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
        position: LatLng(
          document['location']['latitude'] as double,
          document['location']['longitude'] as double,
        ),
        infoWindow: InfoWindow(
          title: document['Name'] as String,
          //snippet: document['Address'] as String,
        ),
      )
      ).toSet(),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }
}