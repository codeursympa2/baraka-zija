import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:test_technique/services/users_services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //
  String login="",password="";
  //Controllers
  TextEditingController loginController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  //
  loginUser(BuildContext context,String login,String password)async{
    await UsersServices().login(login, password, context);
  }


  @override
  void initState() {
    super.initState();
  }
  final _key=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.green,
                padding: const EdgeInsets.all(36),
                child: const Text(
                    "Gestion Vehicules",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white

                  ),
                ),
              ),
              const SizedBox(height: 50,),
                TextFormField(
                  controller: loginController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    label: Text("Identifiant"),
                      iconColor: Colors.green,
                      icon: Icon(Icons.people),
                    border:OutlineInputBorder()
                  ),
                  validator: (value) => value!.isEmpty ? "Champs requis":null,
                  onChanged: (value) => login=value,
                ),

             const SizedBox(height: 10,),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  iconColor: Colors.green,
                  label: Text("Mot de passe"),
                  border: OutlineInputBorder()
                ),
                validator: (value) => value!.isEmpty ? "Champs requis":null,
                onChanged: (value) => password=value,
              ),

              const SizedBox(height: 20,),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AsyncButtonBuilder(
                  child: const Text("Se connecter"),
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
                      icon: const Icon(Icons.login),
                    );
                  },
                  onPressed: () async {
                    if ( _key.currentState!.validate()) {
                      await Future.delayed(const Duration(seconds: 5));
                      await loginUser(context, login, password);
                    }else{
                      //await Future.delayed(const Duration(seconds: 1));
                    }
                  },

                ),
               const SizedBox(height: 20,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text("Vous n'avez pas de compte ?"),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                          Navigator.of(context).pushNamed("/register");
                     },
                     child: const Text("Ouvrir mon compte",
                     style: TextStyle(
                       color: Colors.red,
                       fontWeight: FontWeight.bold
                     ),
                     ),
                   )
                 ],
               )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
