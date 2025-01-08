import 'package:flutter/material.dart';
import 'package:vip/Game/Lv1/wait1.dart';

// WaitPage를 import하세요.
// import 'package:your_project/wait.dart'; // WaitPage 파일 경로에 맞게 수정

class Level1Page extends StatefulWidget {
  const Level1Page({super.key});

  @override
  State<Level1Page> createState() => _Level1PageState();
}

class _Level1PageState extends State<Level1Page> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation; // 위아래 흔들리는 애니메이션

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // 애니메이션 지속 시간
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

    // 3초 후 WaitPage로 이동
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const WaitPage1()), // WaitPage로 이동
      );
    });
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
            'assets/lv1_t.png', // 이미지 경로 (텍스트 이미지를 넣으세요)
            width: 200, // 이미지 너비
          ),
        ),
      ),
    );
  }
}
