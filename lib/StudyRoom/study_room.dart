import 'package:flutter/material.dart';
import 'daily_task.dart';
import 'question_tabs.dart';
import 'package:flutter/material.dart';
import 'daily_task.dart';
import 'question_tabs.dart';

class StudyRoomScreen extends StatefulWidget {
  const StudyRoomScreen({super.key});

  @override
  StudyRoomScreenState createState() => StudyRoomScreenState();
}

class StudyRoomScreenState extends State<StudyRoomScreen> {
  String _searchQuery = ""; // 검색어 상태
  int completedTasks = 0; // 완료된 작업 수
  final int totalTasks = 5; // 총 작업 수

  // 작업 완료 콜백
  void _onTaskComplete() {
    if (completedTasks < totalTasks) {
      setState(() {
        completedTasks++; // 완료된 작업 수 증가
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경색 설정
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 55), // 상단 여백
            const Text(
              "You have got 5 tasks\ntoday to complete ✏️",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            // 검색창
            _buildSearchBar(),
            const SizedBox(height: 25),
            // Daily Task 진행 바
            DailyTask(
              completedTasks: completedTasks,
              totalTasks: totalTasks,
              motivationMessage: _getMotivationMessage(completedTasks),
            ),
            const SizedBox(height: 20),
            // 질문 리스트
            Expanded(
              child: QuestionTabs(
                searchQuery: _searchQuery,
                onTaskComplete: _onTaskComplete, // 작업 완료 콜백 전달
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value; // 검색어 업데이트
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  String _getMotivationMessage(int completedTasks) {
    List<String> motivationalMessages = [
      "시작이 반입니다! 첫 걸음을 내디딘 당신, 이미 성공을 향해 한 발짝 더 나아갔습니다.",
      "작은 걸음이 큰 변화를 만듭니다! 지금 이 순간이 토끼와 거북이의 경주처럼 중요한 출발점입니다.",
      "잘하고 있어요! 정확한 목표를 설정하고 꾸준히 걸음을 내딛으세요. 계속 전진하세요!",
      "수많은 성공의 비밀은 성실과 끈기입니다. 당신은 지금 그것을 실현하고 있습니다!",
      "어제와는 다른 오늘, 내일의 새로운 더 밝은 발걸음. 당신의 노력은 결실을 맺을 것입니다.",
      "매일 조금씩 목표에 다가가는 당신 정말 대단합니다! 오늘의 성공은 내일 더 큰 변화를 만듭니다.",
    ];
    return motivationalMessages[completedTasks];
  }
}

