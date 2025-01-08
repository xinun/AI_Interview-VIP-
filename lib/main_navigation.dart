import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'custom_tabbar.dart';
import 'Game/game_main.dart';
import 'StudyRoom/study_room.dart';
import 'MyPage/my_page.dart';

//커스텀 탭바 이동 로직 파일
//탭바가 포함된 페이지로의 전환 필요시, 반드시 MainNavigation()으로 호출해야함.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  // MotionTabBarController 초기화
  late MotionTabBarController _tabController;

  @override
  void initState() {
    super.initState();
    // MotionTabBarController 생성 및 초기화
    _tabController = MotionTabBarController(
      initialIndex: 1, // 초기 선택 탭: Home
      vsync: this,
      length: 3, // 탭 수
    );
  }

  @override
  void dispose() {
    _tabController.dispose(); // 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
        children: const [
          StudyRoomScreen(), // 첫 번째 탭 화면
          GameMain1(),       // 두 번째 탭 화면 (게임 화면)
          MyPageScreen(),    // 세 번째 탭 화면
        ],
      ),
      bottomNavigationBar: CustomTabBar(tabController: _tabController), // CustomTabBar 연결
    );
  }
}
