import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subidha/custom/source_destination_view.dart';

class MyBookingList extends StatefulWidget {
  @override
  _MyBookingListState createState() => _MyBookingListState();
}

class _MyBookingListState extends State<MyBookingList> {
  final FirebaseAuth fbAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Query bookingCollection = FirebaseFirestore.instance
        .collection('booking')
        .where('user_id', isEqualTo: fbAuth.currentUser.uid)
        .where('isCompleted', isEqualTo: false);
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
                  child: Text('No Bookings'),
                );
              }
              return new ListView(
                children:
                    List.generate(bookingSnapshot.data.docs.length, (index) {
                  var dataWithDetails = bookingSnapshot.data.docs[index];
                  return SourceDestinationView(
                    isRiderFound: dataWithDetails['isCompleted'],
                    sourceName: dataWithDetails['sourceName'],
                    destinationName: dataWithDetails['destinationName'],
                    phone_number: dataWithDetails['phone_number'],
                    cancleFunction: () async {
                      await FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        transaction
                            .delete(bookingSnapshot.data.docs[index].reference);
                      });
                      setState(() {});
                    },
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
