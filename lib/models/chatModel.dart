class ChatModel {
  String message;
  int chatIndex;

  ChatModel({required this.message, required this.chatIndex});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        message: json["message"]["content"], chatIndex: json["index"]);
  }



  static List<ChatModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => ChatModel.fromJson(e)).toList();
  }
}
