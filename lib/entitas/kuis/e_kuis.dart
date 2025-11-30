import 'e_soal_kuis.dart';

class EKuis {
  final List<ESoalKuis> semuaSoal;

  EKuis({required this.semuaSoal});

  factory EKuis.fromJson(List<dynamic> json) {
    return EKuis(
      semuaSoal:
          json.map((e) => ESoalKuis.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return semuaSoal.map((e) => e.toJson()).toList();
  }
}