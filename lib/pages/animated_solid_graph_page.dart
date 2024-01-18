import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedSolidGraphPage extends StatelessWidget {
  const AnimatedSolidGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1727),
      appBar: AppBar(
        title: const Text(
          'Animated Solid Graph',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: 200,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.white),
          ),
          child: Animate().custom(
            begin: 0,
            end: 1,
            duration: 2.seconds,
            builder: (_, double value, __) {
              return CustomPaint(painter: GraphPainter(value));
            },
          ),
        ),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  GraphPainter(this.percentage);

  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    final Path fullPath = Path();
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const List<Offset> points = <Offset>[
      Offset(50, 50),
      Offset(75, 100),
      Offset(100, 70),
      Offset(125, 130),
      Offset(150, 30),
      Offset(175, 160),
      Offset(200, 90),
      Offset(225, 110),
      Offset(250, 60),
      Offset(275, 140),
      Offset(300, 30),
      Offset(325, 100),
      Offset(350, 60),
      Offset(375, 150),
    ];

    for (int i = 0; i < points.length - 1; i++) {
      fullPath.moveTo(points[i].dx, points[i].dy);
      fullPath.cubicTo(
        (points[i].dx + points[i + 1].dx) / 2,
        points[i].dy,
        (points[i].dx + points[i + 1].dx) / 2,
        points[i + 1].dy,
        points[i + 1].dx,
        points[i + 1].dy,
      );
    }

    final Path path = Path();
    final List<PathMetric> metrics = fullPath.computeMetrics().toList();
    final double fullPathLength = metrics.fold(
        0, (double prev, PathMetric metric) => prev + metric.length);
    final double pathEnd = percentage * fullPathLength;
    const int step = 2;
    double currentPathEnd = 0;

    for (final PathMetric metric in metrics) {
      final double metricStart = currentPathEnd;
      final double metricEnd = currentPathEnd + metric.length;
      while (currentPathEnd != metricEnd) {
        final double upcommingPathEnd = min(currentPathEnd + step, metricEnd);
        final Path segment = metric.extractPath(
          currentPathEnd - metricStart,
          upcommingPathEnd - metricStart,
        );
        path.addPath(segment, Offset.zero);
        currentPathEnd = upcommingPathEnd;
        if (currentPathEnd >= pathEnd) {
          break;
        }
      }
      if (currentPathEnd >= pathEnd) {
        break;
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is GraphPainter && oldDelegate.percentage != percentage;
  }
}
