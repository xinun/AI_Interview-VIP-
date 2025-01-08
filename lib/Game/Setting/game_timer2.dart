import 'package:flutter/material.dart';
import 'package:vip/main_navigation.dart';


class GameTimer2Screen extends StatelessWidget {
  const GameTimer2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색 설정
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/home3_background.png', // 배경 이미지 경로
              fit: BoxFit.cover, // 화면을 채우도록 이미지 조정
            ),
          ),

          // 화면 내용
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 뒤로가기 버튼 정렬
              children: [
                // 뒤로가기 버튼
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.pop(context); // 이전 화면으로 이동
                    },
                  ),
                ),

                const SizedBox(height: 12), // 뒤로가기 버튼과 말풍선 간 간격

                // 화면 중앙 내용
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: [
                      // 말풍선 이미지
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Image.asset(
                          'assets/game2_bubble.png', // 말풍선 이미지 경로
                          fit: BoxFit.contain,
                        ),
                      ),

                      // 캐릭터 이미지
                      Image.asset(
                        'assets/character(6).png', // 캐릭터 이미지 경로
                        height: 350, // 캐릭터 이미지 높이
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 40), // 캐릭터와 버튼 간 간격

                      // 면접 게임 시작 버튼
                      ElevatedButton(
                        onPressed: () {
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavigation(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1E1E3E), // 버튼 배경색
                          foregroundColor: Colors.white, // 버튼 텍스트 색상
                          padding: const EdgeInsets.symmetric(
                            horizontal: 130,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25), // 버튼 모서리 둥글게
                          ),
                        ),
                        child: const Text(
                          "면접 게임 시작",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
