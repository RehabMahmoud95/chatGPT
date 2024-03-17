import 'package:chat_gpt/models/chatModel.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:flutter/foundation.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String userMsg}) {
    chatList.add(ChatModel(message: userMsg, chatIndex: 0));
    notifyListeners();
  }

  void addGPTMessage(
      {required String GPTMsg, required String chosenModelId}) async {
    await ApiService.sendMessage(msg: GPTMsg, modelID: chosenModelId)
        .then((value) {
      print("send message result :::::::::::::::::::::: " + value.toString());
    chatList.addAll(value);

    });

    notifyListeners();
  }
}
