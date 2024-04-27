import 'package:chatpotgemini/chat_screen.dart';
import 'package:chatpotgemini/pages/login_page.dart';
import 'package:chatpotgemini/pages/signup_page.dart';
import 'package:chatpotgemini/pages/start_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StartPage(),
      routes: {
        chatScreen.id: (context) => chatScreen(),
        StartPage.id: (context) => StartPage(),
        LoginPage.id: (context) => LoginPage(),
        SignUpPage.id: (context) => SignUpPage(),
      },
    );
  }
}
