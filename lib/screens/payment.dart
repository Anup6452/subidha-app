import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:subidha/custom/Notification.dart';

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
              RaisedButton(
                child: Text('Pay with Khalti'),
                  onPressed: (){
                _sendToKhalti(context);
              })
            ],
          ),
        ),
      ),
    );
  }

  _sendToKhalti(BuildContext context) {
    FlutterKhalti _flutterKhalti = FlutterKhalti.configure(
        publicKey: 'test_public_key_e13c60b9414945f19d0b7c1324e636ec',
        urlSchemeIOS: 'KhaltiPayFlutterExampleSchema'
    );
    KhaltiProduct product = KhaltiProduct(
        id: 'Test',
        name: 'Pay for Ride',
        amount: 1000.00,
    );
    _flutterKhalti.startPayment(
        product: product,
        onSuccess: (data)async {
          try {
            CustomNotification(title: 'Success',
              color: Colors.green,
            ).show(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>PaymentPage()));
          }catch (e) {
            CustomNotification(
              title: e,
              color: Theme.of(context).errorColor,
            ).show(context);
          }
        },
        onFaliure: (error){
          CustomNotification(
            title: 'Error',
            color: Theme.of(context).errorColor,
          ).show(context);
        }
        );

  }

}
