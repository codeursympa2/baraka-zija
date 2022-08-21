import 'package:async_button_builder/async_button_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/models/vehicule_model.dart';
import 'package:test_technique/path/database_path.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/services/vehicules_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/pdf/read_pdf.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';

class Approvisionnement extends StatefulWidget {
  const Approvisionnement({Key? key,this.chauffeur}) : super(key: key);
  final String? chauffeur;
  @override
  State<Approvisionnement> createState() => _ApprovisionnementState();
}

class _ApprovisionnementState extends State<Approvisionnement> {
  List<dynamic> details=[];
  String path=DatabasePath.getPath();
  late bool loading;
  final _key=GlobalKey<FormState>();
  TextEditingController controller=TextEditingController();
  String fullName="",dateNaiss="",immat="",model="",marque="",nbr_place="",permis="",image="",carburant="";
  String carburantUpd="",idV="";
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
        idV='${details.first['idv']}';


        setState(() {

        });


  }
  appro(VehiculeModel vehiculeModel)async{
    await VehiculeServices().approvisonner(vehiculeModel, context);
  }
  @override
  void initState() {
    loading=true;
    getDetails(details);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return loading ? const LoadingSpin() :Scaffold(
      appBar: AppBar(
        title:const Text("Approvisionnement"),
        centerTitle: true,
        leading: Icon(Icons.local_gas_station),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  ElevatedButton.icon(
                    onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ReadPdf(pdfFileName: permis,)));
                    },
                    label: Text("Voir mon permis de conduire"),
                    icon:const Icon(Icons.remove_red_eye),
                  ),
                  Divider(),
                  const SizedBox(height: 50,),
                  Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType:  TextInputType.numberWithOptions(decimal: true),
                            autofocus: true,
                            controller: controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Carburant/Litre")
                            ),
                            validator: (value) => value!.isEmpty ? "Champs requis *":null,
                            onChanged: (value) => carburantUpd=value,
                        ),
                          const SizedBox(height: 10,),
                          AsyncButtonBuilder(
                            child: const Text("Approvisionner"),
                            loadingWidget:const  Text("Enregistrement"),
                            errorWidget: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.error,
                                )),
                            onPressed: () async {
                              if(_key.currentState!.validate() ){

                                await Future.delayed(Duration(seconds: 1));

                                VehiculeModel veh=VehiculeModel(id: idV,carburant: carburantUpd);
                                //print('\n\n\n${veh.toMapAppro()}\n\n\n');
                                await appro(veh);
                                controller.text="";
                                await getDetails(details);
                                setState(() {

                                });

                              }
                            },
                            builder: (context, child, callback, _) {
                              return ElevatedButton.icon(
                                label: child,
                                onPressed: callback,
                                icon: const Icon(Icons.local_gas_station),
                              );
                            },
                          ),
                        ],
                      ),
                  )
                ],
              ),
            )],
        ),
      ),
    );

  }
}
