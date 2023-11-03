import 'dart:html';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_admin_web/services/firebase_services.dart';
import 'package:dulimastore_admin_web/widgets/vendor_details_widget.dart';
import 'package:flutter/material.dart';

class VendorWidget extends StatefulWidget {
  const VendorWidget({super.key});

  @override
  State<VendorWidget> createState() => _VendorWidgetState();
}

class _VendorWidgetState extends State<VendorWidget> {
  final FirebaseService _service = FirebaseService();

  int tag = 0;
  List<String> options = [
    'Todos los vendedores',
    'Activos',
    'Inactivos',
    'Elegidos',
    'Calificacion'
  ];

  bool? topPicked;
  bool? active;

  filter(val) {
    if (val == 1) {
      setState(() {
        active = true;
      });
    }
    if (val == 2) {
      setState(() {
        active = false;
      });
    }
    if (val == 3) {
      setState(() {
        topPicked = true;
      });
    }
    if (val == 0) {
      setState(() {
        topPicked = null;
        active = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
            });
            filter(val);
          },
          choiceStyle: C2ChipStyle.outlined(
            selectedStyle: const C2ChipStyle(
              backgroundColor: Colors.red,
              foregroundStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            borderRadius: BorderRadius.circular(20),

          ),
          choiceItems: C2Choice.listFrom<int, String>(
            style: (i, v) {
              return const C2ChipStyle(overlayColor: Colors.pinkAccent);
            },
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
        const Divider(
          thickness: 4,
          color: Colors.grey,
        ),
        StreamBuilder(
            stream: _service.vendors
                .where('isTopPicked', isEqualTo: topPicked)
                .where('accVerified', isEqualTo: active)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Algo salio mal');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    showBottomBorder: true,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.pink[100]),
                    columns: const <DataColumn>[
                      DataColumn(
                          label: Text(
                        'Estado',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Nombre de la tienda',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Telefono',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Correo Electronico',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Calificacion',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Elejido',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Ventas Totales',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Detalles',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                    ],
                    rows: _vendorsDetailRows(
                            snapshot.data as QuerySnapshot, _service)
                        .toList()),
              );
            }),
      ],
    );
  }

  Iterable<DataRow> _vendorsDetailRows(
      QuerySnapshot snapshot, FirebaseService services) {
    Iterable<DataRow> newList =
        snapshot.docs.map((DocumentSnapshot documentSnapshot) {
      final isEven = documentSnapshot.id.hashCode % 2 == 0;
      final color = isEven ? const Color(0xffcccbcb) : const Color(0xffe7e7e7);
      final materialStateProperty = MaterialStateProperty.all(color);
      return DataRow(
        cells: [
          DataCell(IconButton(
              onPressed: () {
                services.updateVendorState(
                    id: documentSnapshot['uid'],
                    state: documentSnapshot['accVerified']);
              },
              icon: documentSnapshot['accVerified']
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ))),
          DataCell(Text(documentSnapshot['storeName'])),
          DataCell(Text(documentSnapshot['mobile'])),
          DataCell(Text(documentSnapshot['email'])),
          const DataCell(Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text('3.5')
            ],
          )),
          DataCell(IconButton(
              onPressed: () {
                services.updateVendorState(
                    id: documentSnapshot['uid'],
                    state: documentSnapshot['isTopPicked']);
              },
              icon: documentSnapshot['isTopPicked']
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ))),
          const DataCell(Text('200.00')),
          DataCell(IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VendorDetailWidget(documentSnapshot['uid']);
                    });
              },
              icon: const Icon(
                Icons.remove_red_eye_outlined,
                color: Color(0xff2b2b2b),
              )))
        ],
        color: materialStateProperty,
      );
    });
    return newList;
  }
}
