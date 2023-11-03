import 'dart:async';
import 'dart:io';

import 'package:dulimastore_vendor_app/providers/auth_provider.dart';
import 'package:dulimastore_vendor_app/screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _dialogTextController = TextEditingController();


  late String email;
  late String password;
  late String storeName;
  late String mobile;
  bool _isloading = false;


  Future<String> uploadFile(filepath)async{
    File file =File(filepath);
    FirebaseStorage _storage = FirebaseStorage.instance;

    try{
      await _storage.ref('uploads/storeProfilePic/${_nameTextController.text}').putFile(file);
    }on FirebaseException catch(e){
      print(e.code);
    }
    String downloadURL  = await _storage.ref('uploads/storeProfilePic/${_nameTextController.text}').getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message){
      return ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(content:
            Text(message)));

    }
    return  _isloading ?  CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ) : Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese Nombre de la Tienda.';
                }
                setState(() {
                  _nameTextController.text=value;
                });
                setState(() {
                  storeName=value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.add_business),
                  labelText: 'Nombre de la Tienda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  focusColor: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese Telefono de Contacto';
                }
                setState(() {
                  mobile=value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixText: '+57 ',
                  prefixIcon: const Icon(Icons.phone_android),
                  labelText: 'Telefono de Contacto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  focusColor: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el Email';
                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid){
                  return 'Formato de Email Invalido';
                }
                setState(() {
                  email=value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  focusColor: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa Una Contraseña';
                }
                if(value.length<8){
                  return "Debe tener mínimo 8 caracteres de largo";
                }
                setState(() {
                  password= value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  focusColor: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa La misma Contraseña ';
                }
                if(value.length<8){
                  return "Debe tener mínimo 8 caracteres de largo";
                }
                if(_passwordTextController.text!= _confirmPasswordTextController.text){
                  return 'La Contraseña NO coincide';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  labelText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  focusColor: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 5,
              controller: _addressTextController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor presiona el boton de navegacion.';
                }
                if(_authData.storeLatitude == null){
                  return 'Por favor presiona el boton de navegacion.';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.contact_mail_outlined),
                  labelText: 'Direccion de la Tienda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  suffixIcon: IconButton( icon: Icon(Icons.location_searching),onPressed: (){
                    _addressTextController.text ='Cargando...\n Porfavor Espere.';
                    _authData.getCurrentAddress().then((address){
                      if(address!= null){
                        setState(() {
                          _addressTextController.text= '${_authData.placeName}\n${_authData.storeAddress}';
                        });
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hemos podido localizarte... Intentalo de nuevo')));
                      }
                    });
                  }),
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  focusColor: Theme.of(context).primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              onChanged: (value){
                _dialogTextController.text=value;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.comment),
                  labelText: 'Descriccion de la Tienda',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor)),
                  focusColor: Theme.of(context).primaryColor),
            ),
          ),




          const SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(

                    onPressed: (){
                      if(_authData.isPicAvail== true){
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            _isloading= true;
                          });
                          _authData.registerVendor(email, password).then((credential){
                            if(credential.user?.uid !=null){
                              uploadFile(_authData.image.path).then((url) {
                                if(url != null){
                                  _authData.saveVendorDataToDB(
                                    url: url,
                                    storeName: storeName,
                                    mobile: mobile,
                                    dialog: _dialogTextController.text,
                                  );
                                    setState(() {
                                      _isloading = false;
                                    });

                                    Navigator.pushReplacementNamed(context, HomeScreen.id);

                                }else{
                                  scaffoldMessage('Error en la Subida de la Foto de la Tienda');

                                }
                              });
                            }else{
                              scaffoldMessage(_authData.error);

                            }
                          });
                        }
                      }else{
                        scaffoldMessage('Es necesario tener la foto de la tienda para registerla');
                      }
                    },
                    child: const Text('Registrar')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
