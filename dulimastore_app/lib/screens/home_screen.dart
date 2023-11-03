
import 'package:dulimastore_app/providers/auth_provider.dart';
import 'package:dulimastore_app/providers/location_provider.dart';
import 'package:dulimastore_app/screens/map_screen.dart';
import 'package:dulimastore_app/widgets/near_by_store.dart';
import 'package:dulimastore_app/widgets/top_pick_store.dart';
import 'package:dulimastore_app/screens/welcome_screen.dart';
import 'package:dulimastore_app/widgets/image_slider.dart';
import 'package:dulimastore_app/widgets/my_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'home-Screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final auth =Provider.of<AuthProvider>(context);
    final locationData =Provider.of<LocationProvider>(context);

    return Scaffold(
     
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool inneBoxIsScrolled){
          return [
            MyAppbar()
           ];
        },
        body: ListView(
        children: [
          const ImageSlider(),
          Container(
              child: const TopPickStoreScreen()
          ),
          // const Padding(
          //   padding: EdgeInsets.only(top: 3),
          //   child: NearByStore(),
          // ),

        ],
          ),
      ),
    );
  }
}
