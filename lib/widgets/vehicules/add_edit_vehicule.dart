import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/models/vehicule_model.dart';
import 'package:test_technique/path/database_path.dart';
import 'package:test_technique/services/pj/add_pj.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/services/vehicules_services.dart';
import 'package:test_technique/widgets/camera/camera.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/pannes/add_panne.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';
import 'package:test_technique/widgets/vehicules/list_chauffeurs_no_vehicules.dart';
import 'package:test_technique/widgets/vehicules/list_vehicules.dart';

class AddVehicule extends StatefulWidget {
  const AddVehicule({Key? key,this.vehicule,this.id,this.mode}) : super(key: key);
  final VehiculeModel? vehicule;
  final String? id;
  final String? mode;
  @override
  State<AddVehicule> createState() => _AddVehiculeState();
}

class _AddVehiculeState extends State<AddVehicule> {

  TextEditingController immatController=new TextEditingController(),
      modeleController=new TextEditingController(),
      marqueController=new TextEditingController(),
      nbre_placeController=new TextEditingController(),
      carburantController=new TextEditingController();
  String immat='',modele='',marque='',nbrePlace='',carburant='',submitButtonText="Enregistrer",
      imageString="",imageData="",idProp="",idConducteur="";
  late bool showError,showSuccess;

  bool editMode=false;
  final _keyForm=GlobalKey<FormState>();
  String titre="Ajout d'un Véhicule";
  late bool load;
  //update
  String fullName="",dateNaiss="",permis="";
  List<dynamic> details=[];

  UtilisateurModel u=UtilisateurModel();

  Future<void> getDetails(List<dynamic> details)async{

    if(widget.vehicule != null){
      String id=widget.vehicule!.idConducteur!;
      print(id);

      if(widget.mode == "update"){
        print(widget.id);
        details= await UsersServices().getDetailsChauffeur("2");
      }else{
        details= await UsersServices().getDetailsChauffeur(id);
      }

      print(details);

     if(details.isNotEmpty){
       fullName=('${details.first['nom']}  ${details.first["prenom"]}').toUpperCase();
       dateNaiss=('${details.first['dateNaiss']}');
       permis=('${details.first['permis']}');
       setState(() {

         load=false;
         //Chargement du photo/update
         setWidgetToCameraPlace(image: widget.vehicule?.photo.toString());
       });
     }

    }
  }

  getUser()async{
    u=await UsersServices().getUserConnected();
    setState(() {

    });

    print(u.toMapChaffeurConnected());
  }

