import 'package:flutter/material.dart';
import 'game_timer2.dart'; // GameTimer2Screen 파일을 import

// 타이머 값을 저장할 변수 (다른 페이지에서 활용) **중요**
int selectedTimerValue = 60; // 기본값은 60초

class GameTimerScreen extends StatefulWidget {
  const GameTimerScreen({super.key});

  @override
  State<GameTimerScreen> createState() => _GameTimerScreenState();
}

class _GameTimerScreenState extends State<GameTimerScreen> {
  int timerValue = selectedTimerValue; // 현재 화면에서 사용하는 타이머 값

  /// 타이머 값을 증가시키는 함수
  void increaseTimer() {
    setState(() {
      timerValue += 10; // 타이머 값을 10초 증가
    });
  }

  /// 타이머 값을 감소시키는 함수
  void decreaseTimer() {
    setState(() {
      if (timerValue > 10) {
        timerValue -= 10; // 타이머 값을 10초 감소 (최소값은 10초로 제한)
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
              fit: BoxFit.cover, // 화면에 맞게 배경 이미지 채우기
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 화면 중앙 정렬
                children: [
                  // 페이지 제목
                  const Text(
                    "셀프 타이머",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 161, 116, 243), // 텍스트 색상
                    ),
                  ),
                  const SizedBox(height: 20), // 제목과 설명 간 간격

                  // 페이지 설명
                  const Text(
                    "질문 당 응답 시간을 설정해 주세요",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // 설명 텍스트 색상
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  ),
                  const SizedBox(height: 80), // 설명과 타이머 조정 UI 간 간격

                  // 타이머 조정 UI
                  Column(
                    children: [
                      // 위쪽 화살표 버튼 (타이머 값 증가)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_drop_up, // 위쪽 화살표 아이콘
                          color: Colors.white,
                          size: 40, // 아이콘 크기
                        ),
                        onPressed: increaseTimer, // 증가 함수 호출
                      ),
                      const SizedBox(height: 15), // 화살표와 타이머 값 간 간격

                      // 타이머 값 표시
                      Text(
                        "$timerValue 초", // 타이머 값 표시
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 161, 116, 243), // 타이머 값 텍스트 색상
                        ),
                      ),
                      const SizedBox(height: 20), // 타이머 값과 아래쪽 화살표 간 간격

                      // 아래쪽 화살표 버튼 (타이머 값 감소)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_drop_down, // 아래쪽 화살표 아이콘
                          color: Colors.white,
                          size: 40, // 아이콘 크기
                        ),
                        onPressed: decreaseTimer, // 감소 함수 호출
                      ),
                    ],
                  ),
                  const SizedBox(height: 120), // 타이머 조정 UI와 Start 버튼 간 간격

                  // 시작 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 타이머 값 저장 후 GameTimer2Screen으로 이동
                      selectedTimerValue = timerValue; // 전역 변수에 현재 값 저장
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameTimer2Screen(), // 다음 페이지로 이동
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 161, 116, 243), // 버튼 배경색
                      foregroundColor: Colors.white, // 버튼 텍스트 색상
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100, // 버튼의 좌우 여백
                        vertical: 16, // 버튼의 상하 여백
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // 버튼 모서리 둥글게
                      ),
                    ),
                    child: const Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // 버튼 텍스트 두껍게
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
