import 'dart:developer';

import 'package:chatgpt/constans/constants.dart';
import 'package:chatgpt/providers/chats_provider.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _listScrollController;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatsProvider = Provider.of<ChatsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset(AssetsManager.openaiLogo),
        // ),
        title: const Text("ChatGPT created by Alakey"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded), color: Colors.white),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(child:
            ListView.builder(
              controller: _listScrollController,
              itemCount: chatsProvider.getChatList.length,
              itemBuilder: (context, index){
                return ChatWidget(
                  msg: chatsProvider.getChatList[index].msg,
                  chatIndex: chatsProvider.getChatList[index].chatIndex,
                );
              })
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
                ),],
              const SizedBox(height: 15,),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(
                              color: Colors.white
                          ),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessage(
                              modelsProvider: modelsProvider,
                              chatsProvider: chatsProvider,
                            );
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How can I help you?",
                              hintStyle: TextStyle(
                                  color: Colors.grey
                              )),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await sendMessage(
                            modelsProvider: modelsProvider,
                            chatsProvider: chatsProvider,
                          );
                        },
                        icon: const Icon(Icons.send), color: Colors.white,),
                    ],
                  ),
                ),
              ),
          ],
      ),),
    );
  }

  void _scrollList() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut
    );
  }

  Future<void> sendMessage({required ModelsProvider modelsProvider, required ChatsProvider chatsProvider}) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "Please type a message",),
        backgroundColor: Colors.red,
      ));
    }
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "You cant send messages",),
        backgroundColor: Colors.red,
      ));
    }
    try {
      String message = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatsProvider.addUserMessage(msg: message);
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatsProvider.sendMessageAndGetAnswer(
          msg: message,
          chooseModelId: modelsProvider.getCurrentModel
      );
      setState((){});
    } catch(error) {
      log("error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: TextWidget(label: error.toString(),),
          backgroundColor: Colors.red,
        ));
    } finally {
      setState(() {
        _scrollList();
        _isTyping = false;
      });
    }
  }
}
