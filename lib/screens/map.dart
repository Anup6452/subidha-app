import 'dart:async';
import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subidha/api.dart';
import 'package:subidha/custom/Notification.dart';

import 'dart:math' show cos, sqrt, asin;

import 'package:subidha/reusable/text_form_field_1.dart';

import 'package:subidha/helpers/networkhelper.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;
  double searchSheetWidget = (Platform.isIOS) ? 300 : 305;

  FocusNode phoneNumberFocus;
  TextEditingController phoneController;
  final _formKey = GlobalKey<FormState>();
  String _placeDistance;
  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;

  LatLng sourceLatLng;
  LatLng destinationLatLng;
  String sourceName = "";
  String destinationName = "";
  TimeOfDay selectedTime;

  final RegExp phoneNumberRegExp =
      new RegExp(r"^(984|985|986|974|975|980|981|982|961|988|972|963)\d{7}$");

  Set<Marker> _markers = {};
  Set<Polyline> _polyline = {};

  List<LatLng> polylineLatLng = [];

  bool switchValue = false;

  var geoLocator = Geolocator();
  Position currentPosition;

  @override
  void initState() {
    super.initState();
    phoneNumberFocus = FocusNode();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumberFocus.dispose();
    phoneController.dispose();
    super.dispose();
  }

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

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  double totalDistance = 0.0;

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
                for (int i = 0; i < polylineCoordinates.length - 1; i++) {
                  totalDistance += _coordinateDistance(
                    polylineCoordinates[i].latitude,
                    polylineCoordinates[i].longitude,
                    polylineCoordinates[i + 1].latitude,
                    polylineCoordinates[i + 1].longitude,
                  );
                }
                _placeDistance = totalDistance.toStringAsFixed(2);
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
                    });
                  } else if (destinationLatLng == null) {
                    setState(() {
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
                    });
                  }
                } catch (e) {
                  print('tapping error' + e.toString());
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    totalDistance = 0.0;
                                    Marker marker = _markers.firstWhere(
                                        (marker) =>
                                            marker.markerId.value ==
                                            sourceLatLng.toString(),
                                        orElse: () => null);
                                   Polyline polyline = _polyline.firstWhere((marker) => marker.polylineId.value == sourceLatLng.toString(),orElse: () => null);
                                    setState(() {
                                      _markers.remove(marker);
                                      polylineCoordinates.clear();
                                     _polyline.clear();
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
                                  totalDistance = 0.0;
                                  Marker marker = _markers.firstWhere(
                                      (marker) =>
                                          marker.markerId.value ==
                                          destinationLatLng.toString(),
                                      orElse: () => null);
                                 // Polyline polyline = _polyline.firstWhere((marker) => marker.polylineId.value == destinationLatLng.toString(),orElse: () => null);
                                  setState(() {
                                    _markers.remove(marker);
                                   _polyline.clear();
                                    polylineCoordinates.clear();
                                    polylineLatLng.remove(destinationLatLng);
                                    destinationLatLng = null;
                                    destinationName = "";
                                  });
                                },
                              ),
                      ),
                      MaterialButton(
                        child: Text('View direction',style: TextStyle(color: Colors.black,),),
                        onPressed: () async {

                          if(sourceLatLng == null || destinationLatLng == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Select both source and destination first', style: TextStyle(color: Colors.white),),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }
                          PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
                            kDirectionApi,
                            PointLatLng(sourceLatLng.latitude, sourceLatLng.longitude),
                              PointLatLng(destinationLatLng.latitude, destinationLatLng.longitude)
                          );
                          for (PointLatLng point in result.points) {
                            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
                          }
                          for (int i = 0; i < polylineCoordinates.length - 1; i++) {
                            totalDistance += _coordinateDistance(
                              polylineCoordinates[i].latitude,
                              polylineCoordinates[i].longitude,
                              polylineCoordinates[i + 1].latitude,
                              polylineCoordinates[i + 1].longitude,
                            );
                          }
                          setState(() {
                            Polyline polyline = Polyline(
                                polylineId: PolylineId("poly"),
                                color: Color.fromARGB(255, 40, 122, 198),
                                points: polylineCoordinates);
                            _polyline.add(polyline);
                            _placeDistance = totalDistance.toStringAsFixed(2);
                          });
                        },
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
                            initialTime: TimeOfDay.fromDateTime(
                                DateTime.now().add(Duration(minutes: 20))),
                          );
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
                      Form(
                        key: _formKey,
                        child: TextFormField1(
                          focusNode: phoneNumberFocus,
                          placeholder: 'Phone number',
                          textEditingController: phoneController,
                          showPhoneNumberPrefix: true,
                          textInputType: TextInputType.numberWithOptions(
                            decimal: false,
                            signed: true,
                          ),
                          isPhoneNumber: true,
                          validator: (value) {
                            if (value == "")
                              return "Phone number needed";
                            else if (!phoneNumberRegExp.hasMatch(value))
                              return "Enter valid phone number";
                            return null;
                          },
                          onNext: () {},
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: MaterialButton(
                          color: Colors.blue,
                          child: Text('Confirm destination and calculate cost'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              calculate();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
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

  calculate() {
    if (sourceLatLng == null) {
      showCustomSnackBar('Select source first');
    } else if (destinationLatLng == null) {
      showCustomSnackBar('Select destination first');
    } else if (selectedTime == null) {
      showCustomSnackBar('Select time first');
    } else {
      showDialog(
        context: context,
        builder: (context) => Theme(
          data: ThemeData.light(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: AlertDialog(
              title: Text('Confirmation'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView(
                  children: [
                    Text(
                      'Source:',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      sourceName,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black45,
                          ),
                    ),
                    Text(
                      'Destination:',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      'Destination: ' + destinationName,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black45,
                          ),
                    ),
                    Text(
                      'Ride:',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      switchValue ? 'Taxi' : 'Motorcycle',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black45,
                          ),
                    ),
                    Text(
                      'Time:',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      selectedTime.format(context),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black45,
                          ),
                    ),
                    Text(
                      'Distance: $_placeDistance KM',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      'Price: ${estimateFair(switchValue, totalDistance).toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.black,
                      ),),
                    // ),
//                    Text(
//                      calculateDistance(
//                          sourceLatLng.latitude,
//                          sourceLatLng.longitude,
//                          destinationLatLng.latitude,
//                          destinationLatLng.longitude),
//                      style: Theme.of(context).textTheme.bodyText1.copyWith(
//                            color: Colors.black45,
//                          ),
//                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  icon: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  label: Text(
                    'Book',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    bookRide();
                    Navigator.pop(context);
                  },
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Don\'t Book',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  bookRide() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
      firebaseFireStore.collection('booking').add({
        'sourceLat': sourceLatLng.latitude.toString(),
        'sourceLng': sourceLatLng.longitude.toString(),
        'destinationLat': destinationLatLng.latitude.toString(),
        'destinationLng': destinationLatLng.longitude.toString(),
        'sourceName': sourceName,
        'destinationName': destinationName,
        'time_hour': selectedTime.hour,
        'time_minute': selectedTime.minute,
        'ride': switchValue,
        'user_id': auth.currentUser.uid ?? "",
        'user_name': auth.currentUser.displayName ?? "",
        'user_email': auth.currentUser.email ?? "",
        'profile_img': auth.currentUser.photoURL ?? "",
        'phone_number': phoneController.value.text,
        'distance': totalDistance,
        'isRiderFound': false,
        'hasMeet': false,
        'isCompleted': false,
        'rider_id': '',
      }).then((value) {
        phoneNumberFocus.unfocus();
        phoneController.text = "";
        setState(() {
          sourceLatLng = null;
          sourceName = "";
          destinationLatLng = null;
          destinationName = "";
          selectedTime = null;
          switchValue = false;
          markers.clear();
        });
        CustomNotification(
          title: 'Successful',
          color: Colors.green,
          message:
              'Successfully booked you can see bookings in side menu. The rider will contact you.',
        ).show(context);
      }).catchError((error) {
        print(error.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  showCustomSnackBar(String errorText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Text(errorText,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    ));
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

   double estimateFair (bool ride, double _placeDistance) {
    double baseFare;
    double multiplier;
    if(ride) {
      baseFare = 100;
      multiplier = 40;
    }
    else {
      baseFare = 50;
      multiplier = 20;
    }
    double distanceFare = _placeDistance * multiplier;
    return baseFare + distanceFare;
  }
}