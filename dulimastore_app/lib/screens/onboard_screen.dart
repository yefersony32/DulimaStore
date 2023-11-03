import 'package:dulimastore_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;


List<Widget> _pages =[
  const Column(
    children: [
      Expanded(child: Image(image: AssetImage('assets/images/LocationDelivery.png'),)),
      Text('Ingresa Tu Direccion de Entrega',
        style: constantTextStyle, textAlign: TextAlign.center,)
    ],
  ),
  const Column(
    children: [
      Expanded(child: Image(image: AssetImage('assets/images/Order.png'),)),
      Text('Compra ahora en Dulima Store',
          style: constantTextStyle, textAlign: TextAlign.center)
    ],
  ),
  const Column(
    children: [
      Expanded(child: Image(image: AssetImage('assets/images/Delivery.png'),)),
      Text('Su entrega Sera Hoy Mismo',
          style: constantTextStyle, textAlign: TextAlign.center)
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index){
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage,
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Colors.pink
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}

