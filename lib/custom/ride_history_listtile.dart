import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:subidha/custom/rating.dart';

class RideHistoryListTile extends StatefulWidget {
  final DocumentSnapshot dataWithDetails;

  RideHistoryListTile({
    @required this.dataWithDetails,
  });

  @override
  _RideHistoryListTileState createState() => _RideHistoryListTileState();
}

class _RideHistoryListTileState extends State<RideHistoryListTile> {
  double rating = 3.5;
  bool dataLoading = true;
  bool isRated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRated().then((value) {
      setState(() {
        isRated = value;
        dataLoading = false;
      });
    });
  }

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
              widget.dataWithDetails['sourceName'],
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
              widget.dataWithDetails['destinationName'],
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
              widget.dataWithDetails['phone_number'],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          dataLoading ? LinearProgressIndicator() : Row(
            children: [
              AbsorbPointer(
                absorbing: isRated,
                child: SmoothStarRating(
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
                    });
                  },
                ),
              ),
              isRated ? SizedBox.shrink() : MaterialButton(
                color: Theme.of(context).primaryColor,
                child: Text('Submit'),
                onPressed: () async {
                  setState(() {
                    dataLoading = true;
                  });
                  try {
                    DocumentSnapshot documentSnapshot = await widget.dataWithDetails.reference.get();
                    FirebaseFirestore.instance.collection('booking').doc(documentSnapshot.id).update({
                      'rating': rating,
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                  setState(() async {
                    isRated = await checkRated();
                    dataLoading = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> checkRated() async {
    DocumentSnapshot documentSnapshot = await widget.dataWithDetails.reference.get();
    if(documentSnapshot.data().containsKey('rating')) {
      setState(() {
        rating = documentSnapshot['rating'];
      });
      return true;
    }
    return false;
  }
}
