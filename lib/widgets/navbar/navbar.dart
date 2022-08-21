
import 'package:flutter/material.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';
import 'package:test_technique/widgets/user/chauffeur/appro.dart';
import 'package:test_technique/widgets/vehicules/list_chauffeurs_no_vehicules.dart';


class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {

  UtilisateurModel u=UtilisateurModel();
  String role="",id="";
  bool load=true,addChauffeur=true,listChauffeurs=true,addVehicule=true,listVehicules=true,signaler=true,appro=true;


  getRole()async{
    u=await UsersServices().getUserConnected();
    print(u.toMapChaffeurConnected());
    if(u != null){
      role=u.role!;


      print('$role----------------');
      if(role == "chauffeur"){
        id=u.id!;
        addChauffeur=false;
        listChauffeurs=false;
        listVehicules=false;
        addVehicule=false;
        load=false;
        setState(() {

        });
      }else if (role == "admin"){
        appro=false;
        signaler=false;
        load=false;
        setState(() {

        });
      }

    }

  }

  @override
  void initState() {
    getRole();
    //;
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return load ? const LoadingSpin() :  Drawer(
        semanticLabel:"Ouvrir",
        child: Container(
          color: Colors.green,
          child: ListView(
            children:  [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      child: const Text(
                        "GESTION VEHICULES",
                        style: TextStyle(
                            fontSize: 27,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Visibility(
                      visible: addChauffeur,
                      child: Column(
                        children: [
                          const SizedBox(height: 34,),
                          buildMenuItem(
                            text:'Ajouter un chauffeur',
                            icon: Icons.drive_eta_sharp,
                            onClicked: ()=> selectItem(context,0)
                        ),
                        ]
                      ),
                    ),
                    Visibility(
                      visible: listChauffeurs,
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          buildMenuItem(
                            text:'Liste des chauffeurs',
                            icon: Icons.drive_eta_outlined,
                            onClicked: ()=> selectItem(context,1)
                        )],
                      ),
                    ),
                    Visibility(
                      visible: addVehicule,
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          buildMenuItem(
                            text:'Ajouter un vehicule',
                            icon: Icons.drive_eta,
                            onClicked: ()=> selectItem(context,2)

                        )],
                      ),
                    ),
                    Visibility(
                      visible: listVehicules,
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          buildMenuItem(
                            text:'Liste des vehicules',
                            icon: Icons.local_taxi_sharp,
                            onClicked: ()=> selectItem(context,3)
                        )],
                      ),
                    ),

                    Visibility(
                      visible: signaler,
                      child: Column(
                        children: [
                          const SizedBox(height: 34,),
                          buildMenuItem(
                            text:'Signaler une panne',
                            icon: Icons.car_repair_outlined,
                            onClicked: ()=> selectItem(context,4)

                        )],
                      ),
                    ),
                    Visibility(
                      visible: appro,
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          buildMenuItem(
                            text:'Approvisionner carburant',
                            icon: Icons.energy_savings_leaf,
                            onClicked: ()=> selectItem(context,5)
                        )],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    buildMenuItem(
                        text:'Aides',
                        icon: Icons.help,
                        onClicked: ()=> selectItem(context,6)
                    ),
                    const SizedBox(height: 15,),
                    const Divider(color: Colors.white,),
                    const SizedBox(height: 24,),
                    buildMenuItem(
                        text:u.login!.toUpperCase(),
                        icon: Icons.account_circle,
                        onClicked: ()=> selectItem(context,7)
                    ),
                    const SizedBox(height: 15,),
                    buildMenuItem(
                        text:'Se déconnecter',
                        icon: Icons.logout,
                        onClicked: ()=> selectItem(context,8)
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  Widget buildMenuItem({required String text, required IconData icon,VoidCallback?  onClicked}) {
    const color= Colors.white;
    return
      Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon,color:color),
          title: Text(text, style: const TextStyle( color: color),),
          onTap: onClicked
          ,
        ),


      );
  }

  void selectItem(BuildContext context,int i) async {
    Navigator.of(context).pop();
    switch(i){
      case 0:
        Navigator.of(context).pushNamed("/addChauffeur");
        break;
      case 1:
        Navigator.of(context).pushNamed("/listChauffeurs");
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ListChauffeursVehInv()));
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed("/listVehicules");
        break;

      case 4:
        print('$id----------&&&&------');

        Navigator.of(context).pushReplacementNamed("/addPanne");

        break;

      case 5:

          Navigator.push(context, MaterialPageRoute(builder: (context)=> Approvisionnement(chauffeur: u.id!,)));

        break;
      case 6:
        Navigator.of(context).pushReplacementNamed("/");
        break;
      case 7:
        Navigator.of(context).pushReplacementNamed("/");
        break;
      case 8:
        UsersServices().logout(context);
        Navigator.of(context).pushReplacementNamed("/");
        Refactoring.toastBottom(context, "Vous êtes deconnecté(e)");
        break;

    }

  }
}
