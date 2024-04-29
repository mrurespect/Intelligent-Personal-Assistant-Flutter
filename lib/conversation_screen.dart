import 'package:chatpotgemini/modele/conversation.dart';
import 'package:chatpotgemini/service/data_service.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late Future<List<Conversation>> _conversations;

  @override
  void initState() {
    super.initState();
    _conversations = getConversation();
  }

  Future<List<Conversation>> getConversation() async {
    return DataService.getConversation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Conversation>>(
      future: _conversations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Conversations'),
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Conversation conversation = snapshot.data![index];
                return Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(conversation.name),
                );
              },
            ),
          );
        }
      },
    );
  }
}
