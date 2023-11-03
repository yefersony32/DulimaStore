import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_admin_web/services/firebase_services.dart';
import 'package:dulimastore_admin_web/widgets/category_card_widget.dart';
import 'package:flutter/material.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _service.categorys.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) {
            return const Text('Algo salio mal');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Wrap(
            direction: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
              return CategoryCardWidget(documentSnapshot);
            }).toList()
          );
        }


      ),
    );
  }
}
