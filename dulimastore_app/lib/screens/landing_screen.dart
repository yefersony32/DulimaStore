import 'package:dulimastore_app/providers/location_provider.dart';
import 'package:dulimastore_app/screens/map_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);
  static const String id = 'landing-Screen';

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  late bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Dirección de entrega no establecida',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Actualice su ubicación de entrega para encontrar las tiendas más cercanas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const LinearProgressIndicator(),
            Container(
                width: 600,
                child: Image.asset(
                  'assets/images/FindLocation.png',
                  fit: BoxFit.fill,
                )),
            _loading ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      await _locationProvider.getCurrentPosition();
                      if (_locationProvider.permissionAlowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(const Duration(seconds: 2), () {
                          if (_locationProvider.permissionAlowed == false) {
                            print('No tiene permiso');
                            setState(() async{
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Por favor activa los permiso de ubicacion para encontrar las tiendas más cercanas para usted')));
                          }
                        });
                      }
                    },
                    child: Text(
                      'Ingresa tu localizacion',
                      style: const TextStyle(color: Colors.black),
                    )),
          ],
         ),
      ),
    );
  }
}
