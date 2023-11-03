import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_admin_web/widgets/subcategory_widget.dart';
import 'package:flutter/material.dart';

class CategoryCardWidget extends StatelessWidget {

  final DocumentSnapshot documentSnapshot;
  CategoryCardWidget(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: (){
        showDialog(context: context, builder: (BuildContext context ){
          return SubCategoryWidget(documentSnapshot['name']);
        });
      },
      child: SizedBox(
        height: 130,
        width: 130,
        child: Card(
          color: Colors.pinkAccent.withOpacity(.9),
          elevation: 4,
          child:  Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Image.network(documentSnapshot['image']),
                  ),
                  FittedBox( fit: BoxFit.contain,child: Flexible( child: Text(documentSnapshot['name'])))

                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
