import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_app/constants.dart';
import 'package:dulimastore_app/providers/store_provider.dart';
import 'package:dulimastore_app/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class NearByStore extends StatefulWidget {
  const NearByStore({Key? key}) : super(key: key);

  @override
  State<NearByStore> createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {
  StoreServices _storeServices = StoreServices();
  PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(_storeData.userLatitude,
          _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getNearByStore(),
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
            return Stack(children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 30, top: 30, left: 20, right: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text(
                    'Actualmente no estamos atendiendo en su zona, Por favor  intentalo de nuevo con otra localizacion. 😔',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  )),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Image.asset(
                'assets/images/FindLocation.png',
                color: Colors.black12,
              ),
              Positioned(
                right: 10.0,
                top: 80,
                child: Container(
                  width: 100,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Echo por : ',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text('YeffersonC.R : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Anton',
                              letterSpacing: 2,
                              color: Colors.grey)),
                    ],
                  ),
                ),
              )
            ]);
          }
          return Scaffold(
            body: RefreshIndicator(
                child: PaginateFirestore(
                  bottomLoader: const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                    ),
                  ),
                  header: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 20),
                        child: Text(
                          'Todas las tiendas cercanas',
                          style:
                              TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
                        child: Text(
                          'Descubra productos de calidad cerca de usted.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilderType: PaginateBuilderType.listView,
                  itemBuilder: (context, document, index) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 110,
                            child: Card(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  document[index]['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  document[index]['storeName'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                document[index]['dialog'],
                                style: kstoreCardStyle,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 250,
                                child: Text(
                                  document[index]['address'],
                                  overflow: TextOverflow.ellipsis,
                                  style: kstoreCardStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${double.parse(getDistance(['location']))}km',
                                overflow: TextOverflow.ellipsis,
                                style: kstoreCardStyle,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.start,
                                    size: 12,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '3.2',
                                    style: kstoreCardStyle,
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  query: _storeServices.getNearByStorePagination(),
                  listeners: [
                    refreshedChangeListener,
                  ],
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 30, top: 30, left: 20, right: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                              child: Text(
                            'Actualmente no estamos atendiendo en su zona, Por favor  intentalo de nuevo con otra localizacion. 😔',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black54, fontSize: 18),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Image.asset(
                        'assets/images/FindLocation.png',
                        color: Colors.black12,
                      ),
                      Positioned(
                        right: 10.0,
                        top: 80,
                        child: Container(
                          width: 100,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Echo por : ',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text('YeffersonC.R : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Anton',
                                      letterSpacing: 2,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                onRefresh: () async {
                  refreshedChangeListener.refreshed = true;
                }),
          );
        },
      ),
    );
  }
}
