import 'package:flutter/material.dart';

// MainNavigation() 페이지를 import하세요.
// import 'path_to_your_main_navigation.dart'; // MainNavigation 파일의 경로에 맞게 수정

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int score = 70; // 현재 점수 예시
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home3_background.png'), // 배경 이미지 경로
                fit: BoxFit.cover, // 이미지를 화면에 꽉 채움
              ),
            ),
          ),
          // 메인 콘텐츠
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 상단 영역
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 뒤로가기 버튼
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            // MainNavigation 페이지로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainNavigation()),
                            );
                          },
                        ),
                        const Text(
                          'Game2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // "기록 저장" 버튼 로직
                          },
                          child: const Text(
                            '기록 저장',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    // 점수와 설명 부분
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9), // 약간 투명한 흰색 배경
                            borderRadius: BorderRadius.circular(20), // 모서리 둥글게
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$score점',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '80점부터 다음 단계를 진행할 수 있습니다.\n'
                                '피드백을 원하신다면 ‘피드백 보기’ 버튼을 누르세요.\n'
                                '면접을 다시 진행하시고 싶으시다면 ‘다시 시작’ 버튼을 누르세요.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 52, 52, 52),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // 캐릭터 이미지
                        Image.asset(
                          'assets/character(6).png', // 캐릭터 이미지 경로
                          width: 320,
                          height: 320,
                        ),
                      ],
                    ),
                    // 버튼들
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // 피드백 보기 로직 추가
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A4A4A), // 어두운 회색
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '피드백 보기',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        ElevatedButton(
                          onPressed: () {
                            // 다시 시작 로직 추가
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // 흰색
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black), // 테두리 검은색
                            ),
                          ),
                          child: const Text(
                            '다시 시작',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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

// MainNavigation 클래스 예시
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Navigation'),
      ),
      body: const Center(
        child: Text('메인 네비게이션 화면'),
      ),
    );
  }
}
