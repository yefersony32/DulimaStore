import 'package:dulimastore_admin_web/screens/admin_users_screen.dart';
import 'package:dulimastore_admin_web/screens/category_screen.dart';
import 'package:dulimastore_admin_web/screens/home_screen.dart';
import 'package:dulimastore_admin_web/screens/login_screen.dart';
import 'package:dulimastore_admin_web/screens/manager_banner.dart';
import 'package:dulimastore_admin_web/screens/notification_screen.dart';
import 'package:dulimastore_admin_web/screens/orders_screen.dart';
import 'package:dulimastore_admin_web/screens/settings_screen.dart';
import 'package:dulimastore_admin_web/screens/splash_screen.dart';
import 'package:dulimastore_admin_web/screens/ventor_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(

    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        HomeScreen.id:(context)=>const HomeScreen(),
        SplashScreen.id:(context)=> const SplashScreen(),
        LoginScreen.id:(context)=>  LoginScreen(),
        BannerScreen.id:(context)=>  BannerScreen(),
        VendorScreen.id:(context)=>  VendorScreen(),
        CategoryScreen.id:(context)=>  const CategoryScreen(),
        OrdersScreen.id:(context)=>  const OrdersScreen(),
        NotificationScreen.id:(context)=>  const NotificationScreen(),
        AdminUsersScreen.id:(context)=>  const AdminUsersScreen(),
        SettingsScreen.id:(context)=>  const SettingsScreen(),






      },
    );
  }
}


