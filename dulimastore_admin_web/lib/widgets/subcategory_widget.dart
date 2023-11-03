import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dulimastore_admin_web/services/firebase_services.dart';
import 'package:flutter/material.dart';

class SubCategoryWidget extends StatefulWidget {

  final String categoryName;
  SubCategoryWidget(this.categoryName);

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {

  final FirebaseService _service = FirebaseService();
  final _subCatNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: 350,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<DocumentSnapshot>(
                future: _service.categorys.doc(widget.categoryName).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if (snapshot.hasError) {
                return const Text('Algo salio mal');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if(!snapshot.hasData){
                    return const Center(child: Text('No se añadio Categoria'),);
                  }
                  Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child:  Column(
                          children: [
                            Row(
                              children: [
                                const Text('Categoria Principal : '),
                                Text(widget.categoryName, style: const TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            const Divider(thickness: 5,),

                          ],
                        ),
                      ),

                      Container(
                        child: Expanded(
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index){
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  child: Text('${index+1}'),
                                ),
                                title: Text(data?['subCategory'][index]['name']),
                              );
                            },
                            itemCount: data?['subCategory'] == null ? 0 : data?['subCategory'].length ,
                          ),
                        ),
                      ),

                      Container(
                        child: Column(
                          children: [
                            const Divider(thickness: 5,),

                            Container(
                              color: Colors.pinkAccent[900],
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Agregar una Sub-Categoria',style: TextStyle(fontWeight: FontWeight.bold),  ),
                                  ),
                                  const SizedBox(height: 6,),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: SizedBox(
                                            child: TextField(
                                              controller: _subCatNameTextController,
                                              decoration: const InputDecoration(
                                                hintText: 'Nombre de la nueva categoria',
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.only(left:10),
                                              ),
                                            ),
                                          )
                                      ),
                                      SizedBox(height: 6,),
                                      ElevatedButton(onPressed: () {
                                        if(_subCatNameTextController.text.isEmpty){
                                          return _service.showMyDialog(
                                            title: 'Agregar nueva SubCategoria',
                                            message: 'Necesita tener un nombre la Subcategoria',
                                            context: context
                                          );
                                        }
                                        DocumentReference doc = _service.categorys.doc(widget.categoryName);
                                        doc.update({
                                          'subCategory': FieldValue.arrayUnion([
                                            {
                                              'name' : _subCatNameTextController.text
                                            }
                                            ]
                                          )
                                        });
                                        setState(() {

                                        });
                                        _subCatNameTextController.clear();
                                      },
                                      child: const Text('Guardar',style: TextStyle(color: Colors.white),),
                                        style: ButtonStyle(
                                          backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.pinkAccent),
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(Colors.white),
                                        ),)
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
                return const Center(
                child: CircularProgressIndicator(),
                );
                }

            )
        ),
      ),
    );
  }

}



