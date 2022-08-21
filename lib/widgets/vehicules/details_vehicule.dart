import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/path/database_path.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/pdf/read_pdf.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';

class DetailsVehicule extends StatefulWidget {
  const DetailsVehicule({Key? key,this.chauffeur}) : super(key: key);
  final String? chauffeur;
  @override
  State<DetailsVehicule> createState() => _DetailsVehiculeState();
}

class _DetailsVehiculeState extends State<DetailsVehicule> {
  List<dynamic> details=[];
  String path=DatabasePath.getPath();
  late bool loading;
  String fullName="",dateNaiss="",immat="",model="",marque="",nbr_place="",permis="",image="",carburant="";
  getDetails(List<dynamic> details)async{
    String id=widget.chauffeur.toString();
    details= await UsersServices().getDetailsChauffeur(id);
    print(details);
    loading=false;


      fullName=('${details.first['nom']}  ${details.first["prenom"]}').toUpperCase();
      dateNaiss=('${details.first['dateNaiss']}');
      immat=('${details.first['immatriculation']}').toUpperCase();
      model=('${details.first['model']}').toUpperCase();
      marque=('${details.first['marque']}').toUpperCase();
      nbr_place=('${details.first['nbr_place']}');
      permis=('${details.first['permis']}');
      image='${details.first['photo']}';
      carburant='${details.first['carburant']}';

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
        title:const Text("Details du vehicule"),
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
        child: Column(
          children:[
            CachedNetworkImage(
              imageUrl: "$path/images/$image",
              placeholder: (context, url) =>const  SpinKitCircle(
                color: Colors.green,
                size: 70,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),
            Container(
              margin:const EdgeInsets.all(30),
              child: Column(
              children:  [
                const SizedBox(height: 20,),
                const Text("INFORMATIONS DU VEHICULE",textAlign: TextAlign.center,
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
                const SizedBox(height: 20,),
                const Text("Carburant:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
                const SizedBox(height: 20,),
                Text('$carburant Litres'),
                const SizedBox(height: 50,),
                const Text("INFORMATIONS DU CHAUFFEUR",textAlign: TextAlign.center,
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

  ],
          ),
            )],
        ),
      ),
    );

  }
}
