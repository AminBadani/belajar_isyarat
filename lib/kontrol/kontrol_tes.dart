import 'package:belajar_isyarat/entitas/tes/e_soal_tes.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:flutter/foundation.dart';
// ======================== BELUM CEK, CEK DULU ===================
import '../entitas/tes/e_tes.dart';
import 'kontrol_database.dart';

class KontrolTes extends ChangeNotifier {
  int _modul = 0; // 1 sampai n. 0 artinya tidak aktif
  int _soal = 0; // 1 sampai n
  
  int _jawabanBenar = 0;
  int _totalSoal = 0;

  int _pilihanKotak = 0;
  List<dynamic> _susunanJawaban = [false];
  List<dynamic> _simpananJawaban = [];

  late ETes _eTes; //.modul<String,semuaSoal>.semuaSoal[ESoalTes].suara:String?,gambar:dynamic,pertanyaan:String,opsi[String]?,jawaban:dynamic,mode:ModeTes{"susun", "pilih", "hubungkan", "lengkapi", "artikan"}

  // ==== inisialisasi ====
  Future<bool> inis(KontrolDatabase kontrolDatabase) async {
    final data = await kontrolDatabase.ambilJson('tes');
    _eTes = ETes.fromJson(data);

    return true;
  }

  void bukaMenuTes(int modul) {
    final semuaSoal = _eTes.modul[indeksModul(modul)]!.semuaSoal;
    _modul = modul;
    _soal = 1;
    _jawabanBenar = 0;
    _totalSoal = semuaSoal.length;
    _pilihanKotak = 0;
    _susunanJawaban = [false];
    _simpananJawaban = [];

    // isi simpanan jawaban sesuai mode nya
    for (var i=0; i<semuaSoal.length; i++){
      if (semuaSoal[i].mode.name == "susun") {
        _simpananJawaban.add(semuaSoal[i].opsi);
        if (i == 0) {
          _susunanJawaban = semuaSoal[i].opsi;
        }
      } else if (semuaSoal[i].mode.name == "hubungkan") {
        _simpananJawaban.add([semuaSoal[i].opsi, semuaSoal[i].gambar]);
        if (i == 0) {
          _susunanJawaban = [semuaSoal[i].opsi, semuaSoal[i].gambar];
        }
      } else if (semuaSoal[i].mode.name == "lengkapi") {
        _simpananJawaban.add(semuaSoal[i].gambar);
        if (i == 0) {
          _susunanJawaban = [semuaSoal[i].gambar];
        }
      } else if (semuaSoal[i].mode.name == "artikan") {
        _simpananJawaban.add([]);
        for (var j = 0; j < semuaSoal[i].jawaban.length; j++) {
          _simpananJawaban[i].add(null);
        }
        if (i == 0) {
          _susunanJawaban = _simpananJawaban[i];
        }
      } else {
        _simpananJawaban.add(false);
      }
    }
    notifyListeners();
  }

  // ==== getter ====
  int get modul => _modul;
  int get soal => _soal;
  int get jawabanBenar => _jawabanBenar;
  int get totalSoal => _totalSoal;

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

  List<dynamic> get simpananJawaban => _simpananJawaban;

  bool bolehAjukanTes() {
    for (var isi in _simpananJawaban) {
      if (isi == false) {return false;}
    }
    return true;
  }

  ESoalTes ambilSoalTes(int modul, int soal) {
    final indeksModul = "modul_$modul";
    final indeksSoal = soal - 1;

    return _eTes.modul[indeksModul]!.semuaSoal[indeksSoal];
  }

  double cekHasilNilai() {
    double hasil = _jawabanBenar / _totalSoal;
    return hasil;
  }

  bool cekJawaban(int modul, int soal, dynamic jawaban) {
    final jawabanBenar = _eTes.modul[indeksModul(modul)]!.semuaSoal[indeksSoal(soal)].jawaban;

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
  String indeksModul(int modul) => "modul_$modul";
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

  void _jawabSoal() {
    final soal = _eTes.modul[indeksModul(_modul)]!.semuaSoal[indeksSoal(_soal)];
    if (soal.mode.name == 'pilih') {
      if (pilihanKotak == 0) {
          _susunanJawaban = [false];
      }
      else if (soal.opsi[pilihanKotak - 1] != _susunanJawaban) {
        _susunanJawaban = [soal.opsi[pilihanKotak - 1]];
      }
    }
    if (_susunanJawaban != _simpananJawaban[indeksSoal(_soal)]) {
      if (soal.mode.name == "pilih") {
        _simpananJawaban[indeksSoal(_soal)] = _susunanJawaban.map((j) => j);
      } else {
        _simpananJawaban[indeksSoal(_soal)] = _susunanJawaban;
      }
    }
  }

  void ajukanTes(KontrolProgress kontrolProgress) {
    if (bolehAjukanTes()) {
      final semuaSoal = _eTes.modul[indeksModul(modul)]!.semuaSoal;
      for (var i = 0; i < semuaSoal.length; i++) {
        if (deepEqualsString(_simpananJawaban[i], semuaSoal[i].jawaban)) {
         _jawabanBenar++;
        }
      }
      kontrolProgress.naikkanNilaiTes(_modul, cekHasilNilai().round()); // salah, harusnya nilaiTes double.
      notifyListeners();
    }
  }

  void aturSoalSelanjutnya() {
    if (_soal < _eTes.modul[indeksModul(_modul)]!.semuaSoal.length) {
      _jawabSoal();
      _soal++;
      _susunanJawaban = _simpananJawaban[_soal - 1] is List ? _simpananJawaban[_soal - 1] : [_simpananJawaban[_soal - 1]];
      notifyListeners();
    }
  }

  void aturSoalSebelumnya() {
    if (_soal > 1) {
      _jawabSoal();
      _soal--;
      _susunanJawaban = _simpananJawaban[_soal - 1] is List ? _simpananJawaban[_soal - 1] : [_simpananJawaban[_soal - 1]];
      notifyListeners();
    }
  }

  // tutup apk || tutup menu
  void tutupMenuTes() {
    _modul = 0;
    _soal = 0;
    _jawabanBenar = 0;
    _totalSoal = 0;
    _susunanJawaban = [false];
    _simpananJawaban = [];
    _pilihanKotak = 0;
  }
}