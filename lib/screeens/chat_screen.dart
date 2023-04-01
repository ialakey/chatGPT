import 'package:chatgpt/constans/constants.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:chatgpt/services/assets_manager.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = true;

  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = [
      {
        "msg": "Hello",
        "chatIndex": 0,
      },
      {
        "msg": "Hello, I'm chatGPT",
        "chatIndex": 1,
      },
    ];
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
                itemCount: 2,
                itemBuilder: (context, index){
                  return ChatWidget(
                    msg: chatMessages[index]["msg"].toString(),
                    chatIndex: int.parse(
                        chatMessages[index]["chatIndex"].toString()),
                  );
                })
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,),
              SizedBox(height: 15,),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white
                          ),
                          controller: textEditingController,
                          onSubmitted: (value){

                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How can I help you",
                              hintStyle: TextStyle(
                                  color: Colors.grey
                              )),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            await ApiService.getModels();
                          } catch(error) {
                            print(error);
                          }
                        },
                        icon: const Icon(Icons.send), color: Colors.white,),
                    ],
                  ),
                ),
              )
            ]
        ],
      ),),
    );
  }
}
