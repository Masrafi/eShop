import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

final StorageReference storageReference = FirebaseStorage.instance.ref();
final postPro = Firestore.instance.collection('product');

class Developer extends StatefulWidget {
  final User currentUser;
  Developer({this.currentUser});
  @override
  _DeveloperState createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {
  String productCode;
  String productPrice;
  String shopName;
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();
  handleCamera() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 650.0,
      maxWidth: 950.0,
    );
    setState(() {
      this.file = file;
    });
  }

  handleGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create Post'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Image With Camera'),
                onPressed: handleCamera,
              ),
              SimpleDialogOption(
                child: Text('Image With Gallery'),
                onPressed: handleGallery,
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildForm() {
    return Container(
      color: Theme.of(context).accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              child: Text(
                'Upload Image',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.orange,
              onPressed: () => selectImage(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  final _formKey = GlobalKey<FormState>();

  compressImage() async {
    final temDir = await getTemporaryDirectory();
    final path = await temDir.path;
    Im.Image imageFilw = Im.decodeImage(file.readAsBytesSync());
    final compressImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFilw, quality: 100));
    setState(() {
      file = compressImageFile;
    });
  }

  uploadImage(imageFilw) async {
    StorageUploadTask storageUploadTask =
        await storageReference.child('post_$postId.jpg').putFile(imageFilw);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFireStore(
      {String mediUrl,
      String price,
      String code,
      String shop,
      String location}) {
    postPro.document(postId).setData({
      'ProductPrice': price,
      'ProductCode': code,
      'ShopName': shop,
      'timestream': timestamp,
      'PostMediaUrl': mediUrl,
      'Name': currentUser.username,
      'EmailPhotoUrl': currentUser.photoUrl,
      'DisplayName': currentUser.displayName,
      'Location': location
    });
  }

  createPost() async {
    _formKey.currentState.save();
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFireStore(
        mediUrl: mediaUrl,
        price: productPrice,
        code: productCode,
        shop: shopName,
        location: locationController.text);
    setState(() {
      file = null;
      isUploading = false;
    });
  }

  TextEditingController locationController = TextEditingController();

  Scaffold buildPostScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: clearImage,
        ),
        title: Text(
          'Caption For Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            onPressed: isUploading
                ? null
                : () {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      createPost();
                    }
                  },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text('Empty'),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.9,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(file),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 20.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Product Code",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Product Code Empty";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => productCode = val,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Price",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Price is empty";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => productPrice = val,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Shope Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Shope Name is empty";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => shopName = val,
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        controller: locationController,
                        validator: (val) {
                          if (val.length == 0) {
                            return "Click The Add Location Button";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Add Location For Image',
                          border: InputBorder.none,
                        ),
                      ),
                      Container(
                        height: 100.0,
                        width: 200.0,
                        alignment: Alignment.center,
                        child: RaisedButton.icon(
                          label: Text(
                            'Add location',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          color: Colors.blueAccent,
                          onPressed: getCurrentUserLocation,
                          icon: Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  getCurrentUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> marks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = marks[0];
    String complteAddress =
        '${placemark.name},${placemark.subAdministrativeArea}';
    locationController.text = complteAddress;
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildForm() : buildPostScreen();
  }
}
