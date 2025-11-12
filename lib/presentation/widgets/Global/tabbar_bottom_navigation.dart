import 'package:flutter/material.dart';
import 'package:jjewellery/helper/helper_functions.dart';

import '../../../utils/color_constant.dart';

class TabbarBottomNavigation extends StatelessWidget {
  const TabbarBottomNavigation({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorConstant.primaryColor,
          ),
          child: TabBar(
            tabAlignment: TabAlignment.fill,
            controller: tabController,
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.line_axis_sharp),
              ),
              Tab(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      
                      bottom: screenHeight > 800
                          ? screenHeight * 0.01
                          : screenHeight * 0.02,
                      right: MediaQuery.of(context).size.width > 410 ? 10 : -20,
                      child: GestureDetector(
                        onTap: () => onQrPressed(context),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              color: ColorConstant.scaffoldColor,
                              width: 5,
                            ),
                            color: ColorConstant.primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.qr_code_2_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                icon: Icon(Icons.calculate_outlined),
              ),
              Tab(
                icon: Icon(Icons.shopping_cart_checkout_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
