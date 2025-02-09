import 'dart:convert';

import 'package:chatpotgemini/botMessage.dart';
import 'package:chatpotgemini/conversation_screen.dart';
import 'package:chatpotgemini/modele/message.dart';
import 'package:chatpotgemini/userMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';

class chatScreen extends StatefulWidget {
  static String id = 'chatscreen';
  const chatScreen({super.key});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

Future<String> generateResponse(String prompt) async {
  var url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCdXlRkJFYqrOGd4Pry2W0KlrrZiMKF6GE');
  var headers = {
    "Content-Type": "application/json",
  };

  var requestBody = {
    "contents": [
      {
        "parts": [
          {"text": prompt}
        ]
      }
    ]
  };

  final response = await http.post(
    url,
    headers: headers,
    body: json.encode(requestBody),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    String generatedText =
        responseBody['candidates'][0]['content']['parts'][0]['text'];

    return generatedText;
  } else {
    throw Exception('Échec de la demande à l\'API de Gemini');
  }
}

class _chatScreenState extends State<chatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isloading;

  @override
  void initState() {
    super.initState();
    isloading = false;
    speechToText = SpeechToText();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  FlutterTts flutterTts = FlutterTts();
  late SpeechToText speechToText;

  var text = "";
  var isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 2, 45, 0.957),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(60.0),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add,
              size: 27,
              color: Colors.white,
            ),
          ),
        ],
        title: Text(
          'ChatBot',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ConversationScreen(),
      ),
      backgroundColor: Color.fromRGBO(233, 224, 169, 0.969),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  var message = _messages[index];
                  if (message.sender == Sender.bot) {
                    return BotMessage(
                      text: message.text,
                      sender: message.sender,
                    );
                  } else {
                    return UserMessage(
                      text: message.text,
                      sender: message.sender,
                    );
                  }
                },
              ),
            ),
            Visibility(
              visible: isloading,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(color: Colors.white),
                      controller: _textController,
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(2, 2, 45, 0.957),
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !isloading,
                    child: Container(
                      color: Color.fromRGBO(2, 2, 45, 0.957),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              color: Color.fromRGBO(10, 129, 139, 0.722),
                              size: 32,
                            ),
                            onPressed: () async {
                              setState(() {
                                _messages.add(
                                  ChatMessage(
                                    text: _textController.text,
                                    sender: Sender.user,
                                  ),
                                );
                                isloading = true;
                              });
                              var input = _textController.text;
                              _textController.clear();
                              Future.delayed(
                                Duration(milliseconds: 50),
                              ).then((_) => _scrollDown());
                              generateResponse(input).then(
                                (value) => {
                                  setState(
                                    () {
                                      isloading = false;
                                      _messages.add(
                                        ChatMessage(
                                          text: value,
                                          sender: Sender.bot,
                                        ),
                                      );
                                    },
                                  ),
                                },
                              );
                              _textController.clear();
                              Future.delayed(
                                Duration(milliseconds: 50),
                              ).then((_) => _scrollDown());
                            },
                          ),
                          AvatarGlow(
                            animate: isListening,
                            duration: Duration(milliseconds: 2000),
                            repeat: true,
                            glowColor: Color.fromRGBO(10, 129, 139, 0.722),
                            child: GestureDetector(
                              onTapDown: (details) async {
                                if (!isListening) {
                                  bool available =
                                      await speechToText.initialize();
                                  if (available) {
                                    setState(() {
                                      isListening = true;
                                      _textController.text = "";
                                    });
                                    speechToText.listen(
                                      onResult: (result) {
                                        setState(() {
                                          _textController.text =
                                              result.recognizedWords;
                                        });
                                      },
                                      cancelOnError: true,
                                      onDevice: () async {
                                        setState(() {
                                          isListening = false;
                                          _textController.text = "";
                                        });
                                      },
                                    );
                                  } else {
                                    print("Speech recognition not available");
                                  }
                                }
                              },
                              onTapUp: (details) async {
                                setState(() {
                                  isListening = false;
                                  _messages.add(
                                    ChatMessage(
                                      text: _textController.text,
                                      sender: Sender.user,
                                    ),
                                  );
                                  isloading = true;
                                });
                                var input = _textController.text;
                                generateResponse(input).then(
                                  (value) async {
                                    setState(() {
                                      isloading = false;
                                      _messages.add(
                                        ChatMessage(
                                          text: value,
                                          sender: Sender.bot,
                                        ),
                                      );
                                    });
                                    flutterTts.speak(value);
                                    _textController.clear();
                                    _scrollDown();
                                  },
                                );
                                speechToText.stop();
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(10, 129, 139, 0.722),
                                child: Icon(
                                  isListening ? Icons.mic : Icons.mic_none,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
