import 'package:flutter/material.dart';

class LayoutPage extends StatelessWidget {
  final double? width;
  final double? height;
  final ImageProvider backgroundImage;

  LayoutPage({this.width, this.height, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(backgroundImage);
      },
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 4,
              offset: Offset(4, 4),
            )
          ],
          image: DecorationImage(
            image: backgroundImage,
            fit: BoxFit.contain,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 1,
            color: Color(0xffCDCDCD),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                  color: Color(0xff41D5E2),
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
