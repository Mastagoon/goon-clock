import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  const ClockView({Key? key}) : super(key: key);

  @override
  ClockViewState createState() => ClockViewState();
}

class ClockViewState extends State<ClockView> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});  // simply calling set state will redraw the canvas.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: Transform.rotate(  // to counteract the default rotation
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var now = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    // calculate needed values
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    // default brush
    var fillBrush = Paint()..color = Color(0xff444974);
    // center circle brush
    var centerFillBrush = Paint()..color = Color(0xffffeaecff);

    var outlineBrush = Paint()
      ..color = Color(0xffffeaecff)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;

    // time hand brushes 
    var secHandBrush = Paint()
      ..color = Colors.orange
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    var minHandBrush = Paint()
      ..shader = RadialGradient(colors: [Color(0xff748ef6), Color(0xff77ddff)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [Color(0xffea74ab), Color(0xffc279fb)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // outline dashes brush
    var dashBrush = Paint()
      ..color = Color(0xffffeaecff)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;


    // draw clock body
    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);

    // craw clock hands
    var secHandX = centerX + 80 * cos(now.second * 6 * pi / 180);
    var secHandY = centerY + 80 * sin(now.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    var minHandX = centerX + 80 * cos(now.minute * 6 * pi / 180);
    var minHandY = centerY + 80 * sin(now.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var hourHandX =
        centerX + 60 * cos((now.hour * 30 + now.minute * 0.5) * pi / 180);
    var hourHandY =
        centerY + 60 * sin((now.hour * 30 + now.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    // center piece 
    canvas.drawCircle(center, 16, centerFillBrush);

    // outer dashes
    var outerCircleRadius = radius;
    var innerCircleRadius = radius - 14;  // where 14 is the length of the individual dash
    for (int i = 0; i < 360; i += 12) {
      // one dash every 12 px
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180); // dash start location x
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180); // dash start location y

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180); // dash end location x
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180); // dash end location y
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush); // draw TODO: this does not need to be redrawn every second.
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
