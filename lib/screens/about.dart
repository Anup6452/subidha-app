import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => new _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        title: new Text('About Page'),
      ),
      body: new Container(
        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),

        child: Container(
          //width: 320.0,
          color: theme.primaryColor,
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Column(
            children: [
              Text('What is Subidha', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 18.0,),
              Text('Subidha is an application like a tootle and pathao fo rthe use of public')
            ],
          ),
        ),
      ),
    );
  }
}
