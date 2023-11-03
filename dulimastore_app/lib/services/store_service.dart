

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{
  getTopPickStore(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified',isEqualTo: true)
        .where('isTopPicked',isEqualTo: true)
        .where('storeOpen',isEqualTo: true)
        .orderBy('storeName').snapshots();
  }

  getNearByStore(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified',isEqualTo: true)
        .orderBy('storeName').snapshots();
  }

  getNearByStorePagination(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified',isEqualTo: true)
        .orderBy('storeName');
  }
}