import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/path/database_path.dart';
import 'package:http/http.dart' as http;
import 'package:test_technique/widgets/refact/refactoring.dart';

class UsersServices{
  String path=DatabasePath.getPath();


  UsersServices();
  
  Future<void> addChauffeur(BuildContext context,UtilisateurModel utilisateurModel)async{
    final response=await http.post(Uri.parse("$path/addUserChauffeur.php"),body:utilisateurModel.toMapChaffeur());

    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
         Refactoring.toastBottom(context, rep["message"]);
    }else{
      Refactoring.toastBottom(context,"Echec de connexion à la base de données");
    }
  }

  Future<void> addProprietaire(BuildContext context,UtilisateurModel utilisateurModel)async{
    final response=await http.post(Uri.parse("$path/addUserProprietaire.php"),body:utilisateurModel.toMapProprietaire());

    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
        Refactoring.toastBottom(context, rep["message"]);

    }else{
      Refactoring.toastBottom(context,"Echec de connexion à la base de données");
    }
  }


  List<UtilisateurModel> chauffeurFromJson(String jsonString){
    final data=jsonDecode(jsonString);
    return List<UtilisateurModel>.from(data.map((item) => UtilisateurModel.fromJson(item)));
  }

  Future<List<UtilisateurModel>> getChaffeurs(BuildContext context)async{
    final response=await http.get(Uri.parse("$path/listChauffeurs.php"));
    List<UtilisateurModel> chaffeurs=<UtilisateurModel>[];
    if(response.statusCode==200){
      chaffeurs=chauffeurFromJson(response.body);
    }else{
      Refactoring.toastBottom(context, "Pas de réponse du serveur");
    }
    return chaffeurs;
  }
  Future<List<UtilisateurModel>> getChaffeursNoVeh(BuildContext context)async{
    final response=await http.get(Uri.parse("$path/getListChaufNoVeh.php"));
    List<UtilisateurModel> chaffeurs=<UtilisateurModel>[];
    if(response.statusCode==200){
      chaffeurs=chauffeurFromJson(response.body);
    }else{
      Refactoring.toastBottom(context, "Pas de réponse du serveur");
    }
    return chaffeurs;
  }

  Future<List<dynamic>> getDetailsChauffeur(String id)async{
    List<dynamic> details=[];

    final response=await http.get(Uri.parse("$path/getDetailsChauffeur.php?id=$id"));

    if(response.statusCode==200){
      var rep=jsonDecode(response.body);
      if(rep!= null){
          details=rep;
      }
    }
    return details;
  }

  Future<void> login(String login,String password,BuildContext context)async{
    final response=await http.post(Uri.parse("$path/login.php"),body:{
      "login":login,
      "password":password
    });

    if(response.statusCode==200){
       var rep=jsonDecode(response.body);
       Refactoring.toastBottom(context, rep["message"]);

       //print(rep["data"]);
       if(rep["data"] != null){
         UtilisateurModel u=UtilisateurModel.fromJson(rep["data"]);
          setUserSession(u);
          Navigator.of(context).pushNamed("/");
       }
    }

  }

  Future<void> logout(BuildContext context)async{
    await SessionManager().destroy();
  }


  void setUserSession(UtilisateurModel utilisateurModel)async{
      await SessionManager().set("user", jsonEncode(utilisateurModel.toMapChaffeurConnected()));
  }

  Future<UtilisateurModel> getUserConnected()async{
    UtilisateurModel u=UtilisateurModel();
    var rep=await SessionManager().get("user");
    u=UtilisateurModel.fromJson(rep);
    return u;
  }

  Future<bool> isConnected()async{
    var user=await SessionManager().get("user");
    if(user != null){
      return true;
    }
    return false;
  }
 }