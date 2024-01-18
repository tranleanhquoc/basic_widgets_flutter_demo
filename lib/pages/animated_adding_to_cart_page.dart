import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

final Duration productAnimDuration = 1.seconds;

class AnimatedAddingToCartPage extends StatefulWidget {
  const AnimatedAddingToCartPage({super.key});

  @override
  State<AnimatedAddingToCartPage> createState() =>
      _AnimatedAddingToCartPageState();
}

class _AnimatedAddingToCartPageState extends State<AnimatedAddingToCartPage>
    with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this);
  late final AnimationController cartController =
      AnimationController(vsync: this);
  late final AddToCartAnimationManager manager =
      AddToCartAnimationManager(context, controller);

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade200,
      appBar: AppBar(
        title: const Text(
          'Animated Adding To Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: CartButton(key: manager.cartKey)
          .animate(
            autoPlay: false,
            controller: cartController,
            onComplete: (AnimationController controller) {
              controller.reset();
            },
          )
          .moveY(begin: 0, end: -10, delay: 200.ms, duration: 500.ms)
          .shake(),
      body: Stack(
        children: <Widget>[
          ProductList(manager: manager),
          ListenableBuilder(
            listenable: manager.productSize,
            builder: (BuildContext context, _) {
              return SizedBox(
                width: manager.productSize.value.width,
                height: manager.productSize.value.height,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.indigo.shade400,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        offset: Offset(0, 7),
                        color: Colors.black26,
                        blurRadius: 29,
                      )
                    ],
                  ),
                )
                    .animate(
                      autoPlay: false,
                      controller: manager.controller,
                    )
                    .scale(
                      duration: productAnimDuration * 0.8,
                      delay: productAnimDuration * 0.2,
                      begin: const Offset(1, 1),
                      end: Offset.zero,
                      alignment: Alignment.bottomRight,
                    ),
              )
                  .animate(
                    autoPlay: false,
                    controller: manager.controller,
                    onComplete: (AnimationController controller) {
                      controller.reset();
                      manager.reset();
                      cartController.forward();
                    },
                  )
                  .followPath(
                    duration: productAnimDuration,
                    path: manager.path,
                    curve: Curves.easeInOutCubic,
                  );
            },
          )
        ],
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.manager});

  final AddToCartAnimationManager manager;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.8,
      padding: const EdgeInsets.all(16),
      children: List<Widget>.generate(
        20,
        (int index) {
          // Item container
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Product image placeholder
                Expanded(
                  flex: 3,
                  child: Container(
                    key: manager.productKeys[index],
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.indigo.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Add-to-cart button
                Expanded(
                  child: FilledButton(
                    onPressed: () => manager.runAnimation(index),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.indigo.shade400,
                      foregroundColor: Colors.indigo.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add to cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      elevation: 0,
      backgroundColor: Colors.yellow.shade600,
      foregroundColor: Colors.indigo,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.shopping_cart),
    );
  }
}

class AddToCartAnimationManager {
  AddToCartAnimationManager(this.context, this.controller);

  final BuildContext context;
  final AnimationController controller;

  final List<GlobalKey> productKeys =
      List<GlobalKey>.generate(20, (int index) => GlobalKey());
  final GlobalKey cartKey = GlobalKey();
  final ValueNotifier<Size> productSize = ValueNotifier<Size>(Size.zero);
  Offset productPosition = Offset.zero;
  Path path = Path();

  void dispose() {
    productSize.dispose();
  }

  void reset() {
    productSize.value = Size.zero;
    productPosition = Offset.zero;
    path = Path();
  }

  void runAnimation(int index) {
    // Cancel previous animation if it's exist
    if (controller.isAnimating) {
      controller.reset();
      reset();
    }
    // Get context of product item
    final BuildContext productContext = productKeys[index].currentContext!;
    // Get position of cart button
    final Offset cartPosition =
        (cartKey.currentContext!.findRenderObject() as RenderBox)
            .localToGlobal(Offset.zero);
    // Get bottom right position of cart button
    final Offset cartBottomRight =
        cartKey.currentContext!.size!.bottomRight(cartPosition);
    // Get position of product image
    productPosition = (productContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
    // Get safe area padding
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    final double safeAreaTop = padding.top + kToolbarHeight;
    final double safeAreaLeft = padding.left;
    // Get top left position of product image with safe area
    final double productTopX = productPosition.dx - safeAreaLeft;
    final double productTopY = productPosition.dy - safeAreaTop;
    // Get size of product image
    productSize.value = productContext.size!;
    // Get top left position of cart button with safe area
    final double cartTopX =
        cartBottomRight.dx - productSize.value.width - 5 - safeAreaLeft;
    final double cartTopY =
        cartBottomRight.dy - productSize.value.height - 5 - safeAreaTop;
    // Create Path object
    path = Path()
      ..moveTo(productTopX, productTopY)
      ..relativeLineTo(-20, -20)
      ..lineTo(cartTopX, cartTopY);
    // Trigger animation
    controller.forward();
  }
}
