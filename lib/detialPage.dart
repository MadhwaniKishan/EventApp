import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_event_app/provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'database/database_provider.dart';
import 'model/event.dart';

class DetailPage extends StatefulWidget {
  final String event;

  DetailPage(this.event);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Set<Marker> _markers = {};
  Event event;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseProvider.db.getEvent(widget.event).then((event) => {
          Provider.of<ProviderClass>(context).event = event,
        });
  }

  @override
  Widget build(BuildContext context) {
    event = Provider.of<ProviderClass>(context).event;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event),
        backgroundColor: Colors.green[700],
      ),
      body: event != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Name: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(event.name),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(event.description),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Address: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(event.address),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Date and Time: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(event.dateTime),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 20),
                  child: Text(
                    'Images: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 150,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: event.photosUrl.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.file(
                            new File(event.photosUrl[index]),
                            height: 125,
                            width: 125,
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GoogleMap(
                      markers: _markers,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: new LatLng(
                            double.parse(event.lat), double.parse(event.long)),
                        zoom: 15.0,
                      ),
                      onMapCreated: _onMapCreated,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: FlatButton(
                      textColor: Colors.white,
                      onPressed: () => deleteEvent(),
                      child: Text(
                        "Delete Event",
                        style: TextStyle(fontSize: 24),
                      ),
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            )
          : Text(''),
    );
  }

  deleteEvent() {
    DatabaseProvider.db.deleteEvent(widget.event);
    Navigator.pop(context);

  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId('Event Location'),
      position: LatLng(double.parse(event.lat), double.parse(event.long)),
      infoWindow: InfoWindow(
        title: 'Event Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    ));
    setState(() {
      controller = controller;
    });
  }
}
