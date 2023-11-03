
import 'package:flutter/cupertino.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with  ChangeNotifier{

  double latitude =37.421632;
  double longitude=122.084664;
  bool permissionAlowed = false;
  var selectAdresse;
  bool loading = false;

  Future<void> getCurrentPosition()async{

    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null){
      latitude = position.latitude;
      longitude = position.longitude;

      final coordinates = new Coordinates(this.latitude, this.longitude);
      final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selectAdresse = addresses.first;
      print("${selectAdresse.featureName} : ${selectAdresse.addressLine}");

      permissionAlowed = true;
      notifyListeners();
    }else{
      print('No estas Permitido con este permiso');
    }
  }


  void onCameraMove(CameraPosition cameraPosition)async{
    this.latitude=cameraPosition.target.latitude;
    this.longitude=cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void>getMoveCamera()async{
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectAdresse = addresses.first;
    notifyListeners();
    print("${selectAdresse.featureName} : ${selectAdresse.addressLine}");

  }

  Future<void>savePrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', latitude);
    prefs.setDouble('longitude', longitude);
    prefs.setString('address', selectAdresse.addressLine);
    prefs.setString('location', selectAdresse.featureName);



  }

}