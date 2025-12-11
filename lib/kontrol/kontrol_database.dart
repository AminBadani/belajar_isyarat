import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<dynamic> ambilJson(String namaFile) async {
    try {
      final file = File("lib/database/data/$namaFile.json");

      // 1️⃣ Jika file user ada → baca file user
      if (await file.exists()) {
        final raw = await file.readAsString();
        final decoded = json.decode(raw);
        return decoded;
      }

      // 2️⃣ Jika tidak ada → baca file asset bawaan aplikasi
      final rawAsset = await rootBundle.loadString('lib/database/data/$namaFile.json');
      final decodedAsset = json.decode(rawAsset);
      return decodedAsset;

    } catch (e) {
      debugPrint("Gagal membaca JSON $namaFile: $e");
      return <String, dynamic>{};
    }
  }


  // Simpan profil, progress, atau log (boleh MAP atau LIST)
  Future<dynamic> simpanJson(String namaFile, dynamic data) async {
    try {
      final pathFile = "lib/database/data/$namaFile.json";
      final targetFile = File(pathFile);

      await targetFile.parent.create(recursive: true);

      if (data is! Map && data is! List) {
        throw FlutterError(
          "simpanJson hanya menerima Map<String, dynamic> atau List. "
          "Ditemukan tipe: ${data.runtimeType}",
        );
      }

      // ==== Pretty JSON here ====
      const encoder = JsonEncoder.withIndent('  '); // indent dua spasi
      final pretty = encoder.convert(data);

      await targetFile.writeAsString(
        pretty,
        mode: FileMode.write,
        flush: true,
      );

      return true;
    } catch (e) {
      debugPrint("Gagal simpan JSON $namaFile: $e");
      return e;
    }
  }
}
