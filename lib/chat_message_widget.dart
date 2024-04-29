import 'package:chatpotgemini/modele/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final Sender sender;

  const ChatMessageWidget({
    super.key,
    required this.text,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      color: sender == Sender.bot ? Color(0xFF444654) : Color(0xFF343541),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sender == Sender.bot
              ? Container(
                  margin: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    child: Icon(
                      CupertinoIcons.add_circled,
                      color: Colors.white,
                      size: 30,
                    ),
                    backgroundColor: Color.fromRGBO(16, 163, 127, 1),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    child: Icon(CupertinoIcons.person_alt),
                    backgroundColor: Color(0xFF444654),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
