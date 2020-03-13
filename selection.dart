import 'package:flutter/material.dart';
import 'package:fluttershare/pages/developer.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/home2.dart';
import 'package:fluttershare/pages/registration.dart';

class Selection extends StatefulWidget {
  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 250.0),
            child: RaisedButton(
              child: Text(
                'User',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home2()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )),
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              child: Text(
                'Owner',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Driver()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
