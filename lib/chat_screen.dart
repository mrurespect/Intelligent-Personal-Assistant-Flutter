import 'dart:convert';

import 'package:chatpotgemini/botMessage.dart';
import 'package:chatpotgemini/chat_message_widget.dart';
import 'package:chatpotgemini/message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class chatScreen extends StatefulWidget {
  const chatScreen({super.key});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

Future<String> generateResponse(String prompt) async {
  var url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCfTgntKaMcEp7hpkggDOgSsjEJyNEk6nQ');

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
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(100.0),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            size: 27,
            color: Colors.white,
          ),
        ),
        title: Text(
          'ChatBot',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  var message = _messages[index];
                  if (message.sender == Sender.user) {
                    return BotMessage(
                      text: message.text,
                      sender: message.sender,
                    );
                  } else {
                    return ChatMessageWidget(
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
                        fillColor: Color(0xFF444654),
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
                      color: Color(0xFF444654),
                      child: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: Color.fromRGBO(142, 142, 160, 1),
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
                                        text: value, sender: Sender.bot),
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
