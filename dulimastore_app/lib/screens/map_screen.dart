import 'package:dulimastore_app/providers/auth_provider.dart';
import 'package:dulimastore_app/providers/location_provider.dart';
import 'package:dulimastore_app/screens/home_screen.dart';
import 'package:dulimastore_app/screens/login_screen.dart';
import 'package:dulimastore_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-Screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation = const LatLng(37.421632, 122.084664);
  late GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;

  User? user;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.longitude, locationData.latitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 140),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.4746,
              ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(1.5, 20.9),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locating
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        )
                      : Container(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 20, top: 10),
                    // child: TextButton.icon(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.location_searching,
                    //       color: Theme.of(context).primaryColor,
                    //     ),
                    //     label:
                    //
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_searching,
                          color: Theme.of(context).primaryColor,
                        ),
                        Flexible(
                          child: Text(
                            _locating
                                ? ' Cargando...' : locationData.selectAdresse == null
                                ? ' Cargando...' : locationData.selectAdresse.featureName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //   ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      _locating
                          ? '' :  locationData.selectAdresse == null
                          ? '' :  locationData.selectAdresse.addressLine,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black38),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: AbsorbPointer(
                        absorbing: _locating ? true : false,
                        child: ElevatedButton(
                            onPressed: () {
                              locationData.savePrefs();
                              if (_loggedIn == false) {
                                Navigator.pushNamed(context, LoginScreen.id);
                              } else {
                                setState(() {
                                  _auth.latitude =  locationData.latitude;
                                  _auth.longitude = locationData.longitude;
                                  _auth.address =   locationData.selectAdresse.addressLine;
                                  _auth.location =  locationData.selectAdresse.featureName;
                                });
                                _auth.updateUser(
                                  id: user!.uid,
                                  number: user!.phoneNumber,
                                );
                                Navigator.pushNamed(context, MainScreen.id);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll<Color>(
                                      Colors.pinkAccent),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: Text('Confimar Direccion')),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 140),
            child: Center(
              child: SpinKitPulse(
                color: Colors.black54,
                size: 100.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 140),
            child: Center(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset('assets/images/YouLocation.png'),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
