import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';

class Driver extends StatefulWidget {
  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  var _royFromController = new TextEditingController();
  var _royFromController2 = new TextEditingController();

  String value = "eShop";
  String value1 = "masrafi42";
  String fildValue, fillValue2;

  submit() {
    fildValue = _royFromController.text;
    fillValue2 = _royFromController2.text;
    setState(() {
      if (value == fildValue && value1 == fillValue2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        return 'You provide wrong password';
      }
    });
    _royFromController.clear();
    _royFromController2.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF8095),
      body: ListView(
        children: <Widget>[
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 200.0, left: 15.0, right: 15.0),
            child: TextFormField(
              autovalidate: true,
              keyboardType: TextInputType.text,
              controller: _royFromController,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Text Field is Empty';
                } else {}
              },
              decoration: InputDecoration(
                  // icon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                  labelText: 'User Name',

                  // icon: Icon(Icons.location_on),
                  hintText: 'User Name',
                  filled: true,
                  fillColor: Color(0xFFFFDEAD),
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.black)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: TextFormField(
              autovalidate: true,
              keyboardType: TextInputType.text,
              controller: _royFromController2,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Text Field is Empty';
                } else {}
              },
              decoration: InputDecoration(
                  // icon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  // icon: Icon(Icons.location_on),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Color(0xFFFFDEAD),
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.black)),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 120.0, right: 120.0),
              child: RaisedButton(
                color: Color(0xFFFF1493),
                child: Text('Submit'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () {
                  submit();
                },
              ))
        ],
      ),
    );
  }
}
