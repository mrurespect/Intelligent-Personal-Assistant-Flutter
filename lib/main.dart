import 'package:chatpotgemini/chat_screen.dart';
import 'package:chatpotgemini/mybot.dart';
import 'package:chatpotgemini/pages/login_page.dart';
import 'package:chatpotgemini/pages/signup_page.dart';
import 'package:chatpotgemini/pages/start_page.dart';
import 'package:flutter/material.dart';
// import 'package:chatpotgemini/helpers/theme_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StartPage(), //chatScreen(),

      routes: {
        chatScreen.id: (context) => chatScreen(),
        StartPage.id: (context) => StartPage(),
        LoginPage.id: (context) => LoginPage(),
        SignUpPage.id: (context) => SignUpPage(),
      },
    );
  }
}
// =======
//         routes: {
//           Chatbot.id: (context) => Chatbot(),
//           StartPage.id: (context) => StartPage(),
//           LoginPage.id: (context) => LoginPage(),
//           SignUpPage.id: (context) => SignUpPage(),
//         },
//         debugShowCheckedModeBanner: false,
//         title: 'Picco',
//         theme: ThemeData(
//           primaryColor: ThemeColors.primaryColor,
//           scaffoldBackgroundColor: ThemeColors.scaffoldBgColor,
//         ),
//         home: StartPage());  }

