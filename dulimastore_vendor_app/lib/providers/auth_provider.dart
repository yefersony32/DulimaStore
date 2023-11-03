import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  late File image;
  bool isPicAvail = false;
  String pickerError = '';

  late double storeLatitude;
  late double storeLongitude;
  late String storeAddress;
  late String placeName;
  late String email;

  late String error = '';

  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickerError = 'No hay Imagen seleccionada';
      print('No hay Imagen seleccionada');
      notifyListeners();
    }
    return image!;
  }

  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    storeLatitude = _locationData.latitude!;
    storeLongitude = _locationData.longitude!;
    notifyListeners();

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var storeAddress = _addresses.first;
    this.storeAddress = storeAddress.addressLine!;
    placeName = storeAddress.featureName!;
    notifyListeners();
    return storeAddress;
  }

  Future<UserCredential> registerVendor(email, password) async {
    this.email = email;
    notifyListeners();

    late UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'La contraseña proporcionada es demasiado débil.';
        notifyListeners();
        print('La contraseña proporcionada es demasiado débil.');

      } else if (e.code == 'email-already-in-use') {
        error = 'La cuenta ya existe para ese correo electrónico.';
        notifyListeners();
        print('La cuenta ya existe para ese correo electrónico.');
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }


  Future<UserCredential> loginVendor(email, password) async {
    this.email = email;
    notifyListeners();

    late UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        error = 'La contraseña proporcionada es demasiado débil.';
        notifyListeners();
        print('La contraseña proporcionada es demasiado débil.');

      } else if (e.code == 'email-already-in-use') {
        error = 'La cuenta ya existe para ese correo electrónico.';
        notifyListeners();
        print('La cuenta ya existe para ese correo electrónico.');
      }
    } catch (e) {
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  Future<void> resetPasswordVendor(email) async {
    this.email = email;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      error=e.code;
    } catch (e) {
      notifyListeners();
      print(e);
    }
  }



  Future<void> saveVendorDataToDB(
      {String? url, String? storeName, String? mobile, String? dialog}) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user?.uid);
    _vendors.set({
      'uid': user?.uid,
      'storeName': storeName,
      'mobile': mobile,
      'email': email,
      'dialog': dialog,
      'address': '${placeName} : ${storeAddress}',
      'location': GeoPoint(storeLatitude, storeLongitude),
      'storeOpen': true,
      'accVerified': true,
      'rating': 0.00,
      'totalRating': 0,
      'isTopPicked': true,
      'imageUrl': url,

    });
    return null;
  }
}
