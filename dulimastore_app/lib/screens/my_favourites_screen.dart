import 'package:flutter/material.dart';

class MyFavouritesScreen extends StatefulWidget {
  const MyFavouritesScreen({Key? key}) : super(key: key);
  static const String id = 'my-favourites-Screen';

  @override
  State<MyFavouritesScreen> createState() => _MyFavouritesScreenState();
}

class _MyFavouritesScreenState extends State<MyFavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Mis Favoritos'),
      ),
    );
  }
}
