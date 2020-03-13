import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/models/user2.dart';
import 'package:fluttershare/pages/developer.dart';
import 'package:fluttershare/pages/home2.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import 'create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final userRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User currentUser;
User2 currentUser2;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  String postId = Uuid().v4();

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error User SignIn : $err');
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error User SignIn : $err');
    });
  }

  String maas;

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserFirestore() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.document(user.id).get();
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      userRef.document(user.id).setData({
        'id': user.id,
        'email': user.email,
        'username': username,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'bio': '',
        'timestamp': timestamp,
      });
      doc = await userRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    currentUser2 = User2.fromDocument(doc);
    print(currentUser);
    print(currentUser2);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      //appBar: header(context, titleText: 'Home'),
      body: PageView(
        children: <Widget>[
          //Timeline(),
          Home2(),
          /*RaisedButton(
            child: Text('Logout'),
            onPressed: mas,
          ),*/
          //Text('masrafi'),
          Developer(),
        ],
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.developer_mode)),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.2),
              Theme.of(context).accentColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'SocailApp',
              style: TextStyle(
                fontSize: 90.0,
                fontFamily: 'Signatra',
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
