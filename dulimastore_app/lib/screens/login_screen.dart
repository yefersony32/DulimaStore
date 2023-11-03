import 'package:dulimastore_app/providers/auth_provider.dart';
import 'package:dulimastore_app/providers/location_provider.dart';
import 'package:dulimastore_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-Screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _ValidPhoneNumber = false;
  final _phoneNumberController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);


    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: auth.error=='Autentificacion Invalida' ? true:false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(auth.error,
                          style:const TextStyle(
                              color: Colors.pink,
                              fontSize: 20),),
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
                const Text('Inicio de Sesionn',
                  style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                const Text('Ingresa Tu Numero para Iniciar',
                  style:TextStyle(fontSize: 12) ,),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                      prefixText: '+57  ',
                      labelText: '10 digitos del Numero Telefonico.'
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumberController,
                  onChanged: (value){
                    if(value.length == 10){
                      setState((){
                        _ValidPhoneNumber = true;
                      });
                    }else{
                      setState((){
                        _ValidPhoneNumber = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10,),
                Row(
                  children:[
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _ValidPhoneNumber ? false:true,
                        child: TextButton(
                          onPressed: () {

                            setState((){
                              auth.loading=true;
                              auth.screen= 'MapScreen';
                              auth.latitude = locationData.latitude;
                              auth.longitude = locationData.longitude;
                              auth.address = locationData.selectAdresse.addressLine;


                            });
                            String number = '+57${_phoneNumberController.text}';
                            auth.verifyPhone(
                              context: context,
                              number: number,

                            ).then((value){
                              _phoneNumberController.clear();
                              setState(() {
                                auth.loading=false;
                              });
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll<Color>(Colors.pinkAccent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: auth.loading? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ) : Text(_ValidPhoneNumber ? 'CONTINUE' : 'Ingresa Tu numero de telefono'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
