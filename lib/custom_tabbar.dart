import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class CustomTabBar extends StatelessWidget {
  final MotionTabBarController tabController;

  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    // 공통 속성을 변수로 추출
    const Color iconColor = Colors.grey;
    const Color selectedColor = Color(0xff5500AA);
    const double iconSize = 35.0;
    const double tabHeight = 55;

    return MotionTabBar(
      controller: tabController,
      initialSelectedTab: "Home",
      labels: const ["Study Room", "Home", "My Page"],
      icons: const [
        Icons.psychology_alt_outlined,
        Icons.rocket_launch_rounded,
        Icons.person_outline,
      ],
      badges: const [null, null, null],
      tabIconColor: iconColor,
      tabSelectedColor: selectedColor,
      tabIconSize: iconSize,
      tabIconSelectedSize: iconSize,
      tabBarColor: Colors.white,
      tabSize: 50,
      tabBarHeight: tabHeight,
      textStyle: const TextStyle(
        fontSize: 13,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      onTabItemSelected: (int index) {
        tabController.index = index;
      },
    );
  }
}
