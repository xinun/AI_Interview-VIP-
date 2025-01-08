import 'package:flutter/material.dart';
import 'package:vip/main_navigation.dart'; // GameMain1 import

// 홈 화면 위젯 클래스
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 제목 스타일 정의
    const TextStyle titleStyle = TextStyle(
      fontSize: 40, // 글자 크기
      fontWeight: FontWeight.bold, // 굵기
      color: Colors.white, // 색상
    );

    // 설명 텍스트 스타일 정의
    const TextStyle descriptionStyle = TextStyle(
      fontSize: 15, // 글자 크기
      color: Colors.grey, // 색상
      height: 1.5, // 줄 간격
    );

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/home.png', // 이미지 경로
              fit: BoxFit.cover, // 화면 전체를 채우도록 설정
              height: MediaQuery.of(context).size.height, // 화면 높이에 맞춤
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로드 실패 시 대체 위젯 표시
                return const Center(
                  child: Text(
                    'Error loading image', // 에러 메시지
                    style: TextStyle(
                      color: Colors.red, // 빨간색으로 표시
                      fontSize: 18, // 글자 크기
                      fontWeight: FontWeight.bold, // 굵기
                    ),
                  ),
                );
              },
            ),
          ),
          // 화면의 주요 콘텐츠
          Padding(
            padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 제목 텍스트 가운데 정렬
              children: [
                const SizedBox(height: 470), // 상단 여백
                // 화면 제목 (가운데 정렬)
                const Text("내 손안의 면접 게임\nVIP 시작하기", style: titleStyle, textAlign: TextAlign.left),
                
                const SizedBox(height: 20), // 제목 아래 간격
                // 설명 텍스트 (왼쪽 정렬)
                const Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Text(
                    "다음 화면에서 원하는 직종을 선택한 후,\n"
                    "게임을 시작하세요. 각 단계에서는 다양한\n"
                    "면접과 연결을 진행합니다.",
                    style: descriptionStyle,
                  ),
                ),
                const SizedBox(height: 70), // 버튼 위쪽 간격
                // 로그인 버튼 (Next 버튼에서 수정)
                Center(
                  child: _buildButton(
                    label: '로그인', // 버튼 텍스트
                    backgroundColor: Colors.white, // 버튼 배경 색상
                    textColor: Colors.black, // 버튼 텍스트 색상
                    onPressed: () {
                      // 버튼 클릭 시 GameMain1으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainNavigation(), // GameMain1 호출
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 버튼 생성 함수
  Widget _buildButton({
    required String label, // 버튼 텍스트
    required Color backgroundColor, // 버튼 배경 색상
    required Color textColor, // 버튼 텍스트 색상
    required VoidCallback onPressed, // 버튼 클릭 이벤트
  }) {
    return ElevatedButton(
      onPressed: onPressed, // 클릭 시 실행할 함수
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // 배경 색상
        foregroundColor: textColor, // 텍스트 색상
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // 버튼 모서리 둥글게
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 120, // 버튼 좌우 여백
          vertical: 16, // 버튼 위아래 여백
        ),
      ),
      child: Text(label), // 버튼 텍스트
    );
  }
}
