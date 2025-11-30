class EProfil {
  String? nama;
  String? sekolah;
  String? jabatan;
  List<int> progressBelajar;
  List<int> nilaiTes;
  int progressKuis;

  EProfil({
    this.nama,
    this.sekolah,
    this.jabatan,
    required this.progressBelajar,
    required this.progressKuis,
    required this.nilaiTes,
  });
  
  factory EProfil.fromJson(Map<String, dynamic> json) {
    return EProfil(
      nama: json['nama'],
      sekolah: json['sekolah'],
      jabatan: json['jabatan'],
      progressBelajar: List<int>.from(json['progress_belajar']),
      nilaiTes: List<int>.from(json['nilai_tes_modul']),
      progressKuis: json['progress_kuis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'sekolah': sekolah,
      'jabatan': jabatan,
      'progress_belajar': progressBelajar,
      'nilai_tes_modul': nilaiTes,
      'progress_kuis': progressKuis,
    };
  }
}