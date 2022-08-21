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


class AddChauffeur extends StatefulWidget {
  const AddChauffeur({Key? key}) : super(key: key);

  @override
  State<AddChauffeur> createState() => _AddChauffeurState();
}

class _AddChauffeurState extends State<AddChauffeur> {
  final _key=GlobalKey<FormState>();

  //
  String login="",password="",passwordConf="",nom="",prenom="",dateNaiss="",permisString="Aucun fichier choisi",pdfData="";

  //
  TextEditingController loginController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();
  TextEditingController passwordConfController=new TextEditingController();
  TextEditingController nomController=new TextEditingController();
  TextEditingController prenomController=new TextEditingController();

  //
  void selectPdf()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if(result != null) {
      PlatformFile file = result.files.first;
      if(file.extension == "pdf"){
        permisString=file.name;
        pdfData=file.path!;
        setState(() {

        });
        print(file.name);
      }else{
        Refactoring.toastBottom(context, "Format de fichier invalide");
        permisString="Aucun fichier choisi";
        setState(() {

        });
      }
    } else {
      Refactoring.toastBottom(context, "Pas de fichier selectionné");
      permisString="Aucun fichier choisi";
      setState(() {

      });
    }
  }

  sendPdf(fichier)async{
      await AddPj.add(fichier,"pdf");
  }

  //
  addChaffeur(UtilisateurModel chauffeur)async{
    await UsersServices().addChauffeur(context,chauffeur);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajout d'un chauffeur"),
        centerTitle: true,
        leading:const Icon(Icons.drive_eta_rounded),
      ),
      endDrawer:const Navbar(),
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
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.greenAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Date de naissance',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (val) => val == null ? 'Champs requis' : null,
                  initialValue: DateTime(1980),
                  onDateSelected: (DateTime value) {
                    dateNaiss='${value.year}/${value.month}/${value.day}';
                  },
                ),
                const SizedBox(height: 10,),
                OutlinedButton.icon(
                    onPressed: (){
                      selectPdf();
                    },
                    label:const Text("Permis de conduire"),
                    icon:const Icon(Icons.folder),
                ),
                const SizedBox(height: 10,),
                Text(permisString,
                textAlign: TextAlign.center,
                ),
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
                      if(permisString == "Aucun fichier choisi"){
                        Refactoring.toastBottom(context, "Veillez choisir un permis de conduire.");
                      }else{
                        await Future.delayed(Duration(seconds: 4));
                        UtilisateurModel chauffeur=UtilisateurModel(login: login, password: password, nom: nom, prenom: prenom, role:"chauffeur",dateNaiss: dateNaiss,permis: permisString);
                       await addChaffeur(chauffeur);
                       await sendPdf(pdfData);
                       Navigator.of(context).pushNamed("/listChauffeurs");
                      }
                    }
                  },
                  builder: (context, child, callback, _) {
                    return ElevatedButton.icon(
                      label: child,
                      onPressed: callback,
                      icon: const Icon(Icons.save),
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
