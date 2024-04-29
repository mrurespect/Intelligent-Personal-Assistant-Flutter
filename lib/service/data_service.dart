import 'dart:convert';

import 'package:chatpotgemini/modele/conversation.dart';
import 'package:chatpotgemini/service/global.dart';
import 'package:http/http.dart' as http;

class DataService {
  static Future<List<Conversation>> getConversation() async {
    var url = Uri.parse(baseURL + '/conversations');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    print(response.body);
    List responseList = jsonDecode(response.body);
    List<Conversation> conversations = [];
    for (Map conversationMap in responseList) {
      Conversation conversation = Conversation.fromMap(conversationMap);
      conversations.add(conversation);
    }
    return conversations;
  }
}
