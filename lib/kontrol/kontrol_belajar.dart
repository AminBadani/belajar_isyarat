import 'package:belajar_isyarat/entitas/belajar/e_belajar.dart';
import 'package:belajar_isyarat/entitas/belajar/e_materi_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';

import 'package:flutter/foundation.dart';

// kontrol memiliki state UI berbeda beda, jadi nilai var notifier harus bisa 0 (artinya tak aktif)
class KontrolBelajar extends ChangeNotifier {
  int _modul = 0; // 1 sampai n. 0 artinya tidak ada modul aktif
  int _materi = 0; // 1 sampai n
  late EBelajar _eBelajar; //.modul<String, materi>.materi[EMateriBelajar].suara:String,gambar[String],judul:String,penjelasan:String

  Future<bool> inis(KontrolDatabase kontrolDatabase) async {
    final data = await kontrolDatabase.ambilJson('belajar_materi');
    
    _eBelajar = EBelajar.fromJson(data);

    return true;
  }

  // getter
  int get modulSekarang => _modul;
  int get materiSekarang => _materi;
  int get totalMateriSekarang {
    if (_modul == 0) return 0;
    return _eBelajar.modul[indeksModul(_modul)]!.materi.length;
  }

  int get totalModul => _eBelajar.modul.length;
  int totalMateri(int modul) => _eBelajar.modul[indeksModul(modul)]!.materi.length;

  int ambilJumlahGambar(int modul, int materi) {
    return _eBelajar.modul[indeksModul(modul)]!.materi[indeksMateri(materi)].gambar.length;
  }

  EMateriBelajar ambilMateri(int modul, int materi) { // harusnya getMateriSekarang()
    return _eBelajar.modul[indeksModul(modul)]!.materi[indeksMateri(materi)];
  }

  double ambilProgressMateri(int modul, KontrolProgress kontrolProgress) {
    if (modul <= 0) return 0.0;

    final modulData = _eBelajar.modul[indeksModul(modul)];
    if (modulData == null) return 0.0;

    final statusBelajar = kontrolProgress.progressBelajar;

    if (modul - 1 >= statusBelajar.length) return 0.0;

    return statusBelajar[modul - 1] / modulData.materi.length;
  }

  String indeksModul(int modul) => "modul_$modul";
  int indeksMateri(int materi) => materi - 1;

  // alat
  void aturModulSekarang(int modul) {
    _modul = modul;
    _materi = 0;
    notifyListeners();
  }

  void aturMateriSekarang(KontrolProgress kontrolProgress, int materi) {
    _materi = materi;
    kontrolProgress.naikkanProgressBelajar(_modul, _materi);
    notifyListeners();
  }

  void aturMateriSelanjutnya(KontrolProgress kontrolProgress) {
    if (_materi < _eBelajar.modul[indeksModul(_modul)]!.materi.length) {
      _materi++;
      kontrolProgress.naikkanProgressBelajar(_modul, _materi);
      notifyListeners();
    }
  }

  void aturMateriSebelumnya() {
    if (_materi > 1) {
      _materi--;
      notifyListeners();
    }
  }

  // tutup apk || tutup menu
  void tutupMenuBelajar() {
    _modul = 0;
    _materi = 0;
  }

  void tutupMenuModul() {
    _modul = 0;
    _materi = 0;
  }
  void tutupMenuMateri() {
    _materi = 0;
  }
}