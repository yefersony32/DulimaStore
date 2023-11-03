import 'package:dulimastore_app/providers/auth_provider.dart';
import 'package:dulimastore_app/providers/location_provider.dart';
import 'package:dulimastore_app/screens/map_screen.dart';
import 'package:dulimastore_app/screens/onboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'welcome-Screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    bool _ValidPhoneNumber = false;
    final _phoneNumberController =TextEditingController();
    void showBottonSheet(context){
      showModalBottomSheet(
        context: context,
        builder: (context)=>StatefulBuilder(
          builder: (context, StateSetter myState){
            return Container(
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
                      const Text('Inicio de Sesion',
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
                            myState((){
                              _ValidPhoneNumber = true;
                            });
                          }else{
                            myState((){
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
                                  myState((){
                                    auth.loading=true;
                                  });
                                  String number = '+57${_phoneNumberController.text}';
                                  auth.verifyPhone(
                                    context: context,
                                    number: number,
                                  ).then((value){
                                    _phoneNumberController.clear();
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
                )
            );
          },
        ),
      ).whenComplete((){
        setState(() {
          auth.loading=false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: TextButton(
                child: const Text('Saltar',style: TextStyle(color: Colors.pink),),
                onPressed: () {},),),
            Column(
              children: [
                const Expanded(child: OnBoardScreen()),
                const Text('¿Listo para hacer compras?'),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(Colors.pinkAccent),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: locationData.loading? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ): Text('Ingresa Tu Direccion'),
                  onPressed: () async{
                    setState(() {
                      locationData.loading=true;

                    });

                    await locationData.getCurrentPosition();
                    if(locationData.permissionAlowed==true){
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationData.loading=false;
                      });
                    }else{
                      print('No estas permitido con este permiso');
                      setState(() {
                        locationData.loading=false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      setState(() {
                        auth.screen ='Login';
                      });
                      showBottonSheet(context);
                    },
                    child: RichText(text: const TextSpan(
                        text: '¿Ya eres cliente? ',style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: ' Inicio de Sesion',style: TextStyle(fontWeight: FontWeight.bold)
                          )
                        ]
                    ))
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
