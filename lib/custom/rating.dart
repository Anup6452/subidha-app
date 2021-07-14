import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Rating extends StatefulWidget {
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double rating = 4.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Rating Dialog In Flutter'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.cyan,
            padding: EdgeInsets.only(left: 30,right: 30),
            child: Text('Rating Dialog',style: TextStyle
              (color: Colors.white,fontSize: 10),
            ),
            onPressed: _showRatingAppDialog,
          ),

            Text(
              "Library First :  'Smooth Star Rating' ",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            SmoothStarRating(
              rating: rating,
              size: 35,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              onRated: (value) {
                setState(() {
                  rating = value;
                  print(rating);
                });
              },
            ),
            Text(
              "You have Selected : $rating Star",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Library Second:  'Rating_Dialog ' ",
              style: TextStyle(fontSize: 20, color: Colors.deepOrange),
            ),
            RaisedButton(
              onPressed: () {
              },
              child: Text("Open Flutter Rating Dialog Box"),
            )
          ],
        ),
      ),
    );

  }

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: 'Rating Dialog In Flutter',
      message: 'Rating this app and tell others what you think.'
          ' Add more description here if you want.',
      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

}