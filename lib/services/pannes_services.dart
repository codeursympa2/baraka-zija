import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_technique/models/panne_model.dart';
import 'package:test_technique/path/database_path.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
class PanneServices{
  String path=DatabasePath.getPath();
  PanneServices();

  Future<void> addPannne(PanneModel panneModel,BuildContext context)async{
    final response=await http.post(Uri.parse("$path/addPanne.php"),body: panneModel.toMap());

    if(response.statusCode == 200){
        var rep=jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        Refactoring.toastBottom(context,rep["message"]);
    }else{
      // ignore: use_build_context_synchronously
      Refactoring.toastBottom(context, "Echec de la requete");
    }
  }
}