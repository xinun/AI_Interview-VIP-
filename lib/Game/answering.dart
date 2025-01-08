import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vip/Game/Setting/game_timer.dart';
import 'package:vip/Game/score.dart';


//타이머 받기 기능 도입
class AnsweringPage extends StatefulWidget {
  const AnsweringPage({super.key});

  @override
  State<AnsweringPage> createState() => _AnsweringPageState();
}

class _AnsweringPageState extends State<AnsweringPage> {
  bool isCameraOn = false; // 전면 카메라 상태
  late int remainingTime; //남은 답변 시간(초단위)
  late Timer? countdownTimer; // 타이머 객체

  // 전면 카메라 활성화/비활성화 함수
  void toggleCamera() {
    setState(() {
      isCameraOn = !isCameraOn; // 카메라 상태 변경
    });
  }

 @override
  void initState() {
    super.initState();
    remainingTime = selectedTimerValue; // 설정된 타이머 값으로 초기화
    startCountdown(); // 타이머 시작
  }

   @override
  void dispose() {
    countdownTimer?.cancel(); // 페이지 종료 시 타이머 정지
    super.dispose();
  }

    // 카운트다운 타이머 시작 함수
  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--; // 1초씩 감소
        } else {
          timer.cancel(); // 시간이 끝나면 타이머 종료
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B), // 배경색
      body: Stack(
        children: [
          // 상단 상태 표시
          Positioned(
            top: 60,
            left: 20, // ON-AIR 버튼의 좌측 여백을 더 늘림
            child: Row(
              children: [
                // ON-AIR 버튼
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCameraOn ? Colors.red : Colors.grey.shade400, // 카메라 상태에 따라 색상 변경
                    borderRadius: BorderRadius.circular(20), // 둥근 모서리
                  ),
                  child: const Text(
                    'ON-AIR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 125), // 간격을 조정해 더 오른쪽으로 이동
                // 남은 답변 시간
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // 밝은 회색 배경
                    borderRadius: BorderRadius.circular(20), // 둥근 모서리
                  ),
                  child:  Text(
                    '남은 답변 시간 ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}',// 시간 표시 (분:초)
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 하단 버튼 영역
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // 화면 ON 버튼을 왼쪽 정렬
                children: [
                  // 화면 ON 버튼 (이미지 버튼)
                  Padding(
                    padding: const EdgeInsets.only(left: 6), // 화면 ON 버튼의 좌측 여백 추가
                    child: GestureDetector(
                      onTap: toggleCamera, // 버튼 클릭 시 카메라 상태 변경
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/screen_on.png', // 버튼 이미지 경로
                            width: 50,
                            height: 50,
                            color: isCameraOn ? Colors.blue : Colors.grey, // 활성화 상태에 따라 색상 변경
                          ),
                          const SizedBox(height: 8), // 간격
                          Text(
                            '화면 ON',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isCameraOn ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 대답 완료 버튼
                  const SizedBox(width: 34,), // 버튼 사이에 여유 공간 추가
                  ElevatedButton(
                    onPressed: () {
                      
                      countdownTimer?.cancel(); // 타이머 종료
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> const ResultPage(),),);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 102, 186), // 버튼 배경색
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13), // 둥근 모서리
                      ),
                    ),
                    child: const Text(
                      '대답 완료',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // 텍스트 색상
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
