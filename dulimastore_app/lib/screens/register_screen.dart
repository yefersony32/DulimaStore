import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Hero(tag:'DulimaStore',
                  child: Image(image: AssetImage('assets/images/DulimaStore.png'),),),
              TextField(),
              TextField(),
              TextField(),
              TextField(),

            ],
          ),
        ),
      ),
    );
  }
}
