import 'package:dulimastore_app/screens/welcome_screen.dart';
import 'package:dulimastore_app/services/store_service.dart';
import 'package:dulimastore_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StoreProvider with ChangeNotifier {
  StoreServices _storeServices = StoreServices();
  UserService _userService = UserService();
  User? user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;


  Future<void> getUserLocationData(context) async {
    _userService
        .getUserById(user!.uid)
        .then((result) {
      if (user != null) {
        this.userLatitude = result['latitude'];
        this.userLongitude = result['longitude'];
        notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });}
}