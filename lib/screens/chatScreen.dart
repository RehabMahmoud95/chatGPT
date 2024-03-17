import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/models/chatModel.dart';
import 'package:chat_gpt/providers/chatProvider.dart';
import 'package:chat_gpt/providers/modelsProvider.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:chat_gpt/services/srvices.dart';
import 'package:chat_gpt/widgets/chatWidget.dart';
import 'package:chat_gpt/widgets/textWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController message;
  bool _isTyping = false;
  // List<ChatModel> chatList = [];
  late ScrollController scrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    message = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    message.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "ChatGPT",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await Services.showModalSheet(context: context);
                },
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ))
          ],
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openAILogo),
          )),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: chatProvider.getChatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                        chatProvider.getChatList[index].message.toString(),
                        chatProvider.getChatList[index].chatIndex);
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            Material(
              color: cardColor,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      focusNode: focusNode,
                      controller: message,
                      style: TextStyle(color: Colors.grey),
                      onSubmitted: (val) async {
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider);
                      },
                      decoration: InputDecoration.collapsed(
                          hintText: "How can I help you",
                          hintStyle: TextStyle(color: Colors.grey)),
                    )),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider);
                      },
                      icon: Icon(Icons.send),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textEditingController', message));
  }

  Future<void> sendMessageFCT(
      {required modelsProvider, required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "you can't send multiple message at a time"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (message.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "please type your message"),
        backgroundColor: Colors.blue,
      ));
      return;
    }
    try {
      String msg = message.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(userMsg: msg);
        // chatList.add(ChatModel(message: message.text, chatIndex: 0));
        message.clear();
        // focusNode.unfocus();
      });
      chatProvider.addGPTMessage(
          GPTMsg: msg, chosenModelId: modelsProvider.currentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //     msg: message.text, modelID: modelsProvider.currentModel));
      setState(() {});
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: e.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollToTheEnd();
        _isTyping = false;
      });
    }
  }

  void scrollToTheEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2), curve: Curves.easeOut);
  }
}
