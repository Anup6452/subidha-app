import 'package:flutter/material.dart';

class SourceDestinationView extends StatelessWidget {
  final String sourceName;
  final String destinationName;
  final bool isRiderFound;
  final Function cancleFunction;

  SourceDestinationView({
    @required this.sourceName,
    @required this.destinationName,
    @required this.isRiderFound,
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.center,
            child: Text(
              isRiderFound ? 'Rider found' : 'Pending',
              style: TextStyle(
                color: isRiderFound ? Colors.green : Colors.blue,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.red,
            child: Text('Cancle Booking'),
            onPressed: () {
              cancleFunction.call();
            },
          ),
        ],
      ),
    );
  }
}
