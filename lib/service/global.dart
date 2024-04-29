import 'package:chatpotgemini/service/AuthService.dart';

const String baseURL = "http://localhost:8080";
const Map<String, String> headers = {"Content-Type": "application/json"};
Map<String, String> ApiHeaders = {"Content-Type": "application/json",'Session-ID': AuthService().getSessionID().toString()};
