import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constans/constants.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({Key? key}) : super(key: key);

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String currentModel = "Model1";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: scaffoldBackgroundColor,
      iconEnabledColor: Colors.white,
      items: [],
      value: currentModel,
      onChanged: (value) {
        setState(() {
          currentModel = value.toString();
        });
      }
    );
  }
}
