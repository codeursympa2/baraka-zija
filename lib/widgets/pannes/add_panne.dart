import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:test_technique/models/panne_model.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/services/pannes_services.dart';
import 'package:test_technique/services/pj/add_pj.dart';
import 'package:test_technique/services/users_services.dart';



import 'dart:io';
import 'package:test_technique/widgets/camera/camera.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/refact/refactoring.dart';
class AddPanne extends StatefulWidget {

  const AddPanne({Key? key,}): super(key: key);

  @override
  State<AddPanne> createState() => _AddPanneState();
}

class _AddPanneState extends State<AddPanne> {

  TextEditingController commentaireController=new TextEditingController();
  String commentaire='',chauffeur='',videString='';


  final _keyForm=GlobalKey<FormState>();
  String titre="Signalement  d'une panne";
  UtilisateurModel u=UtilisateurModel();


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
  final _commentaireVideoController = TextEditingController();
  final _titreImageController = TextEditingController();
  final _commentaireImageController = TextEditingController();

  getImageSession()async{
    return  await SessionManager().get("imagePath");
  }
  getVideoSession()async{
    return  await SessionManager().get("videoPath");
  }

  addPj()async{
    List<String> pj=[];
    var  videoPathSession=await getVideoSession();
    pj.add(videoPathSession);
    await AddPj.add(videoPathSession, "vid");
  }

  addPanne(PanneModel panneModel)async{
    await PanneServices().addPannne(panneModel, context);
  }

  getUser()async{
    u=await UsersServices().getUserConnected();
    setState(() {

    });

    print(u.toMapChaffeurConnected());
  }
  @override
  void initState() {

    super.initState();
    getUser();
    //Camera
    _controller.addListener(() => _extension = _controller.text);
    _titreImageController.text = '';
    _titreVideoController.text = '';
    _commentaireVideoController.text = '';
    _commentaireImageController.text = '';
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
    return Scaffold(
      endDrawer: const Navbar(),
      appBar: AppBar(
        title: Text(titre),
        centerTitle: true,
        leading: const Icon(Icons.taxi_alert),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 22, 8, 4),

        child: Center(
          child: Form(
              key: _keyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: commentaireController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        label: Text("Commentaire"),
                        border: OutlineInputBorder()
                    ),
                    onChanged: (val) => commentaire = val,
                    validator: (val) => val!.isEmpty ? 'Champs requis':null,
                  ),
                  const SizedBox(height: 20,),
                  const Text("Pièce jointe",
                  textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8,),
                  Column(
                    children: cameraPlace,
                  ),
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

                        var videoPathSession = await SessionManager().get("videoPath");
                        videoPath = await videoPathSession;

                        await setWidgetToCameraPlace(videoPath);


                      },

                        icon: const Icon(Icons.switch_video) ,
                        label:const Text("Camera"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50,),
                  AsyncButtonBuilder(
                    child: Text("Enregistrer"),
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
                    onPressed: () async{
                      if ( _keyForm.currentState!.validate()) {
                        String videoPathSession=await getVideoSession();
                        if(videoPathSession.isNotEmpty){
                          await Future.delayed(const Duration(seconds: 4));
                          var fileName = (videoPathSession.split('/').last);
                          print(fileName);
                          setState(() {

                          });

                          PanneModel panneModel=PanneModel(video: fileName, commentaire: commentaire, idChauffeur: u.id!);

                          await addPanne(panneModel);
                          addPj();
                          getSessionValues();
                          Navigator.of(context).pushNamed("/");
                        }else{
                          Refactoring.toastBottom(context, "Veillez capturer une video.");
                        }
                      }else{
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {

                        });
                      }
                    },

                  ),
                ],

              )
          ),
        ),
      ),
    );
  }
  setWidgetToCameraPlace(videoPathSession) async {

    if(videoPathSession != '' && videoPathSession != null){
      videoPath = videoPathSession;
      _videoPlayerController = await VideoPlayerController.file(File(videoPath))
        ..initialize().then((value) => setState(() {}));

      _customVideoPlayerController = await CustomVideoPlayerController(
        context: context,
        videoPlayerController: _videoPlayerController,
        customVideoPlayerSettings: _customVideoPlayerSettings,
      );

      cameraPlace = [];
      cameraPlace.add(
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Text(
                'Vidéo',
              ),
            ),
          )
      );

      cameraPlace.add(
        Divider(
          color: Colors.grey,
        ),
      );
      cameraPlace.add(
        CustomVideoPlayer(
          customVideoPlayerController: CustomVideoPlayerController(
            context: context,
            videoPlayerController: _videoPlayerController,
            customVideoPlayerSettings: _customVideoPlayerSettings,
          ),
        ),
      );


      cameraPlace.add(
        SizedBox(height: 20,),
      );
      cameraPlace.add(
        Text(videString,
          textAlign: TextAlign.center,
        )
      );
    }
  }
}
