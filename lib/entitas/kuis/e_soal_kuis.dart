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

class ESoalKuis {
  final int id;
  final String? suara;
  final List<dynamic> gambar;
  final String pertanyaan;
  final List<dynamic> opsi;
  final List<dynamic> jawaban;
  final ModeTes mode;

  ESoalKuis({
    required this.id,
    required this.suara,
    required this.gambar,
    required this.pertanyaan,
    required this.opsi,
    required this.jawaban,
    required this.mode,
  });

  /// helper untuk memastikan bentuk selalu List<dynamic>
  static List<dynamic> normalizeToList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value;     // sudah list
    return [value];                       // apa pun selain list dibungkus menjadi list
  }

  factory ESoalKuis.fromJson(Map<String, dynamic> json) {
    return ESoalKuis(
      id: json['id'],
      suara: json['suara'],
      gambar: normalizeToList(json['gambar']),
      pertanyaan: json['pertanyaan'],
      opsi: normalizeToList(json['opsi']),
      jawaban: normalizeToList(json['jawaban']),
      mode: ModeTes.fromString(json['mode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "suara": suara,
      "gambar": gambar,
      "pertanyaan": pertanyaan,
      "opsi": opsi,
      "jawaban": jawaban,
      "mode": mode.name,
    };
  }
}