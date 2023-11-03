import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_admin_web/constants.dart';
import 'package:dulimastore_admin_web/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorDetailWidget extends StatefulWidget {
  final String uid;

  VendorDetailWidget(this.uid);

  @override
  State<VendorDetailWidget> createState() => _VendorDetailWidgetState();
}

class _VendorDetailWidgetState extends State<VendorDetailWidget> {
  final FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _service.vendors.doc(widget.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo salio mal');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width *.4,
                    child: ListView(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  snapshot.data?['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?['storeName'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 25),
                                ),
                                Text(snapshot.data?['dialog'])
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 4,
                          color: Colors.grey,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: const Text(
                                      'Telefono de Contacto',
                                      style: KvendorDetailsTextStyle,
                                    ),
                                  )),
                                  Container(
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':',style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    child: Text(snapshot.data?['mobile']),
                                  )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        child: const Text(
                                          'Correo Electronico',
                                          style: KvendorDetailsTextStyle,
                                        ),
                                      )),
                                  Container(
                                    child: const Padding(
                                      padding:
                                      EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':',style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        child: Text(snapshot.data?['email']),
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        child: const Text(
                                          'Direccion',
                                          style: KvendorDetailsTextStyle,
                                        ),
                                      )),
                                  Container(
                                    child: const Padding(
                                      padding:
                                      EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':',style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        child: Text(snapshot.data?['address']),
                                      )),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Divider(
                                thickness: 5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        child: const Text(
                                          'Elegido para aparecer cerca',
                                          style: KvendorDetailsTextStyle,
                                        ),
                                      )),
                                  Container(
                                    child: const Padding(
                                      padding:
                                      EdgeInsets.only(left: 10, right: 10),
                                      child: Text(':'),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        child: snapshot.data?['isTopPicked']
                                            ? const Chip(
                                        backgroundColor: Colors.green,
                                        label: Row(
                                        children: [
                                          Icon(Icons.check),
                                          Text('Elegidos')
                                        ],
                                      ),):Container(),),

                                  )],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Divider(thickness: 5,),
                            ),
                            Wrap(
                              children: [
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Card(
                                    color: Colors.amber.withOpacity(.9),
                                    elevation: 4,
                                    child:  const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(CupertinoIcons.money_dollar,
                                              size: 50,
                                              color: Colors.black,),
                                            SizedBox(child: Flexible(child: Text('Total de Ventas'))),
                                            SizedBox(child: Flexible(child: Text('12.000')))

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Card(
                                    color: Colors.amber.withOpacity(.9),
                                    elevation: 4,
                                    child:  const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.delivery_dining,
                                              size: 50,
                                              color: Colors.black,),
                                            Center(child: Text('Ordenes activas')),
                                            Center(child: Text('12.000'))

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Card(
                                    color: Colors.amber.withOpacity(.9),
                                    elevation: 4,
                                    child:  const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.shopping_bag,
                                              size: 50,
                                              color: Colors.black,),
                                            Center(child: Text('Ordenes')),
                                            Center(child: Text('12'))

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Card(
                                    color: Colors.amber.withOpacity(.9),
                                    elevation: 4,
                                    child:  const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.grain,
                                              size: 50,
                                              color: Colors.black,),
                                            Center(child: Text('Productos')),
                                            Center(child: Text('12.000'))

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: Card(
                                    color: Colors.amber.withOpacity(.9),
                                    elevation: 4,
                                    child:  const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.view_list,
                                              size: 50,
                                              color: Colors.black,),
                                            Center(child: Text('Documentos')),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            )


                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: snapshot.data?['accVerified'] ? const Chip(
                        backgroundColor: Colors.green,
                        label: Row(
                          children: [
                            Icon(Icons.check),
                            Text('Activo')
                          ],
                        ),):const Chip(
                        backgroundColor: Colors.red,
                        label: Row(
                          children: [
                            Icon(Icons.remove_circle),
                            Text('Inactvo')
                          ],
                        ),),)
                ],
              ),
            ),
          );
        });
  }
}
