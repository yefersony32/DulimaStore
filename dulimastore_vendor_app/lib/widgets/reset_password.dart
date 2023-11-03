import 'package:dulimastore_vendor_app/providers/auth_provider.dart';
import 'package:dulimastore_vendor_app/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);
  static const String id = 'resetPassword-Screen';

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  late String email;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: const TextSpan(text: '', children: [
                  TextSpan(
                    text: '¿Olvidastes tu contraseña?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                        fontSize: 20),
                  ),
                ])),
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/forgotPassword.png',
                  height: 250,
                ),
                RichText(
                  text: const TextSpan(text: '', children: [
                    TextSpan(
                        text:
                            '\nNo te preocupes, Ingrese tu email registrado \ny le enviaremos un correo electrónico para restablecer su contraseña.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el email';
                    }
                    final bool _isValid =
                        EmailValidator.validate(_emailTextController.text);
                    if (!_isValid) {
                      return 'Formato de Email Invalido';
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });
                                _authData.resetPasswordVendor(email);
                                ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(content: Text('Revisa tu correo electrónico ${_emailTextController.text} para restablecer tu cuenta.')));
                              }
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.id);
                            },
                            child: _loading
                                ? const LinearProgressIndicator()
                                : const Text(
                                    'Reestablecer contraseña.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
