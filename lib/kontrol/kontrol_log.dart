import 'package:belajar_isyarat/entitas/profil/e_log.dart';
import 'package:belajar_isyarat/entitas/profil/e_log_detail.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:intl/intl.dart';

class KontrolLog {
  static final KontrolLog _instansi = KontrolLog._isi();
  factory KontrolLog() => _instansi;
  KontrolLog._isi();

  final String namaFile = "log_aktivitas";

  // in-memory storage
  late ELog _eLog;

  /// Inisialisasi: baca dari KontrolDatabase dan simpan di memori
  Future<bool> inis(KontrolDatabase kontrolDatabase) async {
    final dataLog = await kontrolDatabase.ambilJson(namaFile);

    // jika file belum ada atau kosong, pastikan ELog kosong
    if (dataLog == null) {
      _eLog = ELog(list: []);
      return true;
    }

    // ELog.fromJson harus toleran pada List atau Map; jika tidak, atasi di sini:
    if (dataLog is List) {
      _eLog = ELog.fromJson(dataLog);
    } else if (dataLog is Map) {
      // jika format lama berupa object, coba ambil list di field 'list' atau ubah jadi kosong
      if (dataLog.containsKey('list') && dataLog['list'] is List) {
        _eLog = ELog.fromJson(dataLog['list']);
      } else {
        // defensif: convert Map->List jika mungkin: bila object represent single log
        // kita bungkus jadi list
        try {
          _eLog = ELog.fromJson([dataLog]);
        } catch (_) {
          _eLog = ELog(list: []);
        }
      }
    } else {
      _eLog = ELog(list: []);
    }

    if (_eLog.list.length > 900) {
      final list = _eLog.list.sublist(301);
      _eLog.list = list;
      kontrolDatabase.simpanJson(namaFile, _eLog.toJson());
    }
    return true;
  }

  // Ambil semua ELog (in-memory)
  ELog get eLog => _eLog;

  // Ambil list detail
  List<ELogDetail> ambilListLogSync() => _eLog.list;

  // Ambil 50 log terakhir (urut terbaru dulu)
  List<ELogDetail> ambil50Terakhir() {
    final all = List<ELogDetail>.from(_eLog.list);
    if (all.isEmpty) return [];
    final rev = all.reversed.toList(); // terbaru -> lama
    final take = rev.length <= 50 ? rev : rev.sublist(0, 50);
    return take;
  }

  // Format waktu: contoh "08-12 20:34" atau sesuai kebutuhan
  String _fmtDate(DateTime dt) {
    final df = DateFormat('dd-MM HH:mm');
    return df.format(dt);
  }

  // Map nomor modul -> nama modul sesuai permintaan
  String _namaModul(int modul, KontrolProgress kProgress) {
    switch (modul) {
      case 1:
        return kProgress.bahasaInggris ? 'learning numbers' : 'belajar angka';
      case 2:
        return kProgress.bahasaInggris ? 'learning letters' : 'belajar huruf';
      case 3:
        return kProgress.bahasaInggris ? 'learning words' : 'belajar kata';
      default:
        return 'modul_$modul';
    }
  }

  /// Mengembalikan list pesan (terformat) untuk 50 log terakhir
  List<String> ambil50TerakhirBerformat(KontrolProgress kProgress) {
    final list = ambil50Terakhir();
    final out = <String>[];

    for (final e in list) {
      final waktu = _fmtDate(e.waktu);
      String pesan;

      if (e.tipe == 'kuis') {
        final benar = kProgress.bahasaInggris 
          ? ((e.jawabanBenar == true) ? 'right' : 'wrong') 
          : ((e.jawabanBenar == true) ? 'benar' : 'salah');
        final skor = e.skor ?? 0;
        pesan = kProgress.bahasaInggris 
          ? '[$waktu] Completed a quiz, answer was $benar and score +$skor' 
          : '[$waktu] Menyelesaikan kuis, jawaban $benar dan skor +$skor';
      } else if (e.tipe == 'tes') {
        final nilai = e.skor ?? 0;
        final hasil = kProgress.bahasaInggris 
          ? ((nilai >= 75) ? 'passed (above=75)' : 'failed (under 75)') 
          : ((nilai >= 75) ? 'lulus (diatas=75)' : 'tidak lulus (dibawah 75)');
        pesan = kProgress.bahasaInggris 
          ? '[$waktu] MCompleted a test, $hasil with a grade of $nilai' 
          : '[$waktu] Menyelesaikan tes, hasil $hasil dengan nilai $nilai';
      } else { // belajar
        final modul = e.modul ?? 0;
        final materi = e.materi?.toString() ?? '-';
        final namaModul = _namaModul(modul, kProgress);
        pesan = kProgress.bahasaInggris 
          ? '[$waktu] Reading material $materi in module $namaModul'
          : '[$waktu] Membaca materi $materi pada modul $namaModul';
      }

      out.add(pesan);
    }

    return out;
  }

