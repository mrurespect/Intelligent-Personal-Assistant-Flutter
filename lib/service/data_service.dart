import 'dart:convert';
import 'package:chatpotgemini/modele/conversation.dart';
import 'package:chatpotgemini/service/global.dart';
import 'package:http/http.dart' as http;

class DataService {
  static Future<List<Conversation>> getConversation(
      Map<String, String> apiHeaders) async {
    var url = Uri.parse(baseURL + '/conversations');
    http.Response response = await http.get(
      url,
      headers: apiHeaders,
    );
    print("d :" + response.body);
    List responseList = jsonDecode(response.body);
    List<Conversation> conversations = [];
    for (Map<String, dynamic> conversationMap in responseList) {
      Conversation conversation = Conversation.fromMap(conversationMap);
      conversations.add(conversation);
    }
    return conversations;
  }
}
