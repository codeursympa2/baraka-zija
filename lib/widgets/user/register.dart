import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/services/pj/add_pj.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:date_field/date_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
import 'package:async_button_builder/async_button_builder.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _key=GlobalKey<FormState>();

  //
  String login="",password="",passwordConf="",nom="",prenom="";

  //
  TextEditingController loginController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();
  TextEditingController passwordConfController=new TextEditingController();
  TextEditingController nomController=new TextEditingController();
  TextEditingController prenomController=new TextEditingController();

  //


  //
  addChaffeur(UtilisateurModel chauffeur)async{
    await UsersServices().addProprietaire(context,chauffeur);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ouverture d'un compte"),
        centerTitle: true,
        leading:const Icon(Icons.account_circle),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:const EdgeInsets.fromLTRB(10, 50, 10, 8),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:  [
                TextFormField(
                  controller:loginController ,
                  decoration:const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Identifiant")
                  ),
                  onChanged: (value) => login=value,
                  autofocus: true,
                  validator: (value) => value!.isEmpty ? "Champs requis":null,
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text("Mot de passe"),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => password=value,
                  validator: (value) => value!.isEmpty ? "Champs requis" : null,
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: passwordConfController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text("Confirmation mot de passe"),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => passwordConf=value,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Champs requis";
                    }else if(value != password){
                      return "Mot de passe de confirmation incorrect";
                    }
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: nomController,
                  decoration:const InputDecoration(
                      label: Text("Nom"),
                      border: OutlineInputBorder()
                  ),
                  onChanged: (value) => nom=value,
                  validator: (value) => value!.isEmpty ? "Champs requis" : null,
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: prenomController,
                  decoration:const InputDecoration(
                      label: Text("Prénom"),
                      border: OutlineInputBorder()
                  ),
                  onChanged: (value) => prenom=value,
                  validator: (value) => value!.isEmpty ? "Champs requis":null,
                ),
                const SizedBox(height: 17,),


                const SizedBox(height: 20,),
                AsyncButtonBuilder(
                  child: const Text("Enregistrer"),
                  loadingWidget:const  Text("Enregistrement"),
                  errorWidget: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.error,
                      )),
                  onPressed: () async {

                    if(_key.currentState!.validate() ){

                        await Future.delayed(Duration(seconds: 4));
                        UtilisateurModel chauffeur=UtilisateurModel(login: login, password: password, nom: nom, prenom: prenom, role:"admin");
                        await addChaffeur(chauffeur);
                        Navigator.of(context).pushNamed("/");

                    }
                  },
                  builder: (context, child, callback, _) {
                    return ElevatedButton.icon(
                      label: child,
                      onPressed: callback,
                      icon: const Icon(Icons.save),
                      style:  ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15),
                          )),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
