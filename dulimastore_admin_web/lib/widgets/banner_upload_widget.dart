import 'dart:io';
import 'dart:html' as html;
import 'package:dulimastore_admin_web/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ndialog/ndialog.dart';

class BannerUploadWidget extends StatefulWidget {
  const BannerUploadWidget({Key? key}) : super(key: key);

  @override
  State<BannerUploadWidget> createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {

  FirebaseService _service = FirebaseService();
  var _fileNameTextController = TextEditingController();

  bool _visible = false;
  bool _imageSelected = true;
  late  String _url;

  @override
  Widget build(BuildContext context) {


    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      title: const Text('Cargando...'),
      message: const Text('Espera un momento, por favor.'),
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _fileNameTextController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(19),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Cargar Imagen',
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(19),
                                ),
                                contentPadding:
                                EdgeInsets.only(left: 20)),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        uploadStorage();
                      },
                      child: const Text('Cargar imagen'),
                      style: ButtonStyle(
                        backgroundColor:
                        const MaterialStatePropertyAll<Color>(
                            Colors.grey),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: ElevatedButton(
                        onPressed: () {
                          progressDialog.show();
                          _service.uploadBannerImageToFb('gs://dulimastore-app.appspot.com/$_url').then((downLoadUrl) {
                            if(downLoadUrl != null){
                              progressDialog.dismiss();
                              _service.showMyDialog(
                                  title: 'Nuevo banner publicitario',
                                  message: 'Se ha guardado el banner correctamente',
                                  context: context
                              );
                            }
                          });
                        },
                        child: const Text('Guardar'),
                        style: ButtonStyle(
                          backgroundColor: _imageSelected ?
                          MaterialStatePropertyAll<Color>(
                              Colors.pink) : MaterialStatePropertyAll<Color>(
                              Colors.pinkAccent) ,
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ? false: true,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _visible = true;
                  });
                },
                child: const Text('Agregar nuevo banner'),
                style: ButtonStyle(
                  backgroundColor:
                  const MaterialStatePropertyAll<Color>(
                      Colors.pinkAccent),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }


  void uploadImage({required Function(html.File file) onSelected}) {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file as html.File);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  void uploadStorage() {
    final dateTime = DateTime.now();
    final path = 'bannerImage/$dateTime.png';
    uploadImage(onSelected: (file) {
      if (file!=null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
        });
        FirebaseStorage.instance.refFromURL('gs://dulimastore-app.appspot.com').child(path).putFile(html.File as File);

      }
    });
  }
}
