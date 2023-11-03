import 'dart:async';

import 'package:dulimastore_admin_web/screens/home_screen.dart';
import 'package:dulimastore_admin_web/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Hero(
          tag:'DulimaStore',
          child: Image(image: AssetImage('assets/images/DulimaStore.png'),
          ),
        )
    );
  }
}
