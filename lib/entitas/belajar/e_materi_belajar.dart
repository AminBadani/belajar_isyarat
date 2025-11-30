class EMateriBelajar {
  final String? suara;
  final List<String> gambar;  
  final String judul;
  final String penjelasan;

  EMateriBelajar({
    required this.suara,
    required this.gambar,
    required this.judul,
    required this.penjelasan,
  });
  
  factory EMateriBelajar.fromJson(Map<String, dynamic> json) {
    return EMateriBelajar(
      suara: json['suara'],
      gambar: json['gambar'] is String
          ? [json['gambar']]
          : List<String>.from(json['gambar']),
      judul: json['judul'],
      penjelasan: json['penjelasan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suara': suara,
      'gambar': gambar,
      'judul': judul,
      'penjelasan': penjelasan,
    };
  }
}