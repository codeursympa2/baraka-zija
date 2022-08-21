import 'package:flutter/material.dart';
import 'package:test_technique/models/utilisateur_model.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/navbar/navbar.dart';
import 'package:test_technique/widgets/spinkit/loading_spin.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String fullname="";
  late bool load;
  getFullname()async{
    UtilisateurModel utilisateurModel=await UsersServices().getUserConnected();
    setState(() {
      fullname='${utilisateurModel.nom!} ${utilisateurModel.prenom!}';
      load=false;
    });
  }

  @override
  void initState() {
    load=true;
    getFullname();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return load ?const LoadingSpin(): Scaffold(
      appBar: AppBar(
        title: Text("Gestion des vehicules"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: const Icon(Icons.home) ,
      ),
      endDrawer: const Navbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           const Text("Bienvenue",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10,),
            Text(fullname.toUpperCase(),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
                color: Colors.green
            ),
              textAlign: TextAlign.center,
            )

          ],
        ),
      ),
    );
  }
}
