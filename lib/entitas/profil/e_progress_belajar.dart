import 'package:belajar_isyarat/entitas/profil/e_progress_materi_belajar.dart';

class EProgressBelajar {
  Map<String, EProgressMateriBelajar> modul;

  EProgressBelajar({required this.modul});
  
  factory EProgressBelajar.fromJson(Map<String, dynamic> json) {
    final map = <String, EProgressMateriBelajar>{};

    json.forEach((key, value) {
      map[key] = EProgressMateriBelajar.fromJson(value);
    });

    return EProgressBelajar(modul: map);
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    
    modul.forEach((key, value) {
      data[key] = value.toJson();
    });

    return data;
  }
}