import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:subidha/screens/profile.dart';

class PasswordchangePage extends StatefulWidget {
  @override
  _PasswordchangePageState createState() => new _PasswordchangePageState();
}

class _PasswordchangePageState extends State<PasswordchangePage> {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    passwordController.dispose();
    newPasswordController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
        ),
        body: Form(
          key: formKey,
          child: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      color: Colors.white,
                    ),
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Change Password',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Old Password',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: 'Old Password',
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.length <= 0) {
                                            return 'Compulsory Field';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'New Password',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                        controller: newPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: 'New Password',
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.length <= 0) {
                                            return 'Compulsory Field';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 45.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                          child: new RaisedButton(
                                        child: new Text("Save"),
                                        textColor: Colors.white,
                                        color: Colors.green,
                                        onPressed: () async {
                                          String currentPassword =
                                              passwordController.text.trim();
                                          String newPassword =
                                              newPasswordController.text.trim();
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          final cred =
                                              EmailAuthProvider.credential(
                                                  email: user.email,
                                                  password: currentPassword);

                                          user
                                              .reauthenticateWithCredential(
                                                  cred)
                                              .then((value) {
                                            user
                                                .updatePassword(newPassword)
                                                .then((value) {
                                              passwordController.text = '';
                                              newPasswordController.text = '';
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Successfully changed password.'),
                                              ));
                                            }).catchError((error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Error occurred try again later.'),
                                              ));
                                            });
                                          }).catchError((err) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Error occurred try again later.'),
                                            ));
                                          });
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                      )),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
