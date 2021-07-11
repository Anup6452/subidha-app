import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subidha/custom/ride_history_listtile.dart';

class RideHistoryList extends StatefulWidget {
  @override
  _RideHistoryListState createState() => _RideHistoryListState();
}

class _RideHistoryListState extends State<RideHistoryList> {
  final FirebaseAuth fbAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Query bookingCollection = FirebaseFirestore.instance
        .collection('booking')
        .where('user_id', isEqualTo: fbAuth.currentUser.uid)
        .where('isCompleted', isEqualTo: true);
    return Container(
      child: FutureBuilder(
        future: bookingCollection.get(),
        builder: (context, bookingSnapshot) {
          if (bookingSnapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (bookingSnapshot.hasError) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              if (bookingSnapshot.data.docs.length == 0) {
                return Center(
                  child: Text('No Ride History'),
                );
              }
              return new ListView(
                children:
                    List.generate(bookingSnapshot.data.docs.length, (index) {
                  var dataWithDetails = bookingSnapshot.data.docs[index];
                  return RideHistoryListTile(
                    sourceName: dataWithDetails['sourceName'],
                    destinationName: dataWithDetails['destinationName'],
                    phone_number: dataWithDetails['phone_number'],
                  );
                }),
              );
            }
          }
        },
      ),
    );
  }
}
