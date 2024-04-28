import 'package:chatpotgemini/message.dart';
import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  final String text;
  final Sender sender;

  const UserMessage({
    super.key,
    required this.text,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(233, 224, 169, 0.969),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(10, 129, 139, 0.722),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/user.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
