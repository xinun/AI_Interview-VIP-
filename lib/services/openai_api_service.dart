import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:vip/Game/Setting/game_setting1.dart';


class OpenAIService {
  final String apiKey =
      '';

  get selectedSubSubCategory => null; // API 키를 여기에 추가하세요.

  Future<String> generateInterviewQuestion() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': '당신은 전문 면접관입니다. 심층적이고 구체적인 면접 질문을 하나만 생성하세요.'
            },
            {
              'role': 'user',
              'content': '깊이 있는 면접 질문 하나를 생성해 주세요.'
            }
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);

        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].trim();
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to fetch question');
      }
    } catch (e) {
      print('Error generating job-specific question: $e');
      return '샘플 질문: 소프트웨어 개발에서 버전 관리의 중요성을 설명하세요.';
    }
  }


  Future<String> generateInterviewQuestion2() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an assistant generating interview questions..'
            },
            {'role': 'user', 'content': '면접 질문을 2개만 생성해 주세요.'}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      // UTF-8 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);

      // 디버깅용 출력
      print('Response status: ${response.statusCode}');
      print('Response body: $decodedBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);

        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].trim();
        } else {
          throw Exception('Invalid response structure: $decodedBody');
        }
      } else {
        throw Exception('Failed to fetch question: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return '샘플 질문: 소프트웨어 개발에서 버전 관리의 중요성을 설명하세요.';
    }
  }

  Future<String> generateInterviewQuestion3() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an assistant generating interview questions..'
            },
            {'role': 'user', 'content': '부서 면접 질문을 하나만 생성해 주세요.'}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      // UTF-8 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);

      // 디버깅용 출력
      print('Response status: ${response.statusCode}');
      print('Response body: $decodedBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);

        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].trim();
        } else {
          throw Exception('Invalid response structure: $decodedBody');
        }
      } else {
        throw Exception('Failed to fetch question: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return '샘플 질문: 소프트웨어 개발에서 버전 관리의 중요성을 설명하세요.';
    }
  }

  Future<String> generateInterviewQuestion4() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an assistant generating interview questions..'
            },
            {'role': 'user', 'content': '압박 면접 질문을 하나만 생성해 주세요.'}
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      // UTF-8 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);

      // 디버깅용 출력
      print('Response status: ${response.statusCode}');
      print('Response body: $decodedBody');

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);

        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].trim();
        } else {
          throw Exception('Invalid response structure: $decodedBody');
        }
      } else {
        throw Exception('Failed to fetch question: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return '샘플 질문: 소프트웨어 개발에서 버전 관리의 중요성을 설명하세요.';
    }
  }


  Future<Map<String, dynamic>> evaluateResponse(String question, String answer) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': '''
                "Using the characteristics of appropriate and inappropriate responses below, please evaluate the interviewee’s interview demeanor and the quality of their responses as evidenced by the given question and answer information to determine the appropriateness of the answer. Please evaluate the following items and assign a score between 0 and 100 based on their appropriateness. And also include 3–4 lines of your analysis."

                "###"
                "1. Characteristics of an appropriate answer:
                    Clear and specific: The answer is direct and clear, making it easy for the interviewer to understand.
                    Relevant: The answer stays on topic and directly addresses the question, without including unnecessary information.
                    Based on real experience: The response is grounded in actual experience or concrete examples, adding credibility.
                    Confident yet humble: The answer is delivered with confidence, but not arrogance, and conveys a clear, assured tone.
                    Concise and respectful: The response is brief and to the point, avoiding overly lengthy explanations, while maintaining politeness."
                "2. Characteristics of an inappropriate answer:
                    Unclear or vague: The answer lacks clarity or is too vague, making it difficult for the interviewer to understand.
                    Includes irrelevant information: The answer diverges from the question and introduces unrelated topics.
                    Lacks real-life examples: The answer is theoretical, hypothetical, or overly general without any actual examples or concrete experience.
                    Lack of confidence: The answer is unsure or hesitant, possibly lacking conviction or appearing unprepared.
                    Unnecessarily long-winded: The response is overly detailed or lengthy, including irrelevant information that distracts from the main points."
                "3. Expertise essential considerations:
                    Knowledge and experience relevant to the job: The answer demonstrates a solid understanding of the skills and experiences required for the job.
                    Awareness of industry trends: The response shows an understanding of the latest trends, challenges, or developments within the industry related to the job.
                    Problem-solving ability: The ability to approach and solve job-related challenges is a key indicator of expertise.
                    Communication skills: Being able to clearly communicate complex ideas or issues in a way that’s easy for others to understand is an essential part of expertise.
                    Teamwork and collaboration: In modern roles, the ability to work effectively within a team is often just as important as individual skills, so examples of collaboration and team experience are important."
                "###"
                
                '''
            },
            {
              'role': 'user',
              'content': '''
                Question: $question
                Answer: $answer
                Please evaluate the answer strictly based on the criteria and provide a score along with a detailed explanation in Korean.
                '''
            }
          ],
          'max_tokens': 400,
          'temperature': 0.5, // 낮은 온도로 엄격하고 일관된 평가 생성
        }),

      );

      if (response.statusCode == 200) {
        // UTF-8 디코딩
        final decodedBody = utf8.decode(response.bodyBytes);
        print('Decoded Response: $decodedBody');

        final data = jsonDecode(decodedBody);
        final content = data['choices'][0]['message']['content'];
        print('Content before processing: $content'); // 디버깅 출력

        // 점수 추출
        final scoreMatch = RegExp(r'\b(100|\d{1,2})\b').firstMatch(content);
        final score = scoreMatch != null ? int.parse(scoreMatch.group(0)!) : 0;

        // 피드백 추출 (한글 처리 보장)
        final feedback = utf8.decode(utf8.encode(
          content.replaceAll(RegExp(r'^\d{1,3}[^가-힣]*'), '').trim(),
        ));

        print('Extracted Feedback: $feedback'); // 디버깅 출력

        return {
          'score': score,
          'feedback': feedback,
        };
      }

      else {
        throw Exception('Failed to evaluate answer');
      }
    } catch (e) {
      return {
        'score': 0,
        'feedback': '점수 평가 실패. 다시 시도해주세요.',
      };
    }
  }
}