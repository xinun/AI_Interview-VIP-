//question_tabs.dart
import 'dart:math';
import 'package:flutter/material.dart';
// 질문 데이터
import './interview_data/Design_questions.dart';
import './interview_data/Management_questions.dart';
import './interview_data/ICT_questions.dart';
import './interview_data/SalesMarketing_questions.dart';
import './interview_data/PublicService_questions.dart';
import './interview_data/ProductionManufacturing_questions.dart';
import './interview_data/RND_questions.dart';
import 'answer_page.dart';

class QuestionTabs extends StatefulWidget {
  final String searchQuery;
  final VoidCallback onTaskComplete;

  const QuestionTabs({
    Key? key,
    required this.searchQuery,
    required this.onTaskComplete,
  }) : super(key: key);

  @override
  _QuestionTabsState createState() => _QuestionTabsState();
}

class _QuestionTabsState extends State<QuestionTabs> {
  late Map<String, List<String>> filteredQuestions;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    filteredQuestions = {
      "경영 관리": _getFilteredQuestions(managementData),
      "소프트웨어 개발": _getFilteredQuestions(ictData),
      "영업/마케팅 전략": _getFilteredQuestions(salesMarketingData),
      "공공 업무": _getFilteredQuestions(publicServiceData),
      "디자인": _getFilteredQuestions(designData),
      "생산/제조": _getFilteredQuestions(productionManufacturingData),
      "연구 개발": _getFilteredQuestions(rndData),
    };
  }

  List<String> _getFilteredQuestions(List<Map<String, String>> data) {
    return data
        .where((item) =>
    item['question'] != null &&
        item['question']!.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .map((item) => item['question']!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: filteredQuestions.keys.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            tabs: filteredQuestions.keys
                .map((category) => Tab(text: category))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: filteredQuestions.keys.map((category) {
                return _buildQuestionList(filteredQuestions[category] ?? [], category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(List<String> questions, String category) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        final answer = _getAnswer(category, question);

        return GestureDetector(
          onTap: () {
            widget.onTaskComplete();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnswerPage(question: question, answer: answer),
              ),
            );
          },
          child: Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                question,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getAnswer(String category, String question) {
    final data = _getCategoryData(category);
    final answer = data.firstWhere(
          (item) => item['question'] == question,
      orElse: () => {'answer': "답변을 찾을 수 없습니다."},
    );
    return answer['answer'] ?? "답변을 찾을 수 없습니다.";
  }

  List<Map<String, String>> _getCategoryData(String category) {
    switch (category) {
      case "경영 관리":
        return managementData;
      case "소프트웨어 개발":
        return ictData;
      case "영업/마케팅 전략":
        return salesMarketingData;
      case "공공 업무":
        return publicServiceData;
      case "디자인":
        return designData;
      case "생산/제조":
        return productionManufacturingData;
      case "연구 개발":
        return rndData;
      default:
        return [];
    }
  }
}

