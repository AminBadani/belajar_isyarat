import 'package:belajar_isyarat/entitas/kuis/e_kuis.dart';
import 'package:belajar_isyarat/entitas/kuis/e_soal_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_log.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
// ====================================== WOI, BELUM CEK ULANG ========================
import 'dart:math';
import 'package:flutter/foundation.dart';

class KontrolKuis extends ChangeNotifier {
  final Random _acak = Random();
  List<int> _antrianKuis = []; // [0, 0, 0]. maks 3

  bool? _jawabanBenar;
  int _pilihanKotak= 0;
  List<dynamic> _susunanJawaban = [false];

  late EKuis _eKuis; //.semuaSoal[ESoalKuis].id:String,suara:String?,gambar:dynamic,pertanyaan:String,opsi[String]?,jawaban:dynamic,mode:ModeTes{"susun", "pilih", "hubungkan", "lengkapi", "artikan"}

  // ==== inisialisasi ====
  Future<bool> inis(KontrolDatabase kontrolDatabase, KontrolProgress kontrolProgress) async {
    final dataSoal = kontrolProgress.bahasaInggris
      ? await kontrolDatabase.ambilJson('kuis_soal_inggris')
      : await kontrolDatabase.ambilJson('kuis_soal_indo');
      
    _eKuis = EKuis.fromJson(dataSoal);

    inisSoalKuis(kontrolProgress);

    notifyListeners();
    return true;
  }
  void inisSoalKuis(KontrolProgress kontrolProgress) {
    _antrianKuis.clear();

    while (_antrianKuis.length < 3) {
      int kandidat = ambilSoalAcak(kontrolProgress);
      if (!_antrianKuis.contains(kandidat)) {
        _antrianKuis.add(kandidat);
      }
    }
    notifyListeners();
  }
  void bukaMenuKuis(KontrolProgress kontrolProgress) {
    _pilihanKotak= 0;
    _susunanJawaban = [false];
    _jawabanBenar = null;
    _bukaSoalKuis();
  }
  void _bukaSoalKuis() {
    final soal = _eKuis.semuaSoal[ambilAwalAntrianKuis];
    if (soal.mode.name == "susun") {
      _susunanJawaban = soal.opsi;
    } else if (soal.mode.name == "hubungkan") {
      _susunanJawaban = [soal.opsi, soal.gambar];
    } else if (soal.mode.name == "lengkapi") {
      _susunanJawaban = soal.gambar;
    } else if (soal.mode.name == "artikan") {
      _susunanJawaban = [];
      for (var j = 0; j < soal.jawaban.length; j++) {
        _susunanJawaban.add(null);
      }
    } else {
      _susunanJawaban = [false];
    }
  }

  // ==== getter ====
  List<int> get ambilAntrianKuis => _antrianKuis;
  int get ambilAwalAntrianKuis => _antrianKuis.first;
  bool get apaKosongQueueKuis => _antrianKuis.isEmpty;
  int skorKuis(KontrolProgress kProgress) => kProgress.progressKuis;
  bool? get jawabanBenar => _jawabanBenar;

  int get pilihanKotak => _pilihanKotak;
  String get susunanJawabanString => _susunanJawaban.first == false ? "0" : _susunanJawaban.first;
  List<dynamic> get susunanJawabanListDynamic => _susunanJawaban;
  List<String> get susunanJawabanListString {
    if (_susunanJawaban.isEmpty || _susunanJawaban.first == false) {
      return ["0"];
    }
    List<String> hasil = [];
    for (var isi in _susunanJawaban) {
      if (isi is String) {
        hasil.add(isi);
      } 
      else if (isi is List) {
        // flatten list satu level
        hasil.addAll(isi.map((e) => e.toString()));
      }
    }
    return hasil;
  }

  List<List<String>> get susunanJawabanListListString {
    if (_susunanJawaban.isEmpty || _susunanJawaban.first == false) {
      return [
        ["0"],
        ["0"]
      ];
    }

    List<List<String>> hasil = [];

    for (var isi in _susunanJawaban) {
      if (isi is String) {
        hasil.add([isi]);
      }
      else if (isi is List<String>) {
        hasil.add(isi);
      }
      else if (isi is List) {
        // pastikan semua elemen jadi string
        hasil.add(isi.map((e) => e.toString()).toList());
      }
    }

    return hasil;
  }


  bool bolehAjukanKuis() => _susunanJawaban.first == false ? false : true;

  ESoalKuis ambilKuis(int idKuis) {
    return _eKuis.semuaSoal[idKuis - 1];
  }

  int cekNilaiKuis(bool benar) {
    if (benar) {
      return 100;
    }
    return 25;
  }

  int ambilSoalAcak(KontrolProgress kontrolProgress) {
    final total = _eKuis.semuaSoal.length;
    double kemungkinan = 0.20; // awal untuk soal yang belum benar
    double kenaikan = 0.05;
    int kandidat = 0;
    bool masuk = false;

    while (!masuk) {
      kandidat = _pilihAcak(total);
      bool sudahBenar = kontrolProgress.ambilStatusKuis(kandidat);
      double chance = sudahBenar ? 0.80 : kemungkinan;
      double dadu = _acak.nextDouble();
      if (dadu < chance) {
        masuk = true;
      } else {
        kemungkinan = min(0.50, kemungkinan + kenaikan);
      }
    }
    return kandidat; //sudah indeks
  } // perlu pengembangan, terlalu acak (soal salah bisa ketinggalan). utamakan soal yang belum benar.

