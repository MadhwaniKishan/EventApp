import 'package:flutter/material.dart';
import 'package:flutter_event_app/provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'model/event.dart';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final Set<Marker> _markers = {};
  double lat = 0.0, lng = 0.0;
  static LatLng currentLocation;
  Event event = new Event();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Photos'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              markers: _markers,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: new LatLng(lat, lng),
                zoom: 15.0,
              ),
              onMapCreated: _onMapCreated,
              onTap: _handleTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 50,
              width: double.infinity,
              child: FlatButton(
                textColor: Colors.white,
                onPressed: () => _saveEventLocation(),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 24),
                ),
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _markers.clear();
    await getLocation();
    _markers.add(Marker(
      markerId: MarkerId(currentLocation.toString()),
      position: currentLocation,
      infoWindow: InfoWindow(
        title: 'Event Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    ));
    setState(() {
      controller = controller;
    });
  }

  _saveEventLocation() {
    final appState = Provider.of<ProviderClass>(context);
    event.name = appState.name;
    event.address = appState.address;
    event.dateTime = appState.dateTime;
    event.description = appState.description;
    event.lat = lat.toString();
    event.long = lng.toString();
    event.photosUrl = appState.photosUrl;
    event.insertIntoDb();
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => MyHomePage(
              title: "Event app",
            )));
  }

  _handleTap(LatLng point) {
    setState(() {
      lat = point.latitude;
      lng = point.longitude;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Event Location',
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
  }

  Future<void> getLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geoLocator = Geolocator();
    GeolocationStatus geolocationStatus =
        await geoLocator.checkGeolocationPermissionStatus();
    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        print('denied');
        break;
      case GeolocationStatus.disabled:
      case GeolocationStatus.restricted:
        print('restricted');
        break;
      case GeolocationStatus.unknown:
        print('unknown');
        break;
      case GeolocationStatus.granted:
        await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position _position) {
          if (_position != null) {
            setState(() {
              lat = _position.latitude;
              lng = _position.longitude;
              currentLocation = LatLng(
                _position.latitude,
                _position.longitude,
              );
            });
          }
        });
        break;
    }
  }
}
