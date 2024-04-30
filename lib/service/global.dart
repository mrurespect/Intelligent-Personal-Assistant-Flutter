import 'package:chatpotgemini/service/AuthService.dart';

const String baseURL = "http://10.0.2.2:8080";
const Map<String, String> headers = {"Content-Type": "application/json"};

Future<Map<String, String>> getApiHeaders() async {
  String? sessionId = await AuthService().getSessionID();
  if (sessionId != null) {
    return {
      "Content-Type": "application/json",
      'Session-ID': sessionId,
      'Cookie': 'JSESSIONID=$sessionId'
    };
  } else {
    // Gérer le cas où l'ID de session n'est pas disponible
    // Par exemple, vous pouvez renvoyer des en-têtes par défaut ou lever une exception.
    return {
      "Content-Type": "application/json",
    };
  }
}
