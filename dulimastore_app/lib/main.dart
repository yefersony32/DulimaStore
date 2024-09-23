
import 'package:dulimastore_app/providers/auth_provider.dart';
import 'package:dulimastore_app/providers/location_provider.dart';
import 'package:dulimastore_app/providers/store_provider.dart';
import 'package:dulimastore_app/screens/home_screen.dart';
import 'package:dulimastore_app/screens/landing_screen.dart';
import 'package:dulimastore_app/screens/login_screen.dart';
import 'package:dulimastore_app/screens/main_screen.dart';
import 'package:dulimastore_app/screens/map_screen.dart';
import 'package:dulimastore_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dulimastore_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'DulimaStore-App',
    options: const FirebaseOptions(
       
    ),
  );
  runApp(MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create: (_)=>AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_)=>LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_)=>StoreProvider(),
        ),
      ],
    child: const MyApp(),
    )
  );
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
        SplashScreen.id:(context)=>const SplashScreen(),
        HomeScreen.id:(context)=>const HomeScreen(),
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        MapScreen.id:(context)=>MapScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LandingScreen.id:(context)=>LandingScreen(),
        MainScreen.id:(context)=>const MainScreen(),



      },
    );
  }
}

