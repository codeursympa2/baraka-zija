import 'package:flutter/material.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/services/vehicules_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';
import 'package:test_technique/widgets/vehicules/add_edit_vehicule.dart';
import 'package:test_technique/widgets/vehicules/details_vehicule.dart';

class ListChauffeursVehInv extends StatefulWidget {
  const ListChauffeursVehInv({Key? key,this.id}) : super(key: key);
  final String? id;
  @override
  State<ListChauffeursVehInv> createState() => _ListChauffeursVehInvState();
}

class _ListChauffeursVehInvState extends State<ListChauffeursVehInv> {
  late List<UtilisateurModel> utilisateurs;
  late bool loading;
  getUsers()async{
    utilisateurs=await UsersServices().getChaffeursNoVeh(context);
    loading=false;
    setState(() {

    });
  }

  updateChauffeurVeh(String idConducteur)async{
    await VehiculeServices().updateChaffeurVehicule(context, widget.id!, idConducteur);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsVehicule(chauffeur:idConducteur)));
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
        title: const Text("Choix du chauffeur"),
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
                  if(widget.id != null){
                        updateChauffeurVeh('${utilisateurs[index].id}');
                  }else{
                    Navigator.push(context,MaterialPageRoute(builder: (context)=> AddVehicule(id:utilisateurs[index].id.toString(),))).then((value) => getUsers());
                  }
                },
                trailing: const Icon(Icons.arrow_right),
                title: Text('\nNom et Prénom: $fullname\n'
                    'Date de naissance: ${utilisateurs[index].dateNaiss}\n'
                    'Pseudo: ${utilisateurs[index].login}\n'
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
