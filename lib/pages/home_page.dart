import 'package:flutter/material.dart';

import 'animated_adding_to_cart_page.dart';
import 'animated_counting_up_progress_page.dart';
import 'animated_solid_graph_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void navToAnimatedCountingUpProgress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Route<dynamic>>(
        builder: (BuildContext context) =>
            const AnimatedCountingUpProgressPage(),
      ),
    );
  }

  void navToAnimatedSolidGraph(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Route<dynamic>>(
        builder: (BuildContext context) => const AnimatedSolidGraphPage(),
      ),
    );
  }

  void navToAnimatedAddingToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Route<dynamic>>(
        builder: (BuildContext context) => const AnimatedAddingToCartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('H O M E')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () => navToAnimatedCountingUpProgress(context),
                child: const Text('Animated Counting Up Progress'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () => navToAnimatedSolidGraph(context),
                child: const Text('Animated Solid Graph'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () => navToAnimatedAddingToCart(context),
                child: const Text('Animated Adding To Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
