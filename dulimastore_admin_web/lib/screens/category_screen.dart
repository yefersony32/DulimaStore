import 'package:dulimastore_admin_web/services/sidebar.dart';
import 'package:dulimastore_admin_web/widgets/category_card_widget.dart';
import 'package:dulimastore_admin_web/widgets/category_list_widget.dart';
import 'package:dulimastore_admin_web/widgets/category_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  static const String id = 'category-Screen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    SidebarWidget _sideBar = SidebarWidget();

    return AdminScaffold(
      backgroundColor: Colors.pinkAccent[900],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.pinkAccent,
        title: const Text('Ca'
            'tegorias',style: TextStyle(color: Colors.white),),
      ),
      sideBar: _sideBar.SideBarMenus(context,CategoryScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Column(
                children: [
                  Divider(
                    color: Colors.grey,
                    thickness: 3,
                  ),

                  CategoryUploadWidget(),
                ],
              ),

              Divider(
                color: Colors.grey,

                thickness: 3,
              ),
              Divider(
                color: Colors.grey,

                thickness: 3,
              ),
              CategoryList()
            ],
          ),
        ),
      ),
    );
  }
}
