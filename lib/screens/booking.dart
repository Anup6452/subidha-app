import 'package:flutter/material.dart';
import 'package:subidha/screens/my_booking_list.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => new _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Container buildTitle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      alignment: Alignment.bottomCenter,
    );
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Booking Page'),
      ),
      body: MyBookingList(),
    );
  }
}