  void selectImage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg','png'],
    );
    if(result != null) {
      PlatformFile file = result.files.first;
      if(file.extension == "jpg" || file.extension == "png"){
        imageString=file.name;
        imageData=file.path!;
        setState(() {

        });
        await SessionManager().set("imagePath", imageData);
        var imagePathSession = await SessionManager().get("imagePath");
        imagePath = await imagePathSession;
        await setWidgetToCameraPlace(imagePathSession:imagePath,videoPathSession:videoPath);
      }else{
        Refactoring.toastBottom(context, "Format de fichier invalide");
        imageString="Aucun fichier choisi";
        cameraPlace.clear();
        setState(() {

        });
      }
    } else {
      Refactoring.toastBottom(context, "Pas de fichier selectionné");
      imageString="Aucun fichier choisi";
      cameraPlace.clear();
      setState(() {

      });
    }
  }

  sendImage(fichier)async{
    await AddPj.add(fichier,"pdf");
  }


  add(VehiculeModel vehiculeModel,BuildContext context)async{
    await  VehiculeServices().addVehicule(context, vehiculeModel);
  }


  update(VehiculeModel vehiculeModel,BuildContext context)async{
    await  VehiculeServices().updateVehicule(context, vehiculeModel);
    Navigator.of(context).pushNamed("/listVehicules");
  }



  //Camera

  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
  const CustomVideoPlayerSettings(
    controlBarAvailable: true,
  );

  String imagePath='';
  String videoPath='';
  List<Widget> cameraPlace = [];

  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();
  bool iosStyle = true;


  Future getSessionValues() async{
    await SessionManager().set("imagePath", '');
    await SessionManager().set("videoPath", '');
  }

  final _titreVideoController = TextEditingController();
  final _titreImageController = TextEditingController();

  getImageSession()async{
    return  await SessionManager().get("imagePath");
  }
  getVideoSession()async{
    return  await SessionManager().get("videoPath");
  }

  addPj()async{
    List<String> pj=[];
    var imagePathSession=await getImageSession();

    late dynamic pjElement;
    if(imagePathSession != null){
      pjElement=imagePathSession;
    }

    AddPj.add(pjElement, "img");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    load=false;

    showSuccess=false;
    showError=false;
    imageString="Aucun fichier choisi";

    getUser();
    if(widget.vehicule != null){

      setState(() {
        load=true;
        submitButtonText="Modifier";
        titre="Mis à jour d'un vehicule";
        var vehicule=widget.vehicule;
        immatController.text=vehicule!.immatriculation!;
        immat=vehicule.immatriculation!;
        modeleController.text=vehicule.modele!;
        modele=vehicule.modele!;
        marqueController.text=vehicule.marque!;
        marque=vehicule.marque!;
        nbre_placeController.text=vehicule.nbre_place!;
        nbrePlace=vehicule.nbre_place!;
        carburantController.text=vehicule.carburant!;
        carburant=vehicule.carburant!;
        idProp=vehicule.idProp!;
        idConducteur=vehicule.idConducteur!;
        imageString=vehicule.photo!;
      });
      getDetails(details);


    }else{

    }


    //Camera
    _controller.addListener(() => _extension = _controller.text);
    _titreImageController.text = '';
    _titreVideoController.text = '';
    getSessionValues();

  }

  @override
  void dispose() {

    try{
      _videoPlayerController.dispose();
    }catch(e){
      print(e);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return load ? const LoadingSpin() :Scaffold(
      endDrawer: const Navbar(),
      appBar: AppBar(
        title: Text(titre),
        centerTitle: true,
        leading: const Icon(Icons.local_taxi_rounded),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 22, 8, 4),

        child: Form(
            key: _keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: immatController,
                  decoration: const InputDecoration(
                      label: Text("Immatriculation"),
                      border: OutlineInputBorder()
                  ),
                  onChanged: (val) => immat = val,
                  validator: (val) => val!.isEmpty ? 'Champs requis':null,
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  autofocus: true,
                  controller: modeleController,
                  decoration: const InputDecoration(
                      label: Text("Model"),
                      border: OutlineInputBorder()
                  ),
                  onChanged: (val) => modele = val,
                  validator: (val) => val!.isEmpty ? 'Champs requis':null,
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  autofocus: true,
                  controller: marqueController,
                  decoration: const InputDecoration(
                      label: Text("Marque"),
                      border: OutlineInputBorder()
                  ),
                  onChanged: (val) => marque = val,
                  validator: (val) => val!.isEmpty ? 'Champs requis':null,
                ),

                const SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  autofocus: true,
                  controller: nbre_placeController,
                  decoration: const InputDecoration(
                      label: Text("Nombre de places"),
                      border: OutlineInputBorder()
                  ),
                  onChanged: (val) => nbrePlace = val,
                  validator: (val) => val!.isEmpty ? 'Champs requis':null,
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  keyboardType:  TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  controller: carburantController,
                  decoration: const InputDecoration(
                      label: Text("Carburant"),
                      border: OutlineInputBorder()
                  ),
                  onChanged: (val) => carburant = val,
                  validator: (val) => val!.isEmpty ? 'Champs requis':null,
                ),
                const SizedBox(height: 20,),
                const Text("Ajout pièce jointe",textAlign: TextAlign.center,),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(onPressed:   ()async{
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallCamera(),
                        ),
                      );

                      var imagePathSession = await SessionManager().get("imagePath");
                      var videoPathSession = await SessionManager().get("videoPath");
                      imagePath = await imagePathSession;
                      videoPath = await videoPathSession;
                      await setWidgetToCameraPlace(imagePathSession: imagePath,videoPathSession: videoPath);
                      imageString= (imagePathSession?.split('/').last);
                      setState(() {

                      });
                    },

                      icon: const Icon(Icons.camera_alt) ,
                      label:const Text("Camera"),
                    ),
                    SizedBox(width: 5,),
                    OutlinedButton.icon(onPressed:   ()async{
                            selectImage();

                    },

                      icon: const Icon(Icons.folder) ,
                      label:const Text("Parcourir"),
                    ),

                  ],
                ),
                const SizedBox(height: 20,),
                Column(
                  children: cameraPlace,
                ),
                const SizedBox(height: 50,),
                AsyncButtonBuilder(
                  child: Text(submitButtonText),
                  showError: showError,
                  showSuccess: showSuccess,
                  errorWidget: const Icon(Icons.error_outline),
                  successWidget: const Icon(Icons.check_circle_rounded),
                  builder: (context, child, callback, _) {
                    return ElevatedButton.icon(
                      label: child,
                      style:  ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(15),
                      )),
                      onPressed: callback,
                      icon: const Icon(Icons.save),
                    );
                  },
                  onPressed: () async {
                    if ( _keyForm.currentState!.validate()) {
                      if(imageString !="Aucun fichier choisi"){
                        await Future.delayed(const Duration(seconds: 6));
                        if(widget.vehicule == null){
                          var imagePathSession=await getImageSession();
                          late dynamic pjElement;
                          if(imagePathSession != null){
                            pjElement=imagePathSession;
                            imageString = (pjElement?.split('/').last);
                          }
                          VehiculeModel vehicule=VehiculeModel(immatriculation: immat, modele: modele,carburant: carburant, marque: marque, nbre_place: nbrePlace, photo: imageString, idProp: u.id!, idConducteur: widget.id.toString());
                          print(vehicule.toMap());
                          add(vehicule,context);
                          addPj();
                          showSuccess=true;
                          setState(() {

                          });
                          Navigator.push(context, MaterialPageRoute(builder:(context)=>ListVehicules()));
                        }else{
                          String i=widget.vehicule!.photo!;
                          var imagePathSession=await getImageSession();
                          late dynamic pjElement;
                          if(imagePathSession != null){
                            pjElement=imagePathSession;
                            i = (pjElement?.split('/').last);
                            setState(() {

                            });
                          }

                          VehiculeModel veh=VehiculeModel(immatriculation: immat, modele: modele, marque: marque,id:widget.vehicule!.id, nbre_place: nbrePlace,carburant: carburant, photo: i, idProp: idProp, idConducteur: idConducteur);
                          if(i.isEmpty){
                            veh=VehiculeModel(immatriculation: immat, modele: modele, marque: marque,id:widget.vehicule!.id, nbre_place: nbrePlace,carburant: carburant, photo: widget.vehicule!.photo, idProp: idProp, idConducteur: idConducteur);
                          }

                          update(veh, context);
                          var imageSession=await getImageSession();
                          if(imageSession != null){
                            addPj();
                          }
                        }
                      }else{
                        Refactoring.toastBottom(context, "Veillez prendre ou choisir une image.");
                      }
                    }else{
                      await Future.delayed(const Duration(seconds: 1));
                      showError=true;
                      setState(() {

                      });
                    }
                  },

                ),
                const SizedBox(
                  height: 10,
                )
              ],

            )
        ),
      ),
    );
  }
  setWidgetToCameraPlace({dynamic? imagePathSession,dynamic? videoPathSession, String? image}) async {

    if(imagePathSession != '' && imagePathSession!=null){
      setState(() {
        cameraPlace = [];
        imagePath = imagePathSession;
          cameraPlace.add(
            Column(
              children: [
                SizedBox(
                  child: Image.file(File(imagePathSession)),
               ),
                const SizedBox(height: 10,),
                Text(imageString,
                  textAlign: TextAlign.center,
                ),
          ]));

      });
      if(widget.vehicule !=null){
        viewInfosChauff();
      }

    }
    if(widget.vehicule != null){
      var pathDb=DatabasePath.getPath();
      setState(() {
        imageString=image!;
        cameraPlace.add(
            Column(
              children: [
                CachedNetworkImage(
                imageUrl: "$pathDb/images/$image",
                placeholder: (context, url) =>const  SpinKitCircle(
                  color: Colors.green,
                  size: 70,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
                const SizedBox(height: 10,),
                Text(imageString,
                  textAlign: TextAlign.center,
                ),
            ])
        );
      });
      viewInfosChauff();
    }

  }
  void viewInfosChauff(){
    cameraPlace.add(
        Column(
          children: [
            Divider(),
            SizedBox(height: 20,),
            const Text("CHAUFFEUR DU VEHICULE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.green
            ),
            ),
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
                onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ListChauffeursVehInv(id: widget.vehicule!.id,)));
                },
                icon: const Icon(Icons.person_remove_outlined),
                label: const Text("Changer"),
            ),
            const Divider(),

          ],
        )
    );
  }
}
