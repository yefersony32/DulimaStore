import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_app/providers/store_provider.dart';
import 'package:dulimastore_app/screens/welcome_screen.dart';
import 'package:dulimastore_app/services/store_service.dart';
import 'package:dulimastore_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class TopPickStoreScreen extends StatefulWidget {
  const TopPickStoreScreen({Key? key}) : super(key: key);

  @override
  State<TopPickStoreScreen> createState() => _TopPickStoreScreenState();
}

class _TopPickStoreScreenState extends State<TopPickStoreScreen> {
  StoreServices _storeServices = StoreServices();





  @override
  Widget build(BuildContext context) {
    final _storeData =Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);
    getDistance(location) {
      var distance = Geolocator.distanceBetween(
          _storeData.userLatitude, _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          List storeDistance = [];
          for (int i = 0; i <= snapshot.data!.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                _storeData.userLatitude,
                _storeData.userLongitude,
                snapshot.data?.docs[i]['location'].latitude,
                snapshot.data?.docs[i]['location'].longitude);

            var distanceInKm = distance / 1000;
            storeDistance.add(distanceInKm);
          }
          storeDistance.sort();
          if (storeDistance[0] > 10) {
            return Container();
          }

          return Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10,top: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.black87,
                          ),
                        ),
                        Text(' Las opciones más cercanas.',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),)
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          if (double.parse(getDistance(document['location'])) <= 10) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Card(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: Image.network(
                                                  document['imageUrl'],
                                                  fit: BoxFit.cover,
                                                )))),
                                    Container(
                                      child: Text(
                                        document['storeName'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${getDistance(document['location'])}km',
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }).toList()),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
