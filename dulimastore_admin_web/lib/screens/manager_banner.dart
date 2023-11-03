
import 'package:dulimastore_admin_web/services/sidebar.dart';
import 'package:dulimastore_admin_web/widgets/banner_upload_widget.dart';
import 'package:dulimastore_admin_web/widgets/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';




class BannerScreen extends StatelessWidget {
  static const String id = 'banner-Screen';

  SidebarWidget _sideBar = SidebarWidget();


  @override
  Widget build(BuildContext context) {


    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'Agregar o Eliminar banners de publicidad',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBar.SideBarMenus(context, BannerScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
/*
              const Text('Agregar o Eliminar banners de publicidad'),
*/
              const Column(
                children: [
                  Divider(
                    color: Colors.grey,
                    thickness: 3,
                  ),

                  BannerUploadWidget(),
                ],
              ),

              const Divider(
                color: Colors.grey,

                thickness: 3,
              ),
              BannerWidget(),
              const Divider(
                color: Colors.grey,

                thickness: 3,
              ),

            ],
          ),
        ),
      ),
    );
  }




}
