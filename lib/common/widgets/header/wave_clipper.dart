import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height-30);

    // var firstStart = Offset(size.width / 5, size.height);
    // var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    // path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    // var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105);
    // var secondEnd = Offset(size.width, size.height - 10);
    // path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.quadraticBezierTo(30, size.height , size.width/6, size.height-30);
    path.quadraticBezierTo(size.width/3, size.height/2, size.width/1.5, size.height-60);
    path.quadraticBezierTo(size.width/1.2, size.height-20, size.width, size.height/2);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
