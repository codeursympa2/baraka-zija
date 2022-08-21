import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_technique/path/database_path.dart';
class AddPj{
  static Future<void> add(fichier,String param)async{
    String path=DatabasePath.getPath();
    var request = http.MultipartRequest('POST',Uri.parse("$path/addPhoto.php?p=$param"));

    request.files.add(await http.MultipartFile.fromPath('fichier', fichier));
    var res = await request.send();

    if(res.statusCode == 200){
      var responseString = await res.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print(decodedMap);
    }else{
      print("Echec de l'envoie. -----------------------");
    }
  }
}