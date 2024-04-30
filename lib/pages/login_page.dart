import 'package:chatpotgemini/chat_screen.dart';
import 'package:chatpotgemini/components/main_button.dart';
import 'package:chatpotgemini/helpers/font_size.dart';
import 'package:chatpotgemini/helpers/theme_colors.dart';
import 'package:chatpotgemini/mybot.dart';
import 'package:chatpotgemini/pages/signup_page.dart';
import 'package:chatpotgemini/service/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../service/AuthService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String id = 'logIn';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(right: 50, top: 6, bottom: 6, left: 6),
                  decoration: BoxDecoration(
                    color: ThemeColors.whiteTextColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Let's get you in!",
                    style: TextStyle(
                      color: ThemeColors.scaffoldBgColor,
                      fontSize: FontSize.xxLarge,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Login to your account.",
                    style: TextStyle(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 75),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///Email Input Field
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (_usernameController.text.isEmpty) {
                            return "This field can't be empty";
                          }
                        },
                        style: TextStyle(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          hintText: "E-mail",
                          hintStyle: TextStyle(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      ///Password Input Field
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (_passwordController.text.isEmpty) {
                            return "This field can't be empty";
                          }
                        },
                        obscureText: true,
                        style: TextStyle(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: ThemeColors.greyTextColor,
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      MainButton(
                        text: 'Login',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            String username = _usernameController.text;
                            String password = _passwordController.text;

                            // Build the login request URL (replace with your actual API endpoint)
                            Uri url = Uri.parse('$baseURL/login');

                            // Prepare the request body
                            Map<String, String> body = {
                              'username': username,
                              'password': password
                            };
                            String jsonBody = jsonEncode(body);

                            try {
                              final response = await http.post(
                                url,
                                body: jsonBody,
                                headers: {"Content-Type": "application/json"},
                              );

                              if (response.statusCode == 200) {
                                var responceBody = jsonDecode(response.body);
                                var sessionId = responceBody["sessionId"];
                                print('Session ID: $sessionId');
                                AuthService().login(sessionId);
                                Navigator.pushNamed(context, chatScreen.id);
                                print('Login successful!');
                              } else {
                                // Handle login error
                                print('Login failed: ${response.body}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Username or password incorrect',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                                _usernameController.clear();
                                _passwordController.clear();
                                // Show error message to the user
                              }
                            } catch (error) {
                              print('Error during login: $error');
                              // Show error message to the user
                            }
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      MainButton(
                        text: 'Login with Google',
                        backgroundColor: ThemeColors.whiteTextColor,
                        textColor: ThemeColors.scaffoldBgColor,
                        iconPath: 'images/google.png',
                        onTap: () {
                          Navigator.pushNamed(context, Chatbot.id);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: ThemeColors.primaryColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
