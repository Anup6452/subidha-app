import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                )
              ]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5.0,),
                  Stack(
                    children: <Widget>[
                      BackButton(),
                      Center(
                        child: Text('Set Destination',
                            style: TextStyle(color: Colors.black,)),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.0,),

                  Row(
                    children: <Widget>[
                      Image.asset('assets/destination.png',height: 16,width: 16,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Pickup Location',
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 10, top: 8.0, bottom: 8.0)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10.0,),

                  Row(
                    children: <Widget>[
                      Image.asset('assets/Source.png',height: 16,width: 16,),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Destination Location',
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10, top: 8.0, bottom: 8.0)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