  // =====================================================
  // =============== GETTER: AMBIL SEMUA LOG =============
  // =====================================================
  Future<ELog> ambilLog() async {
    final raw = await KontrolDatabase().ambilJson(namaFile);
    return ELog.fromJson(raw);
  }

  Future<List<ELogDetail>> ambilListLog() async {
    return (await ambilLog()).list;
  }

  // =====================================================
  // ===================== SETTER ========================
  // =====================================================
  Future<void> resetLog() async {
    _eLog.list = [];
    await _simpanKeDisk();
  }

  /// Internal function untuk menambah log
  Future<void> _tambahLog(ELogDetail data) async {
    _eLog.list.add(data);
    await _simpanKeDisk();
  }

  Future<void> _simpanKeDisk() async {
    // KontrolDatabase.simpanJson menerima Map or List (sesuaikan implementasimu)
    // log harus disimpan sebagai LIST
    final data = _eLog.toJson(); // returns List<Map<String,dynamic>>
    await KontrolDatabase().simpanJson(namaFile, data);
  }

  // ------------------ BELAJAR -------------------------
  Future<void> catatLogBelajar({
    required int modul,
    required int materi,
  }) async {
    await _tambahLog(
      ELogDetail(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        waktu: DateTime.now(),
        tipe: "belajar",
        modul: modul,
        materi: materi,
        aksi: "materi_selesai",
      ),
    );
  }

  // ------------------ KUIS ----------------------------
  Future<void> catatLogKuis({
    required int idKuis,
    required bool jawabanBenar,
  }) async {
    await _tambahLog(
      ELogDetail(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        waktu: DateTime.now(),
        tipe: "kuis",
        idKuis: idKuis,
        jawabanBenar: jawabanBenar,
        skor: jawabanBenar ? 100 : 25,
        aksi: "kuis_jawab",
      ),
    );
  }

  // ------------------ TES -----------------------------
  Future<void> catatLogTes({
    required int modul,
    required int skor,
  }) async {
    await _tambahLog(
      ELogDetail(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        waktu: DateTime.now(),
        tipe: "tes",
        modul: modul,
        skor: skor,
        aksi: "tes_selesai",
      ),
    );
  }

  // =====================================================
  // =============== STATISTIK / ANALISA =================
  // =====================================================
  Future<int> totalSkor() async {
    final list = await ambilListLog();
    int total = 0;
    for (final e in list) {
      total += (e.skor ?? 0);
    }
    return total;
  }


  Future<int> totalKuis() async {
    final list = await ambilListLog();
    return list.where((e) => e.tipe == "kuis").length;
  }

  Future<int> totalTes() async {
    final list = await ambilListLog();
    return list.where((e) => e.tipe == "tes").length;
  }

  Future<int> totalMateriSelesai() async {
    final list = await ambilListLog();
    return list.where((e) => e.tipe == "belajar").length;
  }

  /// Untuk chart skor kuis
  Future<List<int>> skorKuisSeries() async {
    final list = await ambilListLog();
    return list
        .where((e) => e.tipe == "kuis")
        .map((e) => e.skor ?? 0)
        .toList();
  }

  /// Untuk chart skor tes
  Future<List<int>> skorTesSeries() async {
    final list = await ambilListLog();
    return list
        .where((e) => e.tipe == "tes")
        .map((e) => e.skor ?? 0)
        .toList();
  }
}