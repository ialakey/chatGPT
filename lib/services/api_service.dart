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
      List<ChatModel> chatList = [];
      if (modelId == "gpt-3.5-turbo") {
        var response = await http.post(
          Uri.parse("$BASE_URL/chat/completions"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            'Content-Type': 'application/json'},
          body: jsonEncode(
            {
              "model": modelId,
              "messages": [
                {
                  "role": "user",
                  "content": message
                }
              ]
            },
          ),
        );

        Map jsonResponse = jsonDecode(response.body);

        if (jsonResponse['error'] != null) {
          log(jsonResponse['error']['message']);
          throw HttpException(jsonResponse['error']['message']);
        }
        if (jsonResponse['choices'].length > 0) {
          chatList = List.generate(jsonResponse['choices'].length,
                (index) => ChatModel(
              msg: jsonResponse['choices'][index]['message']['content'],
              chatIndex: 1,
            ),
          );
      }
    } else {
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
        if (jsonResponse['choices'].length > 0) {
          chatList = List.generate(jsonResponse['choices'].length,
                (index) =>
                ChatModel(
                  msg: jsonResponse['choices'][index]['text'],
                  chatIndex: 1,
                ),
          );
        }
      }
      return chatList;
  } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}