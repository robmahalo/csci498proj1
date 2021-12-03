import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:io';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  static const String id = 'home';

  @override
  _home_pageState createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double pageHeight = (Platform.isIOS) ? 290 : 260;

  Completer<GoogleMapController> _controller = Completer();
  double mapBottom = 0;
  late GoogleMapController mapController;

  late Position currentPosition;
  var geoLocator = Geolocator();

  // Get user's current location
  void locateUser() async {
    Position position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;
    LatLng loc = LatLng(position.latitude, position.longitude);
    CameraPosition camPos = new CameraPosition(target: loc, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(camPos));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.05749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottom),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapBottom = (Platform.isAndroid) ? 270 : 290;
              });

              locateUser();

            },

          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: pageHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Text('Where would you like to park?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            spreadRadius: 0.4,
                            offset: Offset(
                              0.7,
                              0.7,
                            )
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: <Widget> [
                            SizedBox(width: 10,),
                            Text('GO', style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
