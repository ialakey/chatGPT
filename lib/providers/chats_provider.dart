import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:flutter/foundation.dart';

class ChatsProvider with ChangeNotifier{
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(
        msg: msg,
        chatIndex: 0
    ));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswer({required String msg, required chooseModelId}) async {
    chatList.addAll(
        await ApiService.sendMessage(
          message: msg,
          modelId: chooseModelId,
        ));
    notifyListeners();
  }
}