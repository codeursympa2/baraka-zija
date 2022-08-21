import 'package:flutter/material.dart';
import 'package:test_technique/home.dart';
import 'package:test_technique/services/users_services.dart';
import 'package:test_technique/widgets/user/login.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
   bool isConnect=false;
  connected()async{
    isConnect=await UsersServices().isConnected();
    setState(() {

    });
  }
  @override
  void initState() {
    connected();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isConnect? const Home() : const Login();
  }
}
