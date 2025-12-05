import 'package:belajar_isyarat/entitas/profil/e_progress_belajar.dart';
import 'package:belajar_isyarat/entitas/profil/e_progress_kuis.dart';
import 'package:belajar_isyarat/entitas/profil/e_profil.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart'; // jangan masukkan notifyListener. progress hanya dihandle oleh kontrol lain

import 'package:flutter/foundation.dart'; // TODO: persentase. total tes, total belajar.

class KontrolProgress {
  late EProgressBelajar _eProgressBelajar; //.modul<String, status>.status<int, bool>
  late EProgressKuis _eProgressKuis; //.status<int, bool>
  late EProfil _eProfil; //.nama:String,sekolah:String,jabatan:String,progressBelajar[int],nilaiTes[int],progressKuis:int

  // inisialisasi (anti error)
  Future<bool> inis(KontrolDatabase kontrolDatabase) async {
    final dataProfil = await kontrolDatabase.ambilJson('profil');
    final dataProgressBelajar = await kontrolDatabase.ambilJson('belajar_progress');
    final dataProgressKuis = await kontrolDatabase.ambilJson('kuis_progress');

    _eProfil = EProfil.fromJson(dataProfil);
    _eProgressBelajar = EProgressBelajar.fromJson(dataProgressBelajar);
    _eProgressKuis = EProgressKuis.fromJson(dataProgressKuis);

    _sinkronProgressBelajar(kontrolDatabase);
    return true;
  }

  void _sinkronProgressBelajar(KontrolDatabase kontrolDatabase) {
    List<int> progressBelajar = [];

    for (var modulEntry in _eProgressBelajar.modul.entries) {
      int jumlahBenar = 0;

      for (var statusEntry in modulEntry.value.status.entries) {
        if (statusEntry.value == true) jumlahBenar++;
      }

      progressBelajar.add(jumlahBenar);
    }

    if (!listEquals(progressBelajar, _eProfil.progressBelajar)) {
      _eProfil.progressBelajar = progressBelajar;
      simpanProfil(kontrolDatabase);
    }
  } // todo nanti1 (saat program besar (agar tinggal update json soal/materi saja), anti error status/progress): sinkronkan ketiga json ini dengan belajar_materi.json, kuis_soal.json, tes.json.

  // getter
  String? get nama => _eProfil.nama;
  String? get sekolah => _eProfil.sekolah;
  String? get jabatan => _eProfil.jabatan;
  List<int> get progressBelajar => _eProfil.progressBelajar;
  List<int> get nilaiTes => _eProfil.nilaiTes;
  int get progressKuis => _eProfil.progressKuis;

  int ambilSatuNilaiTes(int modul) => _eProfil.nilaiTes[modul - 1];

  List<bool> ambilStatusBelajar(int modul) {
    if (!_eProgressBelajar.modul.containsKey(indeksModul(modul))) return []; // contain anti error. bisa dihilangkan sebelum todo nanti1 (agar kesalahan json diketahui)

    return _eProgressBelajar.modul[indeksModul(modul)]!.status.values.toList(); // ! artinya sudah pasti ada nilai, jika tidak maka error
  }

  int ambilTotalSemuaMateri() {
    int materiTotal = 0;

    _eProgressBelajar.modul.forEach((m, value) {
      materiTotal += value.status.entries.length;
    });

    return materiTotal;
  }

  bool ambilStatusMateri(int modul, int materi) {
    return _eProgressBelajar.modul[indeksModul(modul)]!.status[materi] ?? false;
  }

  int ambilTotalStatusSemuaMateri() {
    int materiSelesai = 0;
    _eProgressBelajar.modul.forEach((m, value) =>
      value.status.forEach((s, value) {
        if (value) {
          materiSelesai++;
        }
      })
    );
    return materiSelesai;
  }

  double ambilProgressStatusSemuaMateri() => ambilTotalStatusSemuaMateri() / ambilTotalSemuaMateri();

  List<bool> ambilStatusSemuaKuis() {
    return _eProgressKuis.status.values.toList();
  }

  int ambilTotalSemuaKuis() {
    return _eProgressKuis.status.length;
  }

  bool ambilStatusKuis(int kuis) {
   return _eProgressKuis.status[kuis] ?? false; //Jika bagian kiri null → gunakan bagian kanan.
  }

  String indeksModul(int modul) => "modul_$modul";

  // alat
  void naikkanProgressBelajar(int modul, int materi) {
    if (!ambilStatusMateri(modul, materi)) {
      _eProgressBelajar.modul[indeksModul(modul)]!.status[materi] = true;
      _eProfil.progressBelajar[modul - 1]++;
    }
  }

  void naikkanProgressKuis(int kuis, bool benar) {
    if (benar) {
      _eProgressKuis.status[kuis] = true;
      _eProfil.progressKuis += 100;
    } else {
      _eProfil.progressKuis += 25;
    }
  }

  void naikkanNilaiTes(int nomorTes, int nilai) {
    _eProfil.nilaiTes[nomorTes - 1] = nilai;
  }

  void aturNama(String nama) {
    _eProfil.nama = nama;
  }

  void aturSekolah(String sekolah) {
    _eProfil.sekolah = sekolah;
  }

  void aturJabatan(String jabatan) {
    _eProfil.jabatan = jabatan;
  }

  //resetProgress...

  // tutup APK
  void simpanPerubahan(KontrolDatabase kontrolDatabase) {
    kontrolDatabase.simpanJson("belajar_progress", _eProgressBelajar.toJson());
    kontrolDatabase.simpanJson("kuis_progress", _eProgressKuis.toJson());
    kontrolDatabase.simpanJson("profil", _eProfil.toJson());
  }
  void simpanProfil(KontrolDatabase kontrolDatabase) {
    kontrolDatabase.simpanJson("profil", _eProfil.toJson());
  }
}