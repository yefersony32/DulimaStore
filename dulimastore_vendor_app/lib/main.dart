import 'package:dulimastore_vendor_app/providers/auth_provider.dart';
import 'package:dulimastore_vendor_app/screens/home_screen.dart';
import 'package:dulimastore_vendor_app/screens/login_screen.dart';
import 'package:dulimastore_vendor_app/screens/register_screen.dart';
import 'package:dulimastore_vendor_app/screens/splash_screen.dart';
import 'package:dulimastore_vendor_app/widgets/reset_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'DulimaStore-App',
    options: const FirebaseOptions(
        apiKey: "AIzaSyCR5IgtvvODOZFiGz13WUI1uBEFOCFgI9Q",
        authDomain: "dulimastore-79cd5.firebaseapp.com",
        projectId: "dulimastore-app",
        storageBucket: "dulimastore-79cd5.appspot.com",
        messagingSenderId: "340326267932",
        appId: "1:506140097627:android:d79f8b57e7ac491915537e"),
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => AuthProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink,
        fontFamily: 'Lato',
      ),
      home: const SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id:(context) => const LoginScreen(),
        ResetPassword.id:(context)=> const ResetPassword(),
      },
    );
  }
}
