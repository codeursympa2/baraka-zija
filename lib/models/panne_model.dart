class PanneModel{
  String? id;
  String video;
  String commentaire;
  String idChauffeur;

  PanneModel({this.id,required this.video,required this.commentaire,required this.idChauffeur});

  factory PanneModel.fromJson(Map<String,dynamic> i) =>
      PanneModel(video: i['video'], commentaire: i['commentaire'], idChauffeur: i['idChauffeur']);

  Map<String,dynamic> toMap()=>
      { 'video': video,
        'commentaire': commentaire,
        'chauffeur': idChauffeur
      };
}