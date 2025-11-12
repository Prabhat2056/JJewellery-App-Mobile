import 'package:flutter/material.dart';

import '../../utils/color_constant.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.slowMiddle,
    );

    // Start the animation and repeat it
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: ColorConstant.scaffoldColor),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // Apply animation value to height and width
              double size = 100 + (200 * animation.value); // Bounce range
              return Center(
                child: SizedBox(
                  height: size,
                  width: size,
                  child: Image.asset(
                    'assets/images/playstore.png',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
