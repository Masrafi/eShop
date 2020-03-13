import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttershare/pages/home2.dart';
import 'package:uuid/uuid.dart';
import 'home.dart';
import 'home2.dart';

final postPro1 = Firestore.instance.collection('order');

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  var _royFromController = new TextEditingController();
  var _royFromController2 = new TextEditingController();
  var _royFromController3 = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String postId = Uuid().v4();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool noti;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Notification'),
              content: new Text('payload'),
            ));
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
        0, 'Successfully LogIn', 'Welcome in Bangladesh Railway', platform);
  }

  showNotification1() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(0,
        'Your Order is Being SUCCESSFUL', 'We Connect You Very Soon', platform);
  }

  createPostInFireStore({String code, String phone, String address}) {
    postPro1.document(postId).setData({
      'ProductCode': code,
      'PhoneNumber': phone,
      'Address': address,
      'Time': timestamp,
      'DisplayName': currentUser2.displayName,
      'EmailPhotoUrl': currentUser2.photoUrl,
      'UserName': currentUser2.username
    });
  }

  submit() {
    _formKey.currentState.save();
    createPostInFireStore(
        code: _royFromController.text,
        phone: _royFromController2.text,
        address: _royFromController3.text);

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home2()));
    showNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: Container(
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: ListView(
              children: <Widget>[
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 200.0, left: 15.0, right: 30.0),
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
                        labelText: 'Product Code',

                        // icon: Icon(Icons.location_on),
                        hintText: 'Product Code',
                        filled: true,
                        fillColor: Color(0xFFFFDEAD),
                        labelStyle:
                            TextStyle(fontSize: 20.0, color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 30.0),
                  child: TextFormField(
                    autovalidate: true,
                    keyboardType: TextInputType.text,
                    controller: _royFromController2,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Phone Number is Empty';
                      } else if (val.trim().length < 11) {
                        return 'You pree less then 11 numbers';
                      } else if (val.trim().length > 11) {
                        return 'You press more 11 numbers';
                      } else {}
                    },
                    decoration: InputDecoration(
                        // icon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        // icon: Icon(Icons.location_on),
                        hintText: 'Phone Number',
                        filled: true,
                        fillColor: Color(0xFFFFDEAD),
                        labelStyle:
                            TextStyle(fontSize: 20.0, color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 30.0),
                  child: TextFormField(
                    autovalidate: true,
                    keyboardType: TextInputType.text,
                    controller: _royFromController3,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Text Field is Empty';
                      } else {}
                    },
                    decoration: InputDecoration(
                        // icon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        labelText: 'Present Address',
                        // icon: Icon(Icons.location_on),
                        hintText: 'Present Address',
                        filled: true,
                        fillColor: Color(0xFFFFDEAD),
                        labelStyle:
                            TextStyle(fontSize: 20.0, color: Colors.black)),
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
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        submit();
                        showNotification1();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
