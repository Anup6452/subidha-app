import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:subidha/api.dart';

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

  Set<Marker> _markers = {};
  Set<Polyline> _polyline = {};

  List<LatLng> polylineLatLng = [];

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
            markers: _markers,
            polylines: _polyline,
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            initialCameraPosition: initialCameraPosition,
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onTap: (latLng) async {
              if (destinationLatLng == null || sourceLatLng == null) {
                try {
                  String name = await getPlace(latLng);
                  if (sourceLatLng == null) {
                    setState(() {
                      sourceName = name;
                      sourceLatLng = latLng;
                      _markers.add(Marker(
                        markerId: MarkerId(sourceLatLng.toString()),
                        position: sourceLatLng,
                        infoWindow: InfoWindow(
                          title: 'Source',
                          snippet: 'This is your pickup point',
                        ),
                        icon: BitmapDescriptor.defaultMarker,
                      ));
                      polylineLatLng.add(sourceLatLng);
                      _polyline.add(Polyline(
                        polylineId: PolylineId(sourceLatLng.toString()),
                        visible: true,
                        points: polylineLatLng,
                        color: Colors.blue,
                      ));
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaleFactor: 1.0,
                        ),
                        child: Text('Source choosen, now choose other.',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ));
                  } else if (destinationLatLng == null) {
                    setState(() async {
                      destinationName = name;
                      destinationLatLng = latLng;
                      _markers.add(Marker(
                        markerId: MarkerId(destinationLatLng.toString()),
                        position: destinationLatLng,
                        infoWindow: InfoWindow(
                          title: 'Destination',
                          snippet: 'This is your destination',
                        ),
                        icon: BitmapDescriptor.defaultMarker,
                      ));
                      polylineLatLng.add(destinationLatLng);
                      _polyline.add(Polyline(
                        polylineId: PolylineId(destinationLatLng.toString()),
                        visible: true,
                        points: polylineLatLng,
                        color: Colors.blue,
                      ));
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaleFactor: 1.0,
                        ),
                        child: Text('Destination choosen, now choose other.',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ));
                  }
                } catch (e) {
                  print(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: 1.0,
                      ),
                      child: Text('An error occurred. Try again.',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ));
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
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0),
                  child: ListView(
                    children: [
                      SizedBox(height: 6.0),
                      Text(
                        "Hi There",
                        style: TextStyle(color: Colors.black, fontSize: 12.0),
                      ),
                      Text(
                        "Where To (scroll for more option)",
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setupPositionLocator();
                        },
                        icon: Icon(Icons.location_on),
                        label: Text('go to my location'),
                      ),
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
                                    Marker marker = _markers.firstWhere((marker) => marker.markerId.value == sourceLatLng.toString(),orElse: () => null);
                                    Polyline polyline = _polyline.firstWhere((marker) => marker.polylineId.value == sourceLatLng.toString(),orElse: () => null);
                                    setState(() {
                                      _markers.remove(marker);
                                      _polyline.remove(polyline);
                                      polylineLatLng.remove(sourceLatLng);
                                      sourceLatLng = null;
                                      sourceName = "";
                                    });
                                  },
                                )),
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
                                  Marker marker = _markers.firstWhere((marker) => marker.markerId.value == destinationLatLng.toString(),orElse: () => null);
                                  Polyline polyline = _polyline.firstWhere((marker) => marker.polylineId.value == destinationLatLng.toString(),orElse: () => null);
                                  setState(() {
                                    _markers.remove(marker);
                                    _polyline.remove(polyline);
                                    polylineLatLng.remove(destinationLatLng);
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                textScaleFactor: 1.0,
                              ),
                              child: Text('Date choosen, now choose other.',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ));
                          setState(() {});
                        },
                      ),
                      Text(
                        'Choose ride:',
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_bike,
                            color: Colors.blue,
                          ),
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
                          Icon(
                            Icons.time_to_leave,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: MaterialButton(
                          color: Colors.blue,
                          child: Text('Confirm destination'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
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
