import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    required this.image,
  });

  final String image;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.black,
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.grey.withOpacity(0.3), BlendMode.dstATop),
              image: new AssetImage(image),
            ),
          ),
        ),
      ),
    ]);
  }
}
