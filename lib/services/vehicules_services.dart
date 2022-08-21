import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/models/vehicule_model.dart';
import 'package:test_technique/path/database_path.dart';
import 'package:http/http.dart' as http;
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';

class VehiculeServices{
  String path=DatabasePath.getPath();


  VehiculeServices();

  Future<void> addVehicule(BuildContext context,VehiculeModel vehiculeModel)async{
    final response=await http.post(Uri.parse("$path/addVehicule.php"),body:vehiculeModel.toMap());

    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
      Refactoring.toastBottom(context, rep["message"]);
    }else{
      Refactoring.toastBottom(context,"Echec de connexion à la base de données");
    }
  }

  List<VehiculeModel> vehiculeFromJson(String jsonString){
    final data=jsonDecode(jsonString);
    return List<VehiculeModel>.from(data.map((item) => VehiculeModel.fromJson(item)));
  }

  Future<List<VehiculeModel>> getVehicules(BuildContext context)async{
    var u=await UsersServices().getUserConnected();

    final response=await http.get(Uri.parse("$path/listVehicule.php?id=${u.id}"));
    List<VehiculeModel> chaffeurs=<VehiculeModel>[];
    if(response.statusCode==200){
      chaffeurs=vehiculeFromJson(response.body);
    }else{
      Refactoring.toastBottom(context, "Pas de réponse du serveur");
    }
    return chaffeurs;
  }
  Future<void> deleteVehicule(BuildContext context,String id)async{
    final response=await http.get(Uri.parse("$path/deleteVehicule.php?id=$id"));
    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
      Refactoring.toastBottom(context, rep["message"]);
    }else{
      Refactoring.toastBottom(context, "Pas de réponse du serveur");
    }
  }

  Future<void> updateVehicule(BuildContext context,VehiculeModel vehiculeModel)async{
    final response=await http.post(Uri.parse("$path/updateVehicule.php"),body:vehiculeModel.toMapUpd());

    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
      Refactoring.toastBottom(context, rep["message"]);
    }else{
      Refactoring.toastBottom(context,"Echec de connexion à la base de données");
    }
  }

  Future<void> updateChaffeurVehicule(BuildContext context,String id,String idConducteur)async{
    final response=await http.post(Uri.parse("$path/updateChauffeurVehicule.php"),body:{
      "id":id,
      "idConducteur":idConducteur
    });

    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
      Refactoring.toastBottom(context, rep["message"]);
    }else{
      Refactoring.toastBottom(context,"Echec de connexion à la base de données");
    }
  }

  Future<void> approvisonner(VehiculeModel vehiculeModel,BuildContext context)async{
    final response=await http.post(Uri.parse("$path/appro.php"),body:
        vehiculeModel.toMapAppro()
    );
    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
      Refactoring.toastBottom(context, rep["message"]);
    }else{
      Refactoring.toastBottom(context,"Echec de connexion à la base de données");
    }
  }

}