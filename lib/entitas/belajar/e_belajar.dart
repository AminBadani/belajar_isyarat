import 'e_modul_belajar.dart';

class EBelajar {
  final Map<String, EModulBelajar> modul;

  EBelajar({required this.modul});

  factory EBelajar.fromJson(Map<String, dynamic> json) {
    final modulMap = <String, EModulBelajar>{};

    json.forEach((key, value) {
      modulMap[key] = EModulBelajar.fromJson(value);
    });

    return EBelajar(modul: modulMap);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    modul.forEach((key, value) {
      data[key] = value.toJson();
    });
    
    return data;
  }
}