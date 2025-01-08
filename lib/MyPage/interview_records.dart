import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip/MyPage/videoplayer.dart';
import 'package:intl/intl.dart';

class InterviewRecords extends StatefulWidget {
  final String userId;

  const InterviewRecords({super.key, required this.userId});

  @override
  State<InterviewRecords> createState() => _InterviewRecordsState();
}

class _InterviewRecordsState extends State<InterviewRecords> {
  List<Map<String, dynamic>> _videos = [];
  DateTime _selectedDate = DateTime.now(); // 선택한 날짜

  // 선택한 날짜를 yyyy-MM-dd 형식으로 변환
  String get _selectedDateFormatted =>
      DateFormat('yyyy-MM-dd').format(_selectedDate);

  Future<void> _fetchVideos() async {
    try {
      // Firestore에서 recordedDate가 선택된 날짜와 일치하는 문서만 가져오기
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('videos')
          .where('recordedDate', isEqualTo: _selectedDateFormatted)
          .orderBy('uploadedAt', descending: true)
          .get();

      debugPrint('쿼리 실행: recordedDate = $_selectedDateFormatted');
      debugPrint('Firestore 반환된 문서 수: ${snapshot.docs.length}');

      // 데이터를 _videos 리스트에 저장
      setState(() {
        _videos = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id, // 문서 ID 추가
            'videoUrl': data['videoUrl'],
            'recordedDate': data['recordedDate'],
            'uploadedAt': data['uploadedAt'],
            'title': data['title'],
            'isFavorite': data['isFavorite'] ?? false, // 기본값은 false
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Firestore 데이터 가져오기 오류: $e');
    }
  }

  Future<void> _toggleFavorite(String documentId) async {
    try {
      final index = _videos.indexWhere((video) => video['id'] == documentId);
      if (index == -1) return;

      // 현재 상태 반전
      final isFavorite = !_videos[index]['isFavorite'];

      // Firestore에 업데이트
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('videos')
          .doc(documentId)
          .update({'isFavorite': isFavorite});

      // UI 업데이트
      setState(() {
        _videos[index]['isFavorite'] = isFavorite;
      });
    } catch (e) {
      debugPrint('즐겨찾기 상태 업데이트 중 오류 발생: $e');
    }
  }

  Future<void> deleteVideo(String documentId, String videoUrl) async {
    try {
      // 1. Firestore에서 메타데이터 삭제
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('videos')
          .doc(documentId)
          .delete();
      debugPrint("Firestore 문서 삭제 완료: $documentId");

      // 2. Firebase Storage에서 실제 영상 파일 삭제
      final storageRef = FirebaseStorage.instance.refFromURL(videoUrl);
      await storageRef.delete();
      debugPrint("Firebase Storage 영상 삭제 완료: $videoUrl");

      // 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('영상이 삭제되었습니다.')),
      );

      // UI 업데이트
      setState(() {
        _videos.removeWhere((video) => video['id'] == documentId);
      });
    } catch (e) {
      debugPrint('영상 삭제 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('영상 삭제 중 문제가 발생했습니다.')),
      );
    }
  }

  Future<void> _confirmDeletion(BuildContext context, String documentId,
      String videoUrl) async {
    // 삭제 확인 다이얼로그
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text('정말로 이 영상을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // 취소 버튼
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                await deleteVideo(documentId, videoUrl); // 삭제 작업 수행
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) async {
    // 달력에서 날짜 선택
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

    if (picked != null) {
      // 선택된 날짜를 설정하고 새로운 데이터 가져오기
      setState(() {
        _selectedDate = picked;
      });
      _fetchVideos();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVideos(); // 초기 데이터 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경을 검은색으로 설정
      body: Column(
        children: [
          // 날짜 선택 버튼
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () => _showDatePicker(context), // 날짜 선택 동작
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.95,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1F5EFF), width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDateFormatted, // 선택된 날짜 표시
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    // 드롭다운 아이콘
                  ],
                ),
              ),
            ),
          ),
          // 콘텐츠 표시
          Expanded(
            child: _videos.isEmpty
                ? Center(
              child: Text(
                '선택한 날짜 ($_selectedDateFormatted)에 저장된 영상이 없습니다.',
                style: const TextStyle(color: Colors.white), // 텍스트를 흰색으로 설정
              ),
            )
                : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return ListTile(
                  leading: const Icon(Icons.video_library, color: Colors.orange),
                  title: Text(
                    video['title'] ?? '제목 없음',  // title을 표시, 없으면 '제목 없음'
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '녹화 시간: ${video['uploadedAt']?.toDate() ?? '시간 정보 없음'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          video['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: video['isFavorite']
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          _toggleFavorite(video['id']);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChewiePlayerScreen(
                                videoUrl: video['videoUrl'] ?? '',
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDeletion(context, video['id'], video['videoUrl']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
