class VehiculeModel{
  String? id;
  String? immatriculation;
  String? modele;
  String? marque;
  String? nbre_place;
  String? carburant;
  String? photo;
  String? idProp;
  String? idConducteur;


  VehiculeModel(
      { this.id,
        this.immatriculation,
         this.modele,
        this.marque,
         this.nbre_place,
        this.carburant,
        this.photo,
         this.idProp,
         this.idConducteur}
      );

  factory VehiculeModel.fromJson(Map<String,dynamic> i)=>
      VehiculeModel(
          id: i['id'],
          immatriculation: i['immatriculation'],
          modele: i['model'],
          marque: i['marque'],
          nbre_place: i['nbr_place'],
          carburant: i['carburant'],
          photo: i['photo'],
          idProp: i['idProp'],
          idConducteur: i['idConducteur']
      );

  Map<String,dynamic>toMapUpd()=>
      {
          "id":id,
          "immat" : immatriculation,
          "model": modele,
          "marque": marque,
          "nbr_place": nbre_place,
          "carburant": carburant,
          "photo": photo,
          "idProp": idProp,
          "idConducteur": idConducteur
      };

   Map<String,dynamic>toMap()=>
      {
        "immat" : immatriculation,
        "model": modele,
        "marque": marque,
        "nbr_place": nbre_place,
        "carburant": carburant,
        "photo": photo,
        "idProp": idProp,
        "idConducteur": idConducteur
      };


  Map<String,dynamic>toMapAppro()=>
      {
        "carburant": carburant,
        "id": id,
      };
}