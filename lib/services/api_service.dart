import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_gpt/constants/api_constat.dart';
import 'package:chat_gpt/models/chatModel.dart';
import 'package:chat_gpt/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/models"),
          headers: {"Authorization": 'Bearer $API_KEY'});
      Map jsonResponse = jsonDecode(response.body);
      print("response: ${jsonResponse.toString()}");
      List temp = [];
      for (var i in jsonResponse["data"]) {
        temp.add(i);
        // print("temp $i");
      }

      if (jsonResponse["error"] != null) {
        // print("jsonResponse[error] ${jsonResponse["error"]["message"]}");
        throw HttpException(jsonResponse["error"]["message"]);
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (e) {
      print("error:  $e");
      rethrow;
    }
  }

  //send message
  static Future<List<ChatModel>> sendMessage(
      {required String msg, required String modelID}) async {
        List<ChatModel> chatList = [];
    try {
      var response = await http.post(Uri.parse("$BASE_URL/chat/completions"),
          body:
              jsonEncode({
                 "messages": [{"role": "user", "content": msg}],
                "model": modelID,  "max_tokens": 100}),
          headers: {
            "Authorization": 'Bearer $API_KEY',
            "Content-Type": "application/json"
          });
      Map jsonResponse = jsonDecode(response.body);

      print("response: ${jsonResponse.toString()}");

      if (jsonResponse["error"] != null) {
        print("error: ${jsonResponse["error"]["message"].toString()}");
        throw HttpException(jsonResponse["error"]["message"]);
      }
      
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                message: jsonResponse["choices"][index]["message"]["content"], chatIndex: 1));
        // print("jsonResponse[choices] text: : : : ${jsonResponse["choices"][0]["text"]}");
      }
      return chatList;
    } catch (e) {
      print("error from apiService page:  $e");
      rethrow;
    }
  }
}
