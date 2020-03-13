import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/selection.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Selection()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/mas3.PNG',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80.0, left: 90.0),
            child: Row(
              children: <Widget>[
                Text(
                  'e-ShoP',
                  style: TextStyle(
                    /*color: Colors.red[900],
                      backgroundColor: Colors.black,
                      fontSize: 50.0,
                      fontStyle: FontStyle.italic,
                      //decorationStyle: TextDecorationStyle.dashed,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      fontWeight: FontWeight.bold,*/
                    fontSize: 60,
                    fontStyle: FontStyle.italic,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = Color(0xFF585858),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
