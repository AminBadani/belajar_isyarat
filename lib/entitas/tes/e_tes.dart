import 'e_modul_tes.dart';

class ETes {
  final Map<String, EModulTes> modul;

  ETes({required this.modul});

  factory ETes.fromJson(Map<String, dynamic> json) {
    final map = <String, EModulTes>{};

    json.forEach((key, value) {
      map[key] = EModulTes.fromJson(value);
    });

    return ETes(modul: map);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    modul.forEach((key, value) {
      map[key] = value.toJson();
    });

    return map;
  }
}