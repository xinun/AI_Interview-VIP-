import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vip/Game/Setting/game_timer.dart'; // game_timer.dart 임포트 (경로를 수정하세요)

class Home3Screen extends StatefulWidget {
  const Home3Screen({super.key});

  @override
  State<Home3Screen> createState() => _Home3ScreenState();
}

class _Home3ScreenState extends State<Home3Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation; // 크기 변화 애니메이션
  late Animation<double> _opacityAnimation; // 투명도 변화 애니메이션

  int countdownValue = 0; // 카운트다운 값
  bool isCountingDown = false; // 카운트다운 상태 확인
  bool showNextButton = false; // "넘어가기" 버튼 표시 여부

  @override
  void initState() {
    super.initState();

    // AnimationController 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 애니메이션 지속 시간
    )..repeat(reverse: true); // 반복 애니메이션 (앞뒤로 반복)

    // 크기 변화 애니메이션
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 투명도 변화 애니메이션
    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // AnimationController 해제
    super.dispose();
  }

  // 카운트다운 시작 함수
  void startCountdown() {
    setState(() {
      countdownValue = 10; // 초기값 설정
      isCountingDown = true; // 카운트다운 상태 시작
      showNextButton = false; // "넘어가기" 버튼 숨기기
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownValue > 0) {
        setState(() {
          countdownValue--;
        });
      } else {
        timer.cancel(); // 카운트다운 완료 시 타이머 정지
        setState(() {
          isCountingDown = false; // 카운트다운 상태 종료
          showNextButton = true; // "넘어가기" 버튼 표시
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 화면 배경색
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/home3_background.png', // 배경 이미지 경로
              fit: BoxFit.cover, // 화면에 맞게 이미지 채우기
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 패딩
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white), // 뒤로가기 아이콘
                          onPressed: () {
                            Navigator.pop(context); // 이전 화면으로 이동
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // 뒤로가기 버튼 아래 여백

                    // 타이틀 텍스트
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "인터뷰 시작 전",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 설명 텍스트
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "목소리가 잘 인식되는지\n 확인해 볼게요!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 100), // 타이틀과 애니메이션 간 간격

                    // 애니메이션 이미지 영역
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value, // 크기 변화 애니메이션
                            child: Opacity(
                              opacity: _opacityAnimation.value, // 투명도 변화 애니메이션
                              child: child,
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.asset(
                            'assets/interview_animation.png', // 애니메이션 이미지 경로
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 60), // 이미지와 카운트다운 간 간격

                    // 카운트다운 텍스트
                    if (isCountingDown)
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "$countdownValue",
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                    const SizedBox(height: 40), // 여백 추가

                    // "넘어가기" 버튼
                    if (showNextButton)
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            // "넘어가기" 버튼 클릭 시 game_timer.dart로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GameTimerScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff5500AA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "넘어가기",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20), // 추가 여백

                    // 음성 입력 시작 버튼
                    if (!showNextButton)
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          onPressed: isCountingDown
                              ? null // 카운트다운 중에는 버튼 비활성화
                              : startCountdown, // 버튼 클릭 시 카운트다운 시작
                          icon: const Icon(Icons.mic, color: Colors.white),
                          label: const Text(
                            "음성입력 시작",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff5500AA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 음성 테스트 기능 넣어야함 (flutter 라이브러리에 음성 인식 테스트 라이브러리 있음)
// 테스트 후 알림 기능 넣어야함 (시작하기 버튼 누르면 타이머 페이지로 이동 구현해야함 (game_timer.dart))
// 음성 테스트 기능 실패하면 게임이 시작이 안되도록 조건 부여하기
// 임시로 화면 넘어가는 버튼 만들었으니 꼭 삭제하기