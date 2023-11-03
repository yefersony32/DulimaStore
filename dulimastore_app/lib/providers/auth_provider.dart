import 'dart:async';

import 'package:dulimastore_app/providers/location_provider.dart';
import 'package:dulimastore_app/screens/home_screen.dart';
import 'package:dulimastore_app/screens/landing_screen.dart';
import 'package:dulimastore_app/screens/main_screen.dart';
import 'package:dulimastore_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  late String error = '';
  final UserService _userServices = UserService();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  late String screen;
  double?  latitude;
  double?  longitude;
  String? address;
  String? location;


  Future<void> verifyPhone({BuildContext? context, String? number}) async {
    loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      loading = false;
      print(e.code);
      error = toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend =
        (String verificationId, int? resendToken) async {
      this.verificationId = verificationId;

      smsOtpDialog(context!, number);
    };
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      error = toString();
      loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<dynamic> smsOtpDialog(BuildContext context, String? number) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Column(
              children: [
                Text('Codigo de Verificacion'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Ingresa los 6 Digitos enviados por Sms',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  smsOtp = value;
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);

                      final User? user =
                          (await _auth.signInWithCredential(credential)).user;

                      if (user!= null) {
                        loading = false;
                        notifyListeners();
                        _userServices.getUserById(user.uid).then((snapShot) {
                          if (snapShot.exists) {
                            if (screen == 'Login') {
                              if(snapShot['address']!= null){
                                Navigator.pushReplacementNamed(
                                    context, MainScreen.id);
                              }
                              Navigator.pushReplacementNamed(
                                  context, LandingScreen.id);
                            } else {
                              updateUser(id: user.uid,number: user.phoneNumber);
                              Navigator.pushReplacementNamed(
                                  context, MainScreen.id);
                            }
                          } else {
                            _createUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(
                                context, LandingScreen.id);
                          }
                        });
                      } else {
                        print('Ingreso Fallido');
                      }
                    } catch (e) {
                      error = 'Autentificacion Invalida';
                      notifyListeners();
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('listo'))
            ],
          );
        }).whenComplete((){
          loading=false;
          notifyListeners();
    });
  }

  void _createUser({String? id, String? number}) {
    _userServices.createDataUser({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'location': location,

    });
    loading = false;
    notifyListeners();
  }

  void updateUser (
      {String? id,
      String? number}) {
      _userServices.updateDataUser({
        'id': id,
        'number': number,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'location': location,

      });
      loading = false;
      notifyListeners();
  }
}
