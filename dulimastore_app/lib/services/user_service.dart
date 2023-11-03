

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_app/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';

class UserService{

  String collection = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDataUser(Map<String,dynamic>values)async{
    String id=values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }


  Future<void> updateDataUser(Map<String,dynamic>values)async{
    String id=values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

  Future<DocumentSnapshot>getUserById(String id)async{
   var result = await _firestore.collection(collection).doc(id).get();

      return result;
  }
}