import 'package:dulimastore_admin_web/screens/admin_users_screen.dart';
import 'package:dulimastore_admin_web/screens/category_screen.dart';
import 'package:dulimastore_admin_web/screens/home_screen.dart';
import 'package:dulimastore_admin_web/screens/login_screen.dart';
import 'package:dulimastore_admin_web/screens/manager_banner.dart';
import 'package:dulimastore_admin_web/screens/notification_screen.dart';
import 'package:dulimastore_admin_web/screens/orders_screen.dart';
import 'package:dulimastore_admin_web/screens/settings_screen.dart';
import 'package:dulimastore_admin_web/screens/ventor_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';


class SidebarWidget{
  SideBarMenus(context,selectedRoute){
     return SideBar(
       borderColor: Color(0xff2b2b2b),
       iconColor: Colors.white,
       textStyle: TextStyle(color: Colors.white),
       backgroundColor: Color(0xff2b2b2b),
       activeTextStyle:TextStyle(color: Colors.white),
       activeIconColor:  Colors.white,
       activeBackgroundColor:  Colors.pinkAccent,
       items: const [
         AdminMenuItem(
           title: 'Dashboard',
           route: HomeScreen.id,
           icon: Icons.dashboard,
         ),
         AdminMenuItem(
             title: 'Banners',
             icon: CupertinoIcons.photo_on_rectangle,
             route: BannerScreen.id
         ),
         AdminMenuItem(
             title: 'Vendedores',
             icon: CupertinoIcons.person_2_alt,
             route: VendorScreen.id
         ),
         AdminMenuItem(
             title: 'Categorias',
             icon: Icons.category_rounded,
             route: CategoryScreen.id

         ),
         AdminMenuItem(
           title: 'Ordenes-Pedidos',
           icon: Icons.delivery_dining,
           route: OrdersScreen.id,
         ),
         AdminMenuItem(
           title: 'Enviar Notificaciones',
           icon: Icons.notification_add,
           route: NotificationScreen.id,
         ),
         AdminMenuItem(
           title: 'Administrar Usuarios',
           icon: Icons.supervised_user_circle,
           route: AdminUsersScreen.id,
         ),
         AdminMenuItem(
           title: 'Configuracion',
           icon: Icons.settings,
           route: SettingsScreen.id,
         ),
         AdminMenuItem(
           title: 'Salir',
           icon: Icons.exit_to_app,
           route: LoginScreen.id,
         ),
         AdminMenuItem(
           title: 'cc',
           icon: Icons.settings,
           children: [
             AdminMenuItem(
               title: 'Administracion de Usuarios',
               route: '/secondLevelItem1',
             ),
             AdminMenuItem(
               title: 'Ordenes',
               route: '/secondLevelItem2',
             ),
             AdminMenuItem(
               title: 'Third Level',
               children: [
                 AdminMenuItem(
                   title: 'Third Level Item 1',
                   route: '/thirdLevelItem1',
                 ),
                 AdminMenuItem(
                   title: 'Third Level Item 2',
                   route: '/thirdLevelItem2',
                 ),
               ],
             ),
           ],
         ),
       ],
       selectedRoute: selectedRoute,
       onSelected: (item) {
         if (item.route != null) {
           Navigator.of(context).pushNamed(item.route!);
         }
       },
       header: Container(
         height: 50,
         width: double.infinity,
         color: const Color(0xff303134),
         child: const Center(
           child: Text(
             'Menu',
             style: TextStyle(
               letterSpacing: 2,
               color: Colors.white,
               fontWeight: FontWeight.bold,
               fontSize: 20
             ),
           ),
         ),
       ),
       footer: Container(
         height: 50,
         width: double.infinity,
         color: Colors.black,
         child:  Center(
             child: Image.asset('assets/images/DulimaStore.png',height: 30,)
         ),
       ),
     );
  }
}