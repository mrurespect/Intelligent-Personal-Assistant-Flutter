import 'package:chatpotgemini/chat_screen.dart';
import 'package:chatpotgemini/components/main_button.dart';
import 'package:chatpotgemini/helpers/font_size.dart';
import 'package:chatpotgemini/helpers/theme_colors.dart';
import 'package:chatpotgemini/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's get you in!",
                  style: TextStyle(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
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
                SizedBox(height: 70),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Username",
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                        ),
                      ),
                      SizedBox(height: 16),
                      MainButton(
                        text: 'Login',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            String username = _usernameController.text;
                            String password = _passwordController.text;
                            Uri url = Uri.parse('http://10.0.2.2:8080/login');
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
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .setUserLoggedIn(true);
                                Navigator.pushNamed(context, chatScreen.id);
                                print('Login successful!');
                              } else {
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
                              }
                            } catch (error) {
                              print('Error during login: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'An error occurred. Please try again later.',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
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
                          Navigator.pushNamed(context, chatScreen.id);
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

class AuthProvider with ChangeNotifier {
  bool _userLoggedIn = false;

  bool get userLoggedIn => _userLoggedIn;

  void setUserLoggedIn(bool value) {
    _userLoggedIn = value;
    notifyListeners(); // Notify listeners when the user login state changes
  }
}
