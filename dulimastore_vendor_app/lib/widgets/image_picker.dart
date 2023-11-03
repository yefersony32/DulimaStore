import 'dart:io';
import 'package:dulimastore_vendor_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageShopPicCard extends StatefulWidget {
  const ImageShopPicCard({Key? key}) : super(key: key);

  @override
  State<ImageShopPicCard> createState() => _ImageShopPicCardState();
}

class _ImageShopPicCardState extends State<ImageShopPicCard> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    final _authUserData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authUserData.getImage().then((image) {
            setState(() {
              _image = image;
            });
            if (image != null) {
              _authUserData.isPicAvail = true;
            }
            print(image.path);
          });
        },
        child: SizedBox(
            height: 150,
            width: 150,
            child: Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _image == null
                      ? const Center(
                      child: Text(
                        'Agrega Imagen de la Tienda',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ))
                      : Image.file(_image!, fit: BoxFit.fill,),
                )
            )

        ),
      ),
    );
  }
}
