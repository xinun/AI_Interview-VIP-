import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:vip/services/openai_api_service.dart';

class Test1Page extends StatefulWidget {
  final void Function(int)? onNextStepUnlocked;
  final String userId;
  final String jobCategory; // 직무 카테고리 추가

  const Test1Page({
    super.key,
    required this.userId,
    this.onNextStepUnlocked,
    required this.jobCategory, // 생성자에 직무 카테고리 추가
  });

  @override
  _Test1PageState createState() => _Test1PageState();
}

class _Test1PageState extends State<Test1Page> {
  CameraController? _cameraController;
  bool _isRecording = false;
  bool _isCameraInitialized = false;
  String? _videoPath;
  String interviewQuestion = "여기에 면접 질문 내용이 표시됩니다.";
  String userResponse = "";
  bool isLoading = false;
  bool isResponseSubmitting = false;
  FlutterTts flutterTts = FlutterTts(); // TTS 객체 생성

  final OpenAIService openAIService = OpenAIService();
  final TextEditingController responseController = TextEditingController();

  // STT 관련 변수
  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  int currentScore = 0;

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });

      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            responseController.text = result.recognizedWords; // 실시간으로 텍스트 업데이트
          });
        },
        listenFor: Duration(seconds: 60),
      );
    } else {
      _showSnackBar('음성 인식을 사용할 수 없습니다.');
    }
  }


  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      debugPrint('마이크 권한이 허용되었습니다.');
    } else if (status.isDenied) {
      debugPrint('마이크 권한이 거부되었습니다.');
      _showSnackBar('마이크 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
    } else if (status.isPermanentlyDenied) {
      debugPrint('마이크 권한이 영구적으로 거부되었습니다.');
      openAppSettings(); // 설정 화면 열기
    }
  }
  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission(); // 마이크 권한 요청
    fetchInterviewQuestion();  // 면접 질문을 가져오는 함수
    _speechToText = stt.SpeechToText(); // 음성 인식 초기화
    _initializeCamera(); // 카메라 초기화
    flutterTts.setLanguage("ko-KR"); // 한국어로 설정
    flutterTts.setPitch(1.0); // 음성의 높낮이 조정 (기본값은 1.0)
    flutterTts.setVolume(1.0); // 음성의 볼륨 (기본값은 1.0)
  }
  void _readInterviewQuestion() async {
    await flutterTts.speak(interviewQuestion); // interviewQuestion을 음성으로 읽음
  }
  @override
  void dispose() {
    if (_isRecording) {
      _stopRecordingAndUpload();
    }
    _cameraController?.dispose();
    responseController.dispose();
    super.dispose();
  }


  Future<void> _initializeCamera() async {
    await _requestCameraPermission(); // 카메라 권한 요청
    try {
      final cameras = await availableCameras();
      for (var camera in cameras) {
        debugPrint('카메라 이름: ${camera.name}, 방향: ${camera.lensDirection}');
      }

      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('전면 카메라를 찾을 수 없습니다.'),
      );


      if (frontCamera == null) {
        _showSnackBar('전면 카메라가 없습니다. 후면 카메라를 사용합니다.');
        final backCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => throw Exception('후면 카메라를 찾을 수 없습니다.'),
        );
        _cameraController = CameraController(backCamera, ResolutionPreset.high);
      } else {
        _cameraController = CameraController(frontCamera, ResolutionPreset.high);
      }

      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('카메라 초기화 오류: $e');
      _showSnackBar('카메라를 초기화할 수 없습니다. 오류: $e');
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      debugPrint('카메라 권한이 허용되었습니다.');
    } else if (status.isDenied) {
      debugPrint('카메라 권한이 거부되었습니다.');
      _showSnackBar('카메라 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
    } else if (status.isPermanentlyDenied) {
      debugPrint('카메라 권한이 영구적으로 거부되었습니다.');
      openAppSettings(); // 설정 화면 열기
    }
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _showSnackBar('카메라가 초기화되지 않았습니다.');
      return;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      final videoPath = '${directory.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _cameraController?.startVideoRecording();
      setState(() {
        _isRecording = true;
        _videoPath = videoPath;
      });
    } catch (e) {
      debugPrint('녹화 시작 오류: $e');
      _showSnackBar('녹화를 시작할 수 없습니다.');
    }
  }

  Future<void> _stopRecordingAndUpload() async {
    if (!_isRecording || _cameraController == null) return;

    try {
      final videoFile = await _cameraController?.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });

      if (videoFile != null) {
        await _uploadToFirebase(File(videoFile.path));
      }
    } catch (e) {
      debugPrint('녹화 중지 오류: $e');
      _showSnackBar('녹화를 중지하는 중 문제가 발생했습니다.');
    }
  }

  Future<void> _uploadToFirebase(File file) async {
    try {
      final timestamp = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(timestamp);
      final title = '${widget.jobCategory} 면접 연습 영상 (${formattedDate} ${timestamp.hour}:${timestamp.minute})';
      final storageRef = FirebaseStorage.instance
          .ref('Users/${widget.userId}/videos/${timestamp.millisecondsSinceEpoch}.mp4');
      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('videos')
          .add({
        'videoUrl': downloadUrl,
        'recordedDate': formattedDate,
        'uploadedAt': FieldValue.serverTimestamp(),
        'title': title,
        'jobCategory': widget.jobCategory,
      });

      _showSnackBar('영상 업로드 완료: $title');
    } catch (e) {
      debugPrint('Firebase 업로드 오류: $e');
      _showSnackBar('영상을 저장하는 중 문제가 발생했습니다.');
    }
  }

  Future<void> fetchInterviewQuestion() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final question = await openAIService.generateInterviewQuestion();
      if (mounted) {
        setState(() {
          interviewQuestion = question;
        });
        _readInterviewQuestion(); // 질문을 읽음
      }
    } catch (error) {
      debugPrint("API 호출 실패: $error");
      if (mounted) {
        setState(() {
          interviewQuestion = "질문을 생성하는 데 실패했습니다. 다시 시도해주세요.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  Future<void> submitResponse() async {
    if (!mounted) return;

    final response = responseController.text.trim();
    if (response.isEmpty) return;

    setState(() {
      isResponseSubmitting = true;
    });

    try {
      final result = await openAIService.evaluateResponse(
          interviewQuestion, response);
      if (mounted) {
        setState(() {
          currentScore = result['score'];
          isResponseSubmitting = false;
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("평가 결과"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("점수: ${result['score']}"),
                  Text("피드백: ${result['feedback']}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    // 점수가 70 이상이면 다음 단계 활성화
                    if (result['score'] >= 70 &&
                        widget.onNextStepUnlocked != null) {
                      widget.onNextStepUnlocked!(result['score']);
                    }
                  },
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      debugPrint("응답 처리 실패: $error");
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("오류"),
              content: const Text("응답을 처리하는 데 실패했습니다. 다시 시도해주세요."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isResponseSubmitting = false;
          responseController.clear();
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: '설정으로 이동',
          onPressed: openAppSettings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  'assets/home3_background.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
          ),
          // 뒤로가기 버튼
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          // 캐릭터 이미지
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: MediaQuery.of(context).size.width * 0.5 - 210,
            child: Image.asset(
              'assets/character(1).png',
              width: 420,
              height: 420,
            ),
          ),
          // 대화 상자
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.3,
            left: 20,
            right: 20,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 230, 230),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.jobCategory} 면접 질문:",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        interviewQuestion,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading ? null : fetchInterviewQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("새 질문"),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          // 텍스트 입력 및 제출 버튼
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: responseController,
                    decoration: const InputDecoration(
                      hintText: "답변을 음성으로 입력하세요",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    readOnly: false,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(_isListening ? Icons.stop : Icons.mic),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isResponseSubmitting ? null : submitResponse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("제출"),
                ),
              ],
            ),
          ),
          // 녹화 버튼
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton(
              onPressed: _isRecording
                  ? _stopRecordingAndUpload
                  : _startRecording,
              backgroundColor: _isRecording ? Colors.red : Colors.black,
              child: Text(
                _isRecording ? '녹화 중지' : '녹화 시작',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}