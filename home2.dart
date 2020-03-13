import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/myOrder.dart';
import 'package:fluttershare/pages/order.dart';
import 'package:fluttershare/widgets/header.dart';

import 'home.dart';

class Home2 extends StatefulWidget {
  final User currentUser;
  Home2({this.currentUser});
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  logout() {
    googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  getDriversList() async {
    return await Firestore.instance.collection('product').getDocuments();
  }

  QuerySnapshot querySnapshot;
  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  Widget _showDrivers() {
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.documents.length,
        padding: EdgeInsets.all(12.0),
        itemBuilder: (context, i) {
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25.0,
                      //child: Icon(CupertinoIcons.person,size: 65.0,),
                      backgroundImage: NetworkImage(
                          '${querySnapshot.documents[i].data['EmailPhotoUrl']}'),
                    ),
                    VerticalDivider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${querySnapshot.documents[i].data['DisplayName']}',
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                        Text('${querySnapshot.documents[i].data['Location']}')
                      ],
                    )
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                Image.network(
                  '${querySnapshot.documents[i].data['PostMediaUrl']}',
                  height: 450.0,
                  loadingBuilder: (context, child, progress) {
                    return progress == null ? child : LinearProgressIndicator();
                  },
                ),
                Divider(
                  thickness: 2.0,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Code: ${querySnapshot.documents[i].data['ProductCode']}',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      'Price: ${querySnapshot.documents[i].data['ProductPrice']}',
                      style: TextStyle(fontSize: 20.0),
                    )
                  ],
                ),
                Divider(
                  thickness: 2.0,
                  indent: 10.0,
                  endIndent: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.comment),
                            VerticalDivider(),
                            Text('Order')
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Order()));
                        },
                        color: Color(0xFFC0C0C0),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Color(0xFFC0C0C0),
                  height: 30.0,
                  thickness: 20.0,
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Home')),
          backgroundColor: Colors.teal,
          actions: <Widget>[
            RaisedButton(
              color: Colors.teal,
              child: Text('Sign Up'),
              onPressed: logout,
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Image.asset('assets/images/Capture2.PNG'),
              ListTile(
                title: Text('Order'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyOrder()));
                },
                leading: Icon(Icons.attach_money),
              ),
              ListTile(
                title: Text('Ticket'),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Second()));
                },
                leading: Icon(Icons.panorama_vertical),
              ),
              ListTile(
                title: Text('Gallery'),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Mas()));
                },
                leading: Icon(Icons.image),
              ),
              ListTile(
                title: Text('Schedule Details'),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>Four()));
                },
                leading: Icon(Icons.palette),
              ),
              Divider(
                height: 20.0,
              ),
              ListTile(
                title: Text('close'),
                trailing: Icon(Icons.close, color: Colors.red),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
        backgroundColor: Color(0xFFC0C0C0),
        body: _showDrivers());
  }
}
