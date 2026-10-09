import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Samarpana/config.dart';


class DashBordPage extends StatefulWidget {
  @override
  _DashBordPageState createState() => _DashBordPageState();
}

class _DashBordPageState extends State<DashBordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    final List<String> imageUrls = [
      Config.dashboardImage + '/home.jpg',
      Config.dashboardImage + '/Kissan2itchen.jpg',
      Config.dashboardImage + '/FreshFarmBanner.jpg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: imageUrls.map((imageUrl) {
        return FittedBox(
          fit: BoxFit.fill,
          child: Image.network(imageUrl),
        );
      }).toList(),
    );
  }
}
