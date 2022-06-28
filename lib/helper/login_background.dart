import 'package:flutter/material.dart';

class LoginBackground extends CustomPainter{
  //클래스 생성자 (블루프린트.. 같은 것)
  LoginBackground({required this.isJoin});

  final bool isJoin;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = isJoin?Colors.red:Colors.blue;
    canvas.drawCircle(Offset(size.width*0.5,size.height*0.2), size.height*.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}