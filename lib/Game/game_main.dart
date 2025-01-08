import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vip/Game/Lv1/test1.dart';

import 'package:vip/Game/Setting/game_setting1.dart';

import 'Lv2/test2.dart';
import 'Lv3/test3.dart';
import 'Lv4/test4.dart';

class GameMain1 extends StatefulWidget {
  const GameMain1({super.key});


  @override
  GameMain1State createState() => GameMain1State();
}

class GameMain1State extends State<GameMain1> {
  int currentStep = 1; // 현재 활성화된 단계
  int score = 0; // 현재 점수

  // 각 단계 잠금 해제에 필요한 점수
  final List<int> requiredScores = [0, 80, 160, 240];

  // 점수를 업데이트하고 단계 잠금 해제 확인
  void _updateScoreAndCheckNextStep(int newScore) {
    setState(() {
      score += newScore;

      // 다음 단계 잠금 해제 확인
      if (currentStep < requiredScores.length &&
          score >= requiredScores[currentStep]) {
        currentStep++;
      }
    });
  }

  // 단계별 UI 생성
  List<Widget> _buildStepListWithCustomSpacing() {
    List<Widget> steps = [];
    for (int i = 1; i <= 4; i++) {
      steps.add(
        Column(
          children: [
            _buildLockStep(
              isLocked: score < requiredScores[i - 1],
              stepNumber: '$i',
              onTap: () => _onStepTap(i),
            ),
            const SizedBox(height: 16), // 각 단계 간 간격
          ],
        ),
      );
    }
    return steps;
  }

  // 잠금 상태의 단계 버튼 생성
  Widget _buildLockStep({
    required bool isLocked,
    required String stepNumber,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLocked ? null : onTap, // 잠겨 있으면 작동하지 않음
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked ? Colors.grey : Colors.green,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isLocked)
            const Icon(
              Icons.lock,
              color: Colors.white,
              size: 30,
            ),
        ],
      ),
    );
  }

  // 단계 클릭 시 동작

  @override
  Widget build(BuildContext context) {
    // Firebase 인증에서 사용자 정보 가져오기
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';  // 사용자 ID 가져오기

    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      body: Stack(
        children: [
          Column(
            children: [
              // 상단 프로필 섹션
              _buildProfileSection(),
              // 단계별 UI
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildStepListWithCustomSpacing(),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
          // 설정 버튼
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 21, 21, 21),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home2Screen()),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.settings, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
  void _onStepTap(int step) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';  // Firebase에서 바로 가져오기

    if (score < requiredScores[step - 1]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Step $step을 시작하려면 ${requiredScores[step - 1]} 점수가 필요합니다!'),
        ),
      );
    } else {
      // Test1Page로 이동
      if (step == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Test1Page(
              onNextStepUnlocked: _updateScoreAndCheckNextStep,
              userId: userId, jobCategory: '',  // 직접 Firebase에서 가져온 userId 전달
            ),
          ),
        );
      }

      if (step == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Test2Page(
              onNextStepUnlocked: _updateScoreAndCheckNextStep, userId: userId,
            ),
          ),
        );
      }
      if (step == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Test3Page(
              onNextStepUnlocked: _updateScoreAndCheckNextStep, userId: userId,
            ),
          ),
        );
      }
      if (step == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Test4Page(
              onNextStepUnlocked: _updateScoreAndCheckNextStep, userId: userId,
            ),
          ),
        );
      }
      // 추가 단계 로직 필요 시 여기에 작성
    }
  }


  Widget _buildProfileSection() {
    return Container(
      height: 150,
      color: Colors.grey[800],
      child: Center(
        child: Text(
          'Score: $score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
