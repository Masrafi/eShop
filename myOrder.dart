import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:uuid/uuid.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String postId = Uuid().v4();
  getDriversList() async {
    return await Firestore.instance.collection('order').getDocuments();
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
                          '${querySnapshot.documents[i].data['DisplayName']} ',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            'Ordered product Code: ${querySnapshot.documents[i].data['ProductCode']}'),
                      ],
                    )

                    /*Row(
                      children: <Widget>[
                        Text(
                          '${querySnapshot.documents[i].data['DisplayName']}  ',
                        ),
                        Text('order the profuct Code:'),
                        Text(
                            '${querySnapshot.documents[i].data['ProductCode']}'),
                      ],
                    )*/
                  ],
                ),
                Divider(
                  thickness: 2.0,
                  height: 15.0,
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
      appBar: header(context, titleText: 'Order Details'),
      body: _showDrivers(),
    );
  }
}
