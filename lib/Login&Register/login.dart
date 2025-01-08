import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'login_service.dart'; // 로그인 서비스 함수 import

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // Google 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: SignInButton(
                  Buttons.Google,
                  text: "Login with Google",
                  onPressed: () => signInWithGoogle(context),
                ),
              ),
              const SizedBox(height: 20),
              // GitHub 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: SignInButton(
                  Buttons.GitHub,
                  text: "Login with GitHub",
                  onPressed: () => signInWithGitHub(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
