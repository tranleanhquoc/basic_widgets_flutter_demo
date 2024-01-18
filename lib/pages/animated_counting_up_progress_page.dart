import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedCountingUpProgressPage extends StatelessWidget {
  const AnimatedCountingUpProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade300,
      appBar: AppBar(
        title: const Text(
          'Animated Counting Up Progress',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
          ),
          child: Animate().custom(
            begin: 0,
            end: 100,
            duration: 1.seconds,
            builder: (_, double value, __) {
              return Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      '${value.round()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: ProgressPainter(value.round()),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  ProgressPainter(this.percentage);

  final int percentage;

  @override
  void paint(Canvas canvas, Size size) {
    assert(size.width == size.height, 'Width must be equal to height');
    canvas.drawArc(
      Offset.zero & size,
      -pi / 2,
      -percentage / 100 * (2 * pi),
      false,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ProgressPainter &&
        oldDelegate.percentage != percentage;
  }
}
