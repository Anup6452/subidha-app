import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SourceDestinationView extends StatelessWidget {
  final DocumentSnapshot dataWithDetails;
  // final String sourceName;
  // final String destinationName;
  // final String phone_number;
  // final bool isRiderFound;
  final Function cancleFunction;

  SourceDestinationView({
    @required this.dataWithDetails,
    // @required this.sourceName,
    // @required this.destinationName,
    // @required this.isRiderFound,
    // @required this.phone_number,
    @required this.cancleFunction,
  });

  @override
  Widget build(BuildContext context) {
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
              dataWithDetails['sourceName'],
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
              dataWithDetails['destinationName'],
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
                'Phone Number',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              dataWithDetails['phone_number'],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            child: Text(
              dataWithDetails['isRiderFound'] ? 'Rider found' : dataWithDetails['hasMeet'] ? 'has meet' : dataWithDetails['isCompleted'] ? 'completed' : 'Pending',
              style: TextStyle(
                color: dataWithDetails['isCompleted'] ? Colors.green : Colors.blue,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.red,
            child: Text('Cancel Booking'),
            onPressed: () {
              cancleFunction.call();
            },
          ),
        ],
      ),
    );
  }
}
