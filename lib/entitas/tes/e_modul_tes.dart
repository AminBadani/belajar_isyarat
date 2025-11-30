import 'e_soal_tes.dart';

class EModulTes {
  final List<ESoalTes> semuaSoal;

  EModulTes({required this.semuaSoal});

  factory EModulTes.fromJson(List<dynamic> jsonList) {
    return EModulTes(
      semuaSoal: jsonList
          .map((e) => ESoalTes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

   List<dynamic> toJson() {
    return semuaSoal.map((e) => e.toJson()).toList();
  }
}