class UtilisateurModel{
  String? id;
  String? login;
  String? password;
  String? nom;
  String? prenom;
  String? dateNaiss;
  String? permis;
  String? role;

  UtilisateurModel({this.id, this.login,this.password,this.nom, this.prenom,this.dateNaiss,this.permis,this.role});

  factory UtilisateurModel.fromJson(Map<String,dynamic> i) =>
          UtilisateurModel(
              id:i['id'],
              login: i['login'],
              password: i['password'],
              nom: i['nom'],
              prenom: i['prenom'],
              dateNaiss: i['dateNaiss'],
              permis: i['permis'],
              role: i['role'],
          );

  Map<String,dynamic> toMapChaffeur()=>
      {
        "login": login,
        "password": password,
        "nom": nom,
        "prenom": prenom,
        "dateNaiss": dateNaiss,
        "permis": permis,
        "role": role,
      };

  Map<String,dynamic> toMapChaffeurConnected()=>
      {
        "id":id,
        "login": login,
        "password": password,
        "nom": nom,
        "prenom": prenom,
        "dateNaiss": dateNaiss,
        "permis": permis,
        "role": role,
      };



  Map<String,dynamic> toMapProprietaire() =>
      {
        "login": login,
        "password": password,
        "nom": nom,
        "prenom": prenom,
        "role": "admin",
      };

  }