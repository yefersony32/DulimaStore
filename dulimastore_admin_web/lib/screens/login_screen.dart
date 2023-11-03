import 'package:dulimastore_admin_web/screens/home_screen.dart';
import 'package:dulimastore_admin_web/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-Screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseService _service = FirebaseService();

  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      title: const Text('Cargando...'),
      message: const Text('Espera un momento, por favor.'),
    );

    _login({username, password})async{
      progressDialog.show();
      _service.getAdminCredentials(username).then((value) async {
        if(value.exists){
          if(value['username'] == username){
            if(value['password'] == password){
              try{
                UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
                if(userCredential!=null){
                  progressDialog.dismiss();
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }

              }catch(e){
                progressDialog.dismiss();
                _service.showMyDialog(
                    context: context,
                    title: 'Inicio de sesion',
                    message: '${e.toString()}'
                );
              }
              return;
            }

            else{progressDialog.dismiss();
            _service.showMyDialog(
              context: context,
              title: 'Contrasela incorrecta',
              message: 'La contraseña ingresada no es correcta,\n Por favor intentelo de nuevo.',
            );}
            return;
          }
          else{
            progressDialog.dismiss();
            _service.showMyDialog(
              context: context,
                title: 'Usuario No valido',
                message: 'Verifica el usuario ingresado ya que no es valido,\n Por favor intentelo de nuevo.'
            );
          }
        }else{
          progressDialog.dismiss();
          _service.showMyDialog(
            context: context,
              title: 'Usuario No valido',
              message: 'Verifica el usuario ingresado ya que no es valido,\n Por favor intentelo de nuevo.'
          );
        }

      });
    }


    return Scaffold(
        // appBar: AppBar(
        //
        //   backgroundColor: Colors.pinkAccent,
        //   elevation: 0.0,
        //   title: Text(
        //     widget.title,style: TextStyle(color: Colors.white),
        //
        //   ),
        //
        // ),
        body: FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Conexion Fallida'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                child: Image.asset('assets/images/Example1.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.pinkAccent, Colors.white ],
                        stops: [0.0, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment(0.0, 0.0))),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: 350,
                      height: 300,
                      child: Card(
                        elevation: 6,
                        // shape: Border.all(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Dulima Store Admin',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: _usernameTextController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ingrese el nombre de usuario';
                                          }

                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          prefixIcon:
                                              const Icon(Icons.person_2_outlined),
                                          labelText: 'Usuario de Administracion',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: const BorderSide(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: _passwordTextController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ingrese la contraseña';
                                          }
                                          if (value.length < 8) {
                                            return "Debe tener mínimo 8 caracteres de largo";
                                          }

                                          return null;
                                        },
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          prefixIcon:
                                              const Icon(Icons.vpn_key_outlined),
                                          labelText: 'Contraseña de Administracion',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: const BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                const MaterialStatePropertyAll<
                                                    Color>(Colors.pinkAccent),
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Colors.white),
                                          ),
                                          onPressed: () async{
                                            if (_formkey.currentState!.validate()) {
                                              _login(
                                                  username: _usernameTextController.text,
                                                  password: _passwordTextController.text);
                                            }
                                          },
                                          child: const Text(
                                            'Iniciar Sesion',
                                            style: TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }

}
