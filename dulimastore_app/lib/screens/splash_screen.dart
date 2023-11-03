import 'package:dulimastore_app/screens/home_screen.dart';
import 'package:dulimastore_app/screens/landing_screen.dart';
import 'package:dulimastore_app/screens/main_screen.dart';
import 'package:dulimastore_app/screens/welcome_screen.dart';
import 'package:dulimastore_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash-Screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user==null){
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }else{
          getUserData();

        }
      });
    }
    );
    super.initState();
  }

  getUserData() async{
    UserService _Userservice = UserService();
    _Userservice.getUserById(user!.uid).then((result) {
      if(result['latitude']!=null){
        updatePrefes(result);
      }
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void>updatePrefes(result)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);

    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Hero(
            tag:'DulimaStore',
            child: Image(image: AssetImage('assets/images/DulimaStore.png'),
            ),
          )
      ),
    );
  }
}


