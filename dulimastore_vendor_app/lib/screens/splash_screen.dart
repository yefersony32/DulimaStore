
import 'package:dulimastore_vendor_app/screens/home_screen.dart';
import 'package:dulimastore_vendor_app/screens/login_screen.dart';
import 'package:dulimastore_vendor_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash-Screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user==null){
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);

        }
      });
    }
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Hero(
            tag:'DulimaStoreVendor',
            child: Image(image: AssetImage('assets/images/DulimaStoreVendor.png'),
            ),
          )
      ),
    );
  }
}


