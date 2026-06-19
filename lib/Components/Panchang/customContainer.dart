import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double topWidth = screenWidth * 0.5; // Adjust this to match your design
    double bottomWidth = screenWidth * 0.8; // Bottom width should be larger
    double containerHeight = 80; // Adjust as needed

    return ClipPath(
      clipper: CustomShapeClipper(topWidth, bottomWidth),
      child: Container(
        width: bottomWidth,
        height: containerHeight,
        color: Colors.green, // Match the color in your image
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  final double topWidth;
  final double bottomWidth;

  CustomShapeClipper(this.topWidth, this.bottomWidth);

  @override
  Path getClip(Size size) {
    double height = size.height;
    double radius = 30; // Adjust radius for smooth curve

    Path path = Path();
    path.moveTo((bottomWidth - topWidth) / 3 + radius, 0); // Left curve start
    path.lineTo((bottomWidth + topWidth) / 3 - radius, 0); // Right curve start
    path.quadraticBezierTo((bottomWidth + topWidth) / 3, 0, (bottomWidth + topWidth) / 2, radius);
    path.lineTo(bottomWidth, height);
    path.lineTo(0, height);
    path.lineTo((bottomWidth - topWidth) / 2, radius);
    path.quadraticBezierTo((bottomWidth - topWidth) / 2, 0, (bottomWidth - topWidth) / 2 + radius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}