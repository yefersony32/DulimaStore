import 'package:dulimastore_admin_web/services/sidebar.dart';
import 'package:dulimastore_admin_web/widgets/vendor_filter_widget.dart';
import 'package:dulimastore_admin_web/widgets/vendor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class VendorScreen extends StatelessWidget {
  static const String id = 'vendors-Screen';
  SidebarWidget _sideBar = SidebarWidget();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.pinkAccent,
        title: const Text(
          'Administrar las actividades de los vendedores',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBar.SideBarMenus(context, VendorScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /*Text(
                'Vendedores',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Administrar las actividades de los vendedores.'),*/
              Divider(
                thickness: 4,
                color: Colors.grey,
              ),
              VendorWidget(),
              Divider(
                thickness: 4,
                color: Colors.grey,
              ),



            ],
          ),
        ),
      ),
    );
  }
}
