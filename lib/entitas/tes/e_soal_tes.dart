enum ModeTes {
  susun,
  pilih,
  hubungkan,
  lengkapi,
  artikan;

  static ModeTes fromString(String value) {
    switch (value) {
      case "susun": return ModeTes.susun;
      case "pilih": return ModeTes.pilih;
      case "hubungkan": return ModeTes.hubungkan;
      case "lengkapi": return ModeTes.lengkapi;
      case "artikan": return ModeTes.artikan;
    }
    throw Exception("Mode tidak dikenal: $value");
  }
}

class ESoalTes {
  final String? suara;
  final List<dynamic> gambar;     // String? | List<String?> | null
  final String pertanyaan;
  final List<dynamic> opsi;
  final List<dynamic> jawaban;    // String | List<String> | List<List<String>>
  final ModeTes mode;

  ESoalTes({
    required this.suara,
    required this.gambar,
    required this.pertanyaan,
    required this.opsi,
    required this.jawaban,
    required this.mode,
  });

  static List<dynamic> normalizeToList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;     // sudah list
    return [value];                       // apa pun selain list dibungkus menjadi list
  }

  factory ESoalTes.fromJson(Map<String, dynamic> json) {
    return ESoalTes(
      suara: json["suara"],
      gambar: normalizeToList(json['gambar']),
      pertanyaan: json["pertanyaan"],
      opsi: normalizeToList(json['opsi']),
      jawaban: normalizeToList(json['jawaban']),
      mode: ModeTes.fromString(json["mode"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "suara": suara,
      "gambar": gambar,
      "pertanyaan": pertanyaan,
      "opsi": opsi,
      "jawaban": jawaban,
      "mode": mode.name,
    };
  }

}
