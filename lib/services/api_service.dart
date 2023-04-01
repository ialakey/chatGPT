import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt/constans/api_consts.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {

  //Get models
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
          Uri.parse("$BASE_URL/models"),
      headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        log(jsonResponse['error']['message']);
        throw HttpException(jsonResponse['error']['message']);
      }
      List tempList = [];
      for (var data in jsonResponse['data']) {
        tempList.add(data);
      }
      return ModelsModel.modelsFromSnapshot(tempList);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  //Send message
  static Future<List<ChatModel>> sendMessage({required String message, required String modelId}) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          'Content-Type': 'application/json'},
        body: jsonEncode(
          {
          "model": modelId,
          "prompt": message,
          "max_tokens": 100
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        log(jsonResponse['error']['message']);
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse['choices'].length > 0) {
        //log("text ${jsonResponse['choices'][0]['text']}");
        chatList = List.generate(jsonResponse['choices'].length,
          (index) => ChatModel(
            msg: jsonResponse['choices'][index]['text'],
            chatIndex: 1,
        ),
      );
    }
    return chatList;
  } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}