  bool cekJawaban(dynamic jawaban) {
    final soalSekarang = _eKuis.semuaSoal[ambilAwalAntrianKuis];

    if (soalSekarang.mode.name == "hubungkan") {
      return cekListListPasangan(keListListString(jawaban), keListListString(soalSekarang.jawaban));
    }
    
    final jawabanBenar = soalSekarang.mode.name == "artikan" ? soalSekarang.jawaban.map((j) => j.toString().toUpperCase()).toList() : soalSekarang.jawaban;

    return deepEquals(jawabanBenar, jawaban);
  }

  bool deepEquals(dynamic a, dynamic b) {
    // === 1. Null check ===
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

    // === 2. Primitive check (String, num, bool) ===
    if (a is String && b is String) return a == b;
    if (a is num && b is num) return a == b;
    if (a is bool && b is bool) return a == b;

    // === 3. List check (rekursif) ===
    if (a is List && b is List) {
      if (a.length != b.length) return false;

      for (int i = 0; i < a.length; i++) {
        if (!deepEquals(a[i], b[i])) return false;
      }

      return true;
    }

    // === 4. Jika tipe beda, otomatis false ===
    return false;
  }

  bool cekListListPasangan(List<List<String>> user, List<List<String>> benar) {
    // --- Validasi awal ---
    if (user.length != 2 || benar.length != 2) return false;
    if (user[0].length != user[1].length) return false;
    if (benar[0].length != benar[1].length) return false;
    if (user[0].length != benar[0].length) return false;

    final n = user[0].length;

    // Bentuk set pasangan dari user
    final Set<String> pasanganUser = {};
    for (int i = 0; i < n; i++) {
      pasanganUser.add("${user[0][i]}::${user[1][i]}");
    }

    // Bentuk set pasangan dari jawaban benar
    final Set<String> pasanganBenar = {};
    for (int i = 0; i < n; i++) {
      pasanganBenar.add("${benar[0][i]}::${benar[1][i]}");
    }

    // Cocokkan: semua pasangan user harus ada di pasangan benar
    return pasanganUser.length == pasanganBenar.length &&
          pasanganUser.every((p) => pasanganBenar.contains(p));
  }

  List<List<String>> keListListString(List<dynamic> src) {
    final List<List<String>> hasil = [];

    for (var item in src) {
      if (item is List) {
        hasil.add(item.map((e) => e.toString()).toList());
      } else {
        hasil.add([item.toString()]);
      }
    }

    return hasil;
  }

  bool cekSatuKuisSelesai() {
    return _isFilled(_susunanJawaban);
  }

  bool _isFilled(dynamic value) {
    if (value == null) return false;

    if (value is bool) {
      return value; // harus true
    }

    if (value is String) {
      return value.isNotEmpty; // kosong dianggap belum terisi
    }

    if (value is List) {
      if (value.isEmpty) return false; // list kosong dianggap belum terisi
      for (var item in value) {
        if (!_isFilled(item)) return false;
      }
      return true;
    }

    // untuk tipe lain (mis. int, double, Map) anggap terisi jika bukan null
    return true;
  }

  int _pilihAcak(int total) => _acak.nextInt(total);
  int indeksSoal(int soal) => soal - 1;

  // alat
  int aturPilihanKotak(int pilihan) {
    if (pilihan == _pilihanKotak) {
      _pilihanKotak = 0;
      _susunanJawaban = [false];
      notifyListeners();
    } else {
      _pilihanKotak = pilihan;
      final soal = _eKuis.semuaSoal[ambilAwalAntrianKuis];
      aturSusunanJawabanString(soal.opsi[pilihan - 1] .toString());
    }
    return _pilihanKotak;
  }

  void aturSusunanJawabanKosong() {
    _susunanJawaban.clear();
    _susunanJawaban.add(false);
    notifyListeners();
  }

  void aturSusunanJawabanString(String isi) {
    _susunanJawaban.clear();
    _susunanJawaban.add(isi);
    notifyListeners();
  }

  void aturSusunanJawabanListString(List<String> isi) {
    _susunanJawaban = isi;
    notifyListeners();
  }

  void aturSusunanJawabanListListString(List<List<String>> isi) {
    _susunanJawaban = isi;
    notifyListeners();
  }

  void aturSusunanJawabanListDynamic(List<dynamic> isi) {
    _susunanJawaban = isi;
    notifyListeners();
  }

  int ajukanKuis(KontrolProgress kontrolProgress, KontrolLog kontrolLog, KontrolDatabase kontrolDatabase) {
    if (!cekSatuKuisSelesai()) {
      return 0;
    }

    final soalSekarang = _eKuis.semuaSoal[ambilAwalAntrianKuis];
    final benar = soalSekarang.mode.name == "hubungkan" 
      ? cekListListPasangan(keListListString(_susunanJawaban), keListListString(soalSekarang.jawaban)) 
      : cekJawaban(_susunanJawaban);
    
    kontrolLog.catatLogKuis(idKuis: ambilAwalAntrianKuis, jawabanBenar: benar);
    kontrolProgress.naikkanProgressKuis(ambilAwalAntrianKuis, benar, kontrolDatabase);
    
    notifyListeners();
    return cekNilaiKuis(benar);
  } // TODO: kembangkan pengecekkan soal

  void aturSoalSelanjutnya(KontrolProgress kontrolProgress) {
    if (_antrianKuis.isNotEmpty) {
      _antrianKuis.removeAt(0);
    }
    while (_antrianKuis.length < 3) {
      int kandidat = ambilSoalAcak(kontrolProgress);
      if (!_antrianKuis.contains(kandidat)) {
        _antrianKuis.add(kandidat);
      }
    }
    bukaMenuKuis(kontrolProgress);
    notifyListeners();
  }

  // tutup apk
  void resetAntrianKuis() { // JANGAN dipanggil sembarangan. queue HARUS ada nilai (jangan 0).
    _antrianKuis = [];
    _pilihanKotak= 0;
    _susunanJawaban = [false];
  }
}