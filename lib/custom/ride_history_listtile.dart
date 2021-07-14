
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:subidha/custom/rating.dart';

class RideHistoryListTile extends StatelessWidget {
  final String sourceName;
  final String destinationName;
  final String phone_number;

  RideHistoryListTile({
    @required this.sourceName,
    @required this.destinationName,
    @required this.phone_number,
  });
  double rating = 4.0;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth fbAuth = FirebaseAuth.instance;
    Query bookingCollection = FirebaseFirestore.instance
        .collection('booking')
        .where('user_id', isEqualTo: fbAuth.currentUser.uid)
        .where('isCompleted', isEqualTo: true);

    return Container(
      color: Colors.grey.shade200,
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                'Source',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              sourceName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                'Destination',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              destinationName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                'Phone_number',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              phone_number,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Row(
            children: [
            SmoothStarRating(
              rating: rating,
              size: 35,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              onRated: (value) {
                setState(() {
                  rating = value;
                  print(rating);
                });
              },
            ),

              MaterialButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Submit'),
                  onPressed: () async {
    try {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    firebaseFireStore.collection('booking').add({
    'user_id': auth.currentUser.uid ?? "",
    'rating': rating,
    'rider_id': '',
    });
    } catch (e) {
    print(e.toString());
    }
    },
  ),
            ],
          ),
        ],
      ),
    );
  }
  void setState(Null Function() param0) {}
}
