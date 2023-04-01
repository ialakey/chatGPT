import 'package:chatgpt/models/models_model.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "babbage";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String chooseModel) {
    currentModel = chooseModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}