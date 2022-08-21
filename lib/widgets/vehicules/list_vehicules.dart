import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_technique/models/vehicule_model.dart';
import 'package:test_technique/path/database_path.dart';
import 'package:test_technique/services/vehicules_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';
import 'package:test_technique/widgets/vehicules/add_edit_vehicule.dart';
import 'package:test_technique/widgets/vehicules/details_vehicule.dart';

class ListVehicules extends StatefulWidget
{
  const ListVehicules({Key? key}) : super(key: key);

  @override
  State<ListVehicules> createState() => _ListVehiculesState();
}

class _ListVehiculesState extends State<ListVehicules> with TickerProviderStateMixin {
  List<VehiculeModel> vehicules=<VehiculeModel>[];
  late bool loading;
  late Timer timer;
  getVehicules()async{
    vehicules=await VehiculeServices().getVehicules(context);
    loading=false;
    setState(() {

    });
  }

  deleteVehicule(String id)async{
    await VehiculeServices().deleteVehicule(context, id);
    setState(() async{
      await getVehicules();
    });
  }

  Widget dialogBuilder(BuildContext context,VehiculeModel vehiculeModel){
    ThemeData localTheme=Theme.of(context);
    String path=DatabasePath.getPath();
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        CachedNetworkImage(
          imageUrl: "$path/images/${vehiculeModel.photo}",
          placeholder: (context, url) =>const  SpinKitCircle(
            color: Colors.green,
            size: 70,
          ),
          height: 150.0,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Padding(padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
              Text(vehiculeModel.marque!.toUpperCase(),textAlign: TextAlign.center,),
              const SizedBox(height: 20.0,),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  children: [
                    FlatButton.icon(
                        onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsVehicule(chauffeur:vehiculeModel.idConducteur.toString()))).then((value) => getVehicules());
                    }, label: const Text("Details"),
                      icon:const  Icon(Icons.edit_calendar_outlined),
                    ),
                    OutlinedButton.icon(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddVehicule(vehicule:vehiculeModel,))).then((value) => getVehicules());
                        },
                        icon: const  Icon(Icons.update),
                        label:const Text("Modifier")
                    )
                  ],
                ),
              )
          ],
        ),
        ),

      ],
    );
  }
  late bool imgLoad;


  //
  @override
  void initState()  {

    super.initState();
    imgLoad=true;


    loading=false;

    if(vehicules.isEmpty){
      loading=false;
      getVehicules();
      setState(() {

      });
    }



  }
  @override
  void dispose() {
    getVehicules();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? const LoadingSpin(): Scaffold(
      appBar: AppBar(
        title: const Text("Liste des vehicules"),
        centerTitle: true,
        leading: const Icon(Icons.local_taxi),
      ),
      endDrawer: const Navbar(),
      body: vehicules.isEmpty? Center(

        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const Text("Pas de vehicules",
            style: TextStyle(
              fontFamily: AutofillHints.addressCity,
              fontSize: 20
            ),
            ),
            const SizedBox(height: 10,),
              ElevatedButton.icon(
                  onPressed: (){
                    Navigator.of(context).pushNamed("/listChauffeursNoVehicules");
                  },
                  icon: const Icon(Icons.drive_eta_sharp),
                  label: const Text("Ajouter"))
            ],
          ),
        ),
      ) :ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        shrinkWrap: true,

        reverse: true,
        itemCount: vehicules.length,
        itemBuilder: (context,index){
          String path=DatabasePath.getPath();
          return    GestureDetector(
            onTap:() => showDialog(context: context,builder:
                  (context) => dialogBuilder(context,vehicules[index])),
            child: Card(
              clipBehavior: Clip.hardEdge,
              shadowColor: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CachedNetworkImage(
                    imageUrl: "$path/images/${vehicules[index].photo}",
                    placeholder: (context, url) =>const  SpinKitCircle(
                      color: Colors.green,
                      size: 70,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(29.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((vehicules[index].marque)!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          vehicules[index].modele!,
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        const SizedBox(height: 30,),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: IconButton(onPressed: (){
                            deleteVehicule(vehicules[index].id.toString());
                          }, icon: const Icon(Icons.delete_forever,
                            size: 40,

                          )
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
