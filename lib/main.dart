import 'package:flutter/material.dart';
import 'package:test_technique/index.dart';
import 'package:test_technique/widgets/pannes/add_panne.dart';
import 'package:test_technique/widgets/pdf/read_pdf.dart';
import 'package:test_technique/widgets/user/chauffeur/addChauffeur.dart';
import 'package:test_technique/widgets/user/chauffeur/appro.dart';
import 'package:test_technique/widgets/user/chauffeur/details_chaffeur.dart';
import 'package:test_technique/widgets/user/chauffeur/listChaufeurs.dart';
import 'package:test_technique/widgets/user/login.dart';
import 'package:test_technique/widgets/user/register.dart';
import 'package:test_technique/widgets/vehicules/add_edit_vehicule.dart';
import 'package:test_technique/widgets/vehicules/list_chauffeurs_no_vehicules.dart';
import 'package:test_technique/widgets/vehicules/list_vehicules.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Vehicules',
      theme: ThemeData(
        primarySwatch: Colors.green,
        buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary
        ),
        buttonColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
          '/': (context) => const Index(),
          '/login': (context) => const Login(),
          '/register': (context) => const Register(),
          '/addChauffeur': (context) => const AddChauffeur(),
          '/listChauffeurs': (context) => const ListChauffeurs(),
          '/detailsChauffeur': (context) => const DetailsChauffeurs(),
          '/viewPdf': (context) => const ReadPdf(),
          '/addVehicule': (context) => const AddVehicule(),
          '/listChauffeursNoVehicules': (context) => const ListChauffeursVehInv(),
          '/listVehicules': (context) => const ListVehicules(),
          '/addPanne': (context) => const AddPanne(),
          '/appro': (context) => const Approvisionnement(),

      },
      initialRoute: '/',
    );
  }
}


