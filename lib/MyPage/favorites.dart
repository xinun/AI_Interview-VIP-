import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Favorites extends StatefulWidget {
  final String userId; // Firebase 사용자 ID

  const Favorites({super.key, required this.userId});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  DateTime _selectedDate = DateTime.now();

  // 선택된 날짜를 yyyy-MM-dd 형식으로 포맷
  String get _selectedDateFormatted =>
      DateFormat('yyyy-MM-dd').format(_selectedDate);

  // Firebase에서 즐겨찾기 데이터 가져오기
  Stream<QuerySnapshot> _fetchFavorites() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .collection('videos')
        .where('isFavorite', isEqualTo: true) // 즐겨찾기 필터
        .snapshots();
  }

  // 달력 팝업 표시 함수
  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1F5EFF),
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 날짜 선택 버튼
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1F5EFF), width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDateFormatted,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        // Firebase에서 즐겨찾기 데이터 표시
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _fetchFavorites(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "선택한 날짜 ($_selectedDateFormatted)에 즐겨찾기가 없습니다.",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              // 필터링된 즐겨찾기 목록
              final filteredFavorites = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['recordedDate'] == _selectedDateFormatted;
              }).toList();

              if (filteredFavorites.isEmpty) {
                return Center(
                  child: Text(
                    "선택한 날짜 ($_selectedDateFormatted)에 즐겨찾기가 없습니다.",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredFavorites.length,
                itemBuilder: (context, index) {
                  final item = filteredFavorites[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: const Icon(Icons.video_library, color: Colors.orange),
                    title: Text(
                      item['title'] ?? '제목 없음',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      item['subtitle'] ?? '설명 없음',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () async {
                        // 즐겨찾기 해제
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.userId)
                            .collection('videos')
                            .doc(filteredFavorites[index].id)
                            .update({'isFavorite': false});
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
