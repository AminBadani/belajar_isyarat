import 'package:belajar_isyarat/entitas/kuis/e_kuis.dart';
import 'package:belajar_isyarat/entitas/kuis/e_soal_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
// ====================================== WOI, BELUM CEK ULANG ========================
import 'dart:math';
import 'package:flutter/foundation.dart';

class KontrolKuis extends ChangeNotifier {
  final Random _acak = Random();
  int _skorKuis = 0;
  List<int> _antrianKuis = []; // [0, 0, 0]. maks 3

  bool? _jawabanBenar;
  int _pilihanKotak= 0;
  List<dynamic> _susunanJawaban = [false];

  late EKuis _eKuis; //.semuaSoal[ESoalKuis].id:String,suara:String?,gambar:dynamic,pertanyaan:String,opsi[String]?,jawaban:dynamic,mode:ModeTes{"susun", "pilih", "hubungkan", "lengkapi", "artikan"}

  // ==== inisialisasi ====
  Future<bool> inis(KontrolDatabase kontrolDatabase, KontrolProgress kontrolProgress) async {
    final dataSoal = await kontrolDatabase.ambilJson('kuis_soal');
    _eKuis = EKuis.fromJson(dataSoal);

    inisSoalKuis(kontrolProgress);
    _skorKuis = kontrolProgress.progressKuis;

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
  void bukaMenuKuis() {
    _pilihanKotak= 0;
    _susunanJawaban = [false];
    _jawabanBenar = null;
    _bukaSoalKuis();
  }
  void _bukaSoalKuis() {
    final soal = _eKuis.semuaSoal[ambilAwalAntrianKuis];
    switch (soal.mode.name) {
      case "susun": 
        _susunanJawaban.clear();
        _susunanJawaban = soal.opsi;
        break;
    }
  }

  // ==== getter ====
  List<int> get ambilAntrianKuis => _antrianKuis;
  int get ambilAwalAntrianKuis => _antrianKuis.first;
  bool get apaKosongQueueKuis => _antrianKuis.isEmpty;
  int get skorKuis => _skorKuis;
  bool? get jawabanBenar => _jawabanBenar;

  int get pilihanKotak => _pilihanKotak;
  String get susunanJawabanString => _susunanJawaban.first == false ? "0" : _susunanJawaban.first;
  List<dynamic> get susunanJawabanListDynamic => _susunanJawaban;
  List<String> get susunanJawabanListString {
    if (_susunanJawaban.first == false) {
      return ["0"];
    }
    List<String> susunan = [];
    for (var isi in _susunanJawaban) {
      susunan.add(isi.toString());
    }
    return susunan;
  }
  List<List<String>> get susunanJawabanListListString {
    if (_susunanJawaban.first == false) {
      return [["0"], ["0"]];
    }
    List<List<String>> susunan = [];
    for (var isi in _susunanJawaban) {
      susunan.add(isi);
    }
    return susunan;
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
    final jawabanBenar = _eKuis.semuaSoal[ambilAwalAntrianKuis].jawaban;

    return deepEqualsString(jawabanBenar, jawaban);
  }

  bool deepEqualsString(dynamic a, dynamic b) { // String | List<String> | List<List<String>>. harusnya di tools.
    if (a == null && b == null) return true;

    if (a == null || b == null) return false;

    if (a is String && b is String) return a == b;

    if (a is List && b is List) {
      if (a.length != b.length) return false;

      for (int i = 0; i < a.length; i++) {
        if (!deepEqualsString(a[i], b[i])) return false;
      }

      return true;
    }

    return false;
  }
  int _pilihAcak(int total) => _acak.nextInt(total) + 1;
  int indeksSoal(int soal) => soal - 1;

  // alat
  int aturPilihanKotak(int pilihan) {
    if (pilihan == _pilihanKotak) {
      _pilihanKotak = 0;
    } else {
      _pilihanKotak = pilihan;
    }
    notifyListeners();
    return _pilihanKotak;
  }

  void aturSusunanJawabanKosong(String isi) {
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
    _susunanJawaban.clear();
    _susunanJawaban = isi;
    notifyListeners();
  }

  void aturSusunanJawabanListListString(List<List<String>> isi) {
    _susunanJawaban.clear();
    _susunanJawaban = isi;
    notifyListeners();
  }

  int ajukanKuis(KontrolProgress kontrolProgress) {
    final benar = cekJawaban(_eKuis.semuaSoal[ambilAwalAntrianKuis].jawaban);
    
    kontrolProgress.naikkanProgressKuis(ambilAwalAntrianKuis, benar);
    _skorKuis = kontrolProgress.progressKuis;
    _jawabanBenar = benar;
    notifyListeners();
    return cekNilaiKuis(benar);
  } // TODO: kembangkan pengecekkan soal

  void aturSoalSelanjutnya(KontrolProgress kontrolProgress) {
    if (!_antrianKuis.isNotEmpty) {
      _antrianKuis.removeAt(0);
    }
    while (_antrianKuis.length < 3) {
      int kandidat = ambilSoalAcak(kontrolProgress);
      if (!_antrianKuis.contains(kandidat)) {
        _antrianKuis.add(kandidat);
      }
    }
    bukaMenuKuis();
    notifyListeners();
  }

  // tutup apk
  void resetAntrianKuis() { // JANGAN dipanggil sembarangan. queue HARUS ada nilai (jangan 0).
    _antrianKuis = [];
    _pilihanKotak= 0;
    _susunanJawaban = [false];
  }
}