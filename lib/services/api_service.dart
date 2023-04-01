import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt/constans/api_consts.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {

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
      log("error kek $error");
      rethrow;
    }
  }
}