import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';
import 'package:test_technique/widgets/user/chauffeur/details_chaffeur.dart';

class ListChauffeurs extends StatefulWidget
{
  const ListChauffeurs({Key? key}) : super(key: key);

  @override
  State<ListChauffeurs> createState() => _ListChauffeursState();
}

class _ListChauffeursState extends State<ListChauffeurs> {
  late List<UtilisateurModel> utilisateurs;
  late bool loading;
  getUsers()async{
    utilisateurs=await UsersServices().getChaffeurs(context);
    loading=false;
    setState(() {

    });
  }

  @override
  void initState()  {

    super.initState();

    getUsers();
    loading=true;


  }
  @override
  Widget build(BuildContext context) {
    return loading ? const LoadingSpin(): Scaffold(
      appBar: AppBar(
        title: const Text("Liste des chauffeurs"),
        centerTitle: true,
        leading: const Icon(Icons.drive_eta_rounded),
      ),
      endDrawer: const Navbar(),
      body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
          shrinkWrap: true,
          reverse: true,
          itemCount: utilisateurs.length,
          itemBuilder: (context,index){
            String fullname='${utilisateurs[index].nom} ${utilisateurs[index].prenom}'.toUpperCase();
            return   Card(
              elevation: 40,
              color: Colors.green,
              shadowColor: Colors.black,

              child: Padding(
                padding: EdgeInsets.all(0),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> DetailsChauffeurs(chauffeur:utilisateurs[index] ,))).then((value) => getUsers());
                  },
                  trailing: const Icon(Icons.arrow_right),
                  title: Text('Nom et Prénom: $fullname\n'
                      'Date de naissance: ${utilisateurs[index].dateNaiss}\n'
                      'Pseudo: ${utilisateurs[index].login}'
                    ,style: const TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),


              ),
            );
          },
      ),
    );
  }
}
