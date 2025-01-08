import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login&Register/login.dart';
import 'Login&Register/user_provider.dart';
import 'main_navigation.dart';
import 'Login&Register/firebase_options.dart';
import 'package:vip/Login&Register/login.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
Future<void> main() async {
  // 스플래시 화면 유지 설정
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase 초기화 작업

  // Firebase App Check 활성화
  //await FirebaseAppCheck.instance.activate();

  // 초기화 작업이 끝난 후 스플래시 화면 제거
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 앱 실행
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // UserProvider 등록
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(), // StreamBuilder로 상태 확인
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            // 로그아웃 상태 -> Login 화면으로 이동
            return LoginScreen();
          } else {
            // 로그인 상태 -> UserProvider에 사용자 정보 저장
            Future.microtask(() {
              Provider.of<UserProvider>(context, listen: false).setUser(user);
              Provider.of<UserProvider>(context, listen: false).setUserInfo(
                user.displayName ?? '사용자 이름 없음',
                user.photoURL ?? '',
              );
            });

            return const MainNavigation(); // 로그인 상태 -> MainNavigation 화면
          }
        }

        // 연결 상태가 로딩 중일 때 로딩 화면 표시
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

