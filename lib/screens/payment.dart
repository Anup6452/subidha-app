import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => new _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
        title: new Text('Payment Page'),
      ),
      body: new Container(
        padding: const EdgeInsets.fromLTRB(16.0, 45.0, 16.0, 140.0),

        child: Container(
          //width: 320.0,
          color: theme.primaryColor,
          padding: const EdgeInsets.fromLTRB(60.0, 40.0, 50.0, 16.0),
          child: Column(
            children: [
              Text('You can pay through', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 18.0,),
              Text('Khalti', style: TextStyle(fontWeight: FontWeight.bold) ,),
              SizedBox(height: 30.0,),
            ],
          ),
        ),
      ),
    );
  }
}
