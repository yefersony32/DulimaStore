import 'package:dulimastore_vendor_app/widgets/image_picker.dart';
import 'package:dulimastore_vendor_app/widgets/register_form.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = 'register-Screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [Text('Registra tu tienda',style: TextStyle(color: Colors.black,fontSize: 20),	textAlign: TextAlign.center,),
                  ImageShopPicCard(),
                  RegisterForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
