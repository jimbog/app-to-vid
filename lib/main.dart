import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    startRecording();
    Timer(Duration(seconds: 4), stopRecording);
  }

  startRecording() async {
    try {
      await platform.invokeMethod('startRecording');
    } on PlatformException catch (e) {
      // Handle error
    }
  }

  stopRecording() async {
    try {
      await platform.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bouncing Ball'),
        ),
        body: BouncingBall(),
      ),
    );
  }
}

class BouncingBall extends StatefulWidget {
  @override
  _BouncingBallState createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall> {
  double ballX = 0;
  double ballY = 0;
  double ballSize = 50;
  double speedX = 2;
  double speedY = 2;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        ballX += speedX;
        ballY += speedY;

        if (ballX + ballSize > MediaQuery.of(context).size.width || ballX < 0) {
          speedX = -speedX;
        }
        if (ballY + ballSize > MediaQuery.of(context).size.height ||
            ballY < 0) {
          speedY = -speedY;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BallPainter(ballX, ballY, ballSize),
      child: Container(),
    );
  }
}

class BallPainter extends CustomPainter {
  final double ballX;
  final double ballY;
  final double ballSize;

  BallPainter(this.ballX, this.ballY, this.ballSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(ballX, ballY), ballSize, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

const platform = MethodChannel('com.example.myapp/screenrecording');

startRecording() async {
  try {
    await platform.invokeMethod('startRecording');
  } on PlatformException catch (e) {
    // Handle error
  }
}

stopRecording() async {
  try {
    await platform.invokeMethod('stopRecording');
  } on PlatformException catch (e) {
    // Handle error
  }
}
