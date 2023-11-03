import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_admin_web/services/firebase_services.dart';
import 'package:flutter/material.dart';


class BannerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    FirebaseService _services =FirebaseService();

    return StreamBuilder<QuerySnapshot>(
      stream: _services.banners.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          height: 470,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child:Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 470,
                        child: Card(
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                              child: Image.network(document['image'],width: 850,fit: BoxFit.fill,)),
                        ),
                      ),
                      Positioned(
                          top:10,
                          right: 10 ,
                          child: CircleAvatar(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red,),
                              onPressed: () {
                                _services.confirmDelete(
                                  context: context,
                                  title: 'Eliminar banner publicitario',
                                  message: '¿Seguro de eliminar el banner?',
                                  id: document.id
                                );
                              },

                            ),
                          ))
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

