import 'package:flutter/material.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/pdf/read_pdf.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';

class DetailsChauffeurs extends StatefulWidget {
  const DetailsChauffeurs({Key? key,this.chauffeur}) : super(key: key);
  final UtilisateurModel? chauffeur;
  @override
  State<DetailsChauffeurs> createState() => _DetailsChauffeursState();
}

class _DetailsChauffeursState extends State<DetailsChauffeurs> {
  List<dynamic> details=[];
  late bool loading;
   String fullName="",dateNaiss="",immat="",model="",marque="",nbr_place="",permis="";
  getDetails(List<dynamic> details)async{
    String id=widget.chauffeur!.id.toString();
    details= await UsersServices().getDetailsChauffeur(id);
    print(details);
    loading=false;

    if(details.isEmpty){
      Navigator.pop(context);
      String fullname=(widget.chauffeur!.nom.toString()+" "+widget.chauffeur!.prenom.toString()).toUpperCase();
      Refactoring.toastBottom(context, "$fullname n'a pas encore de voiture.");
    }else{
      fullName=('${details.first['nom']}  ${details.first["prenom"]}').toUpperCase();
      dateNaiss=('${details.first['dateNaiss']}');
      immat=('${details.first['immatriculation']}').toUpperCase();
      model=('${details.first['model']}').toUpperCase();
      marque=('${details.first['marque']}').toUpperCase();
      nbr_place=('${details.first['nbr_place']}');
      permis=('${details.first['permis']}');
      setState(() {

      });
    }
    setState(() {

    });
  }
  @override
  void initState() {

    getDetails(details);
    loading=true;
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return loading ? const LoadingSpin() :Scaffold(
      appBar: AppBar(
        title:const Text("Details du chauffeur"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/listVehicules");
          },
          icon: const Icon(Icons.keyboard_arrow_left,
            size: 40.0,
          ),

        ),

      ),
      endDrawer:const Navbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),

        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 50, 5, 0),
          child: Column(
            children:  [
              const Text("INFORMATIONS PERSONNELLES",textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0
              ),
              ),
              const Divider(),
              const SizedBox(height: 20,),
              const Text("Nom et prénom :",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 20,),
              Text(fullName),
              const SizedBox(height: 20,),
              const Text("Date de naissance:",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              const SizedBox(height: 20,),
              Text(dateNaiss),
              const SizedBox(height: 20,),
              ElevatedButton.icon(
                  onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ReadPdf(pdfFileName: permis,)));
              },
                  label: Text("Voir le permis de conduire"),
                icon:const Icon(Icons.remove_red_eye),
              ),
              const SizedBox(height: 50,),
              const Text("INFORMATIONS TAXI",textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25.0
                ),

              ),
              const Divider(),
              const SizedBox(height: 20,),
              const Text("Model :",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              const SizedBox(height: 20,),
              Text(model),
              const SizedBox(height: 20,),
              const Text("Marque:",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              const SizedBox(height: 20,),
              Text(marque),
              const SizedBox(height: 20,),
              const Text("Nombre de place:",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              const SizedBox(height: 20,),
              Text(nbr_place),
            ],
          ),
        ),
      ),
    );

  }
}
