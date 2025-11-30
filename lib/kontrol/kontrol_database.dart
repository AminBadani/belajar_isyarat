import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class KontrolDatabase {
  static final KontrolDatabase _instansi = KontrolDatabase._isi();
  factory KontrolDatabase() => _instansi;
  KontrolDatabase._isi();

  /// Mengembalikan Image widget dari folder database/img/
  Image ambilGambar(String namaFile, {double? lebar, double? tinggi}) {
    return Image.asset(
      'lib/database/gambar/$namaFile.png',
      width: lebar,
      height: tinggi,
      fit: BoxFit.contain,

      // fallback jika file tidak ditemukan
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'lib/database/gambar/placeholder.png',
          width: lebar,
          height: tinggi,
          fit: BoxFit.contain,
        );
      },
    );
  }

  /// Memutar suara dari folder database/suara/
  Future<void> mulaiSuara(String namaFile) async {
    final player = AudioPlayer();
    await player.play(AssetSource('lib/database/suara/$namaFile.wap'));
  }

  /// Membaca file JSON dari folder database/data/
  Future<dynamic> ambilJson(String namaFile) async {
    try {
      final raw = await rootBundle.loadString('lib/database/data/$namaFile.json');
      final decoded = json.decode(raw);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is List) {
        return decoded;
      } else {
        throw FlutterError(
          "File JSON '$namaFile' harus Map<String,dynamic> atau List, "
          "tapi ditemukan ${decoded.runtimeType}. "
          "Periksa apakah JSON berupa LIST []."
        );
      }
    } catch (e) {
      debugPrint("Gagal membaca JSON $namaFile: $e");
      return <String, dynamic>{}; // return Map kosong: aman & tidak crash
    }
  }


  // Simpan profil, progress.
  Future<dynamic> simpanJson(String namaFile, Map<String, dynamic> file) async {
    try {
      final pathFile = "lib/database/data/$namaFile.json";

      final targetFile = File(pathFile);

      // Pastikan folder ada
      await targetFile.parent.create(recursive: true);

      // Encode dan simpan (overwrite)
      await targetFile.writeAsString(
        jsonEncode(file),
        flush: true,
      );

      return true;
    } catch (e) {
      return e;
    }
  }
}
