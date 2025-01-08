import 'package:flutter/material.dart';

import 'game_setting2.dart';

class Home2Screen extends StatefulWidget {
  const Home2Screen({super.key});

  @override
  State<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  // 대분류, 중분류, 소분류 값
  String selectedCategory = '선택 안함';
  String selectedSubCategory = '선택 안함';
  String selectedSubSubCategory = '선택 안함';

  // 대분류에 맞는 중분류와 소분류 항목 설정
  final Map<String, Map<String, List<String>>> categoryData = {
    'IT/데이터': {
      '중분류': ['소프트웨어', '하드웨어'],
      '소분류': ['컴퓨터', '모바일', '네트워크']
    },
    '식품': {
      '중분류': ['가공식품', '음료', '신선식품'],
      '소분류': ['과자', '음료수', '채소']
    },
    '섬유/의복': {
      '중분류': ['의류', '악세사리', '신발'],
      '소분류': ['남성', '여성', '아동']
    },
    '기계': {
      '중분류': ['자동차', '기계부품'],
      '소분류': ['엔진', '배터리', '타이어']
    },
    '건설': {
      '중분류': ['건축', '토목'],
      '소분류': ['철근', '콘크리트', '목재']
    },
    '서비스': {
      '중분류': ['교육', '헬스케어', '금융'],
      '소분류': ['학교', '병원', '은행']
    },
    '경영': {
      '중분류': ['인사', '재무', '마케팅'],
      '소분류': ['HR', '회계', '광고']
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // 상단 뒤로가기 버튼
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 대분류 선택
              _buildCategoryDropdown('대분류', categoryData.keys.toList(), (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  selectedSubCategory = '선택 안함'; // 중분류 초기화
                  selectedSubSubCategory = '선택 안함'; // 소분류 초기화
                });
              }),
              const SizedBox(height: 20),

              // 중분류 선택
              _buildCategoryDropdown(
                '중분류',
                selectedCategory != '선택 안함'
                    ? categoryData[selectedCategory]!['중분류']!
                    : [],
                    (newValue) {
                  setState(() {
                    selectedSubCategory = newValue!;
                    selectedSubSubCategory = '선택 안함'; // 소분류 초기화
                  });
                },
              ),
              const SizedBox(height: 20),

              // 소분류 선택
              _buildCategoryDropdown(
                '소분류',
                selectedSubCategory != '선택 안함'
                    ? categoryData[selectedCategory]!['소분류']!
                    : [],
                    (newValue) {
                  setState(() {
                    selectedSubSubCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Next Page 버튼
              ElevatedButton(
                onPressed: () {
                  // Home3Screen으로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home3Screen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Next Page"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 드롭다운 빌드 함수
  Widget _buildCategoryDropdown(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    // 기본 값이 "선택 안함"인 경우만 설정하고, 항목 리스트에서 "선택 안함"을 제외
    final itemsWithDefault = [
      '선택 안함',
      ...items,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: DropdownButtonFormField<String>(
        value: label == '대분류'
            ? selectedCategory
            : label == '중분류'
            ? selectedSubCategory
            : selectedSubSubCategory,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dropdownColor: Colors.grey[800],
        items: itemsWithDefault
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
