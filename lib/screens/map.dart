import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:subidha/custom/divider.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;
  double searchSheetWidget = (Platform.isIOS) ? 300 : 305;

  LatLng sourceLatLng;
  LatLng destinationLatLng;
  String sourceName = "";
  String destinationName = "";
  TimeOfDay selectedTime;

  bool switchValue = false;

  var geoLocator = Geolocator();
  Position currentPosition;

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 17);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  static final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(27.69329, 85.32227),
    zoom: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            initialCameraPosition: initialCameraPosition,
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onTap: (latLng) async {
              if (destinationLatLng == null || sourceLatLng == null) {
                try {
                  String name = await getPlace(latLng);
                  if (sourceLatLng == null) {
                    setState(() {
                      sourceName = name;
                      sourceLatLng = latLng;
                    });
                  } else if (destinationLatLng == null) {
                    setState(() {
                      destinationName = name;
                      destinationLatLng = latLng;
                    });
                  }
                } catch (e) {
                  print(e.toString());
                }
              }
            },
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              mapController = controller;

              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 310.0 : 270.0;
              });

              setupPositionLocator();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0),
                    Text(
                      "Hi There",
                      style: TextStyle(color: Colors.black, fontSize: 12.0),
                    ),
                    Text(
                      "Where To",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setupPositionLocator();
                      },
                      icon: Icon(Icons.location_on),
                      label: Text('go to my location'),
                    ),
                    Dividerwidget(),
                    ListTile(
                        leading: Icon(Icons.location_on, color: Colors.grey),
                        title: Text(
                          'Source',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          sourceLatLng == null
                              ? 'Please select from map'
                              : sourceName,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: sourceLatLng == null
                            ? SizedBox.shrink()
                            : IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    sourceLatLng = null;
                                    sourceName = "";
                                  });
                                },
                              )),
                    SizedBox(
                      height: 10.0,
                    ),
                    Dividerwidget(),
                    SizedBox(
                      height: 16.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.grey),
                      title: Text(
                        'Destination',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        destinationLatLng == null
                            ? 'Please select from map'
                            : destinationName,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: destinationLatLng == null
                          ? SizedBox.shrink()
                          : IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  destinationLatLng = null;
                                  destinationName = "";
                                });
                              },
                            ),
                    ),
                    Text(
                      'Choose time:',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        selectedTime == null
                            ? 'Click to choose time'
                            : selectedTime.format(context) +
                                ' ( Click to Change time )',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () async {
                        selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {});
                      },
                    ),
                    Text('Choose ride:', style: TextStyle(color: Colors.black),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bike, color: Colors.blue,),
                        Switch(
                          value: switchValue,
                          inactiveThumbColor: Colors.blue,
                          inactiveTrackColor: Colors.blue.withAlpha(150),
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              switchValue = value;
                            });
                          },
                        ),
                        Icon(Icons.time_to_leave, color: Colors.green,),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        color: Colors.blue,
                        child: Text('Confirm destination'),
                        onPressed: () {

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getPlace(LatLng latLng) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    String address =
        "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";

    return address;
  }
}
