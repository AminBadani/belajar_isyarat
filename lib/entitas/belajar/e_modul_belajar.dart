import 'e_materi_belajar.dart';

class EModulBelajar {
  final List<EMateriBelajar> materi;

  EModulBelajar({required this.materi});

  factory EModulBelajar.fromJson(List<dynamic> jsonList) {
    return EModulBelajar(
      materi: jsonList
          .map((e) => EMateriBelajar.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return materi.map((e) => e.toJson()).toList();
  }
}