import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  int _dataLength = 1;

  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }

  Future<List<QueryDocumentSnapshot<
      Map<String, dynamic>>>> getSliderImageFromDb() async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(
        'slider').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(_dataLength!=0)
        FutureBuilder(
          future: getSliderImageFromDb(),
          builder: (_, AsyncSnapshot<
              List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapShot) {
            return snapShot.data == null ? Center(child: CircularProgressIndicator(),) :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CarouselSlider.builder(
                  itemCount: snapShot.data!.length,
                  itemBuilder: (BuildContext context, index, int) {
                    DocumentSnapshot<Map<String, dynamic>> sliderImage = snapShot
                        .data![index];
                    Map<String, dynamic>? getImage = sliderImage.data!();
                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),

                            child: Image.network(getImage!['image'], fit: BoxFit.fill,)));
                  }, options: CarouselOptions(
                  aspectRatio: 2.0,

                  viewportFraction: 1,
                  initialPage: 0,
                  autoPlay: true,
                  height: 150,
                  onPageChanged: (int i, carouselPagesChangedReason){
                    setState(() {
                      _index= i;
                    });
                  }
              )),
            );
          },
        ),
        if(_dataLength!=0)
          DotsIndicator(
          dotsCount: _dataLength,
          position: _index,
          decorator: DotsDecorator(
              size: const Size.square(5.0),
              activeSize: const Size(18.0, 5.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Colors.pink
          ),
        ),

      ],
    );
  }
}
