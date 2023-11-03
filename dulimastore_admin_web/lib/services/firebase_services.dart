

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseService{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
  CollectionReference categorys = FirebaseFirestore.instance.collection('categorys');

  FirebaseStorage storages = FirebaseStorage.instance;

  Future<DocumentSnapshot>getAdminCredentials(id){
    var result = FirebaseFirestore.instance.collection('admin').doc(id).get();
    return result;
  }

  Future<String>uploadBannerImageToFb(url)async{
    String downloadUrl = await storages.ref(url).getDownloadURL();
    if(downloadUrl != null){
      firestore.collection('slider').add({
        'image' : downloadUrl,
      });
    }
    return downloadUrl;

  }

  deleteBannerImageFromFb(id)async{
    firestore.collection('slider').doc(id).delete();
  }


  updateVendorState({id, state})async{
    vendors.doc(id).update({
      'accVerified' :state ? false : true
    });
  }



  Future<String>uploadCategoryImageToFb(url, cateName)async{
    String downloadUrl = await storages.ref(url).getDownloadURL();
    if(downloadUrl != null){
      categorys.doc(cateName).set({
        'image' : downloadUrl,
        'name' : cateName
      });
    }
    return downloadUrl;

  }


  Future<void> confirmDelete({title, message, context, id }) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.pinkAccent),
                  )),
              TextButton(
                  onPressed: () {
                    deleteBannerImageFromFb(id);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.pinkAccent),
                  ))
            ],
          );
        });
  }


   showMyDialog({title, message, context}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.pinkAccent),
                  )),
            ],
          );
        });
  }



}