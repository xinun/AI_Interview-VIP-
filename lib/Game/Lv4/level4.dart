import 'package:flutter/material.dart';

class Level4Page extends StatefulWidget {
  const Level4Page({super.key});

  @override
  State<Level4Page> createState() => _Level4PageState();
}

class _Level4PageState extends State<Level4Page> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation; // 위아래 흔들리는 애니메이션

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 애니메이션 지속 시간
    );

    // 흔들리다 진정되는 애니메이션 정의
    _shakeAnimation = Tween<double>(begin: 10, end: 20).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut, // 흔들리다 진정되는 효과
      ),
    );

    // 애니메이션 실행
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // AnimationController 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B), // 배경색
      body: Center(
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _shakeAnimation.value), // Y축으로 흔들림
              child: child,
            );
          },
          child: Image.asset(
            'assets/lv4_t.png', // 이미지 경로 (텍스트 이미지를 넣으세요)
            width: 200, // 이미지 너비
          ),
        ),
      ),
    );
  }
}
