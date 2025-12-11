import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_log.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPengaturanBody extends StatefulWidget {
  final Function(bool bahasaInggris) refresh;
  const MenuPengaturanBody({super.key, required this.refresh});

  @override
  State<MenuPengaturanBody> createState() => _MenuPengaturanBodyState();
}

class _MenuPengaturanBodyState extends State<MenuPengaturanBody> {
  late AlatApp alat;
  late KontrolProgress kProgress;
  late KontrolDatabase kDatabase;
  late KontrolLog kLog;

  @override
  void initState() {
    super.initState();
    alat = context.read<AlatApp>();
    kProgress = context.read<KontrolProgress>();
    kDatabase = context.read<KontrolDatabase>();
    kLog = context.read<KontrolLog>();
  }

  final TextEditingController cNama = TextEditingController();
  final TextEditingController cSekolah = TextEditingController();
  final TextEditingController cJabatan = TextEditingController();

  bool get _profilKosong =>
      cNama.text.trim().isEmpty &&
      cSekolah.text.trim().isEmpty &&
      cJabatan.text.trim().isEmpty;

  bool get _profilValid {
    if (_profilKosong) return true; 
    return cNama.text.trim().isNotEmpty &&
        cSekolah.text.trim().isNotEmpty &&
        cJabatan.text.trim().isNotEmpty;
  }

  String? get _errorNama =>
      cNama.text.length > 25 ? (kProgress.bahasaInggris ? "Maximum 25 characters" : "Maksimal 25 karakter") : null;

  String? get _errorSekolah =>
      cSekolah.text.length > 25 ? (kProgress.bahasaInggris ? "Maximum 25 characters" : "Maksimal 25 karakter") : null;

  String? get _errorJabatan =>
      cJabatan.text.length > 25 ? (kProgress.bahasaInggris ? "Maximum 25 characters" : "Maksimal 25 karakter") : null;

  void _simpanProfil() {
    if (!_profilValid) return;
    kProgress.aturNamaSekolahJabatan(
      cNama.text.isEmpty ? null : cNama.text,
      cSekolah.text.isEmpty ? null : cSekolah.text, 
      cJabatan.text.isEmpty ? null : cJabatan.text, 
      kDatabase);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(kProgress.bahasaInggris ? "Profile updated!" : "Profil diperbarui!")));
  }

  @override
  Widget build(BuildContext context) {
    final alat = context.read<AlatApp>();
    final kBelajar = context.read<KontrolBelajar>();
    final kKuis = context.read<KontrolKuis>();
    final kTes = context.read<KontrolTes>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // =========================================================
        //                  PENGATURAN BAHASA
        // =========================================================
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _dekor(),
          child: Row(
            children: [
              const Icon(Icons.language, size: 28, color: Colors.blue),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Bahasa (Language)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Switch(
                value: kProgress.bahasaInggris,
                onChanged: (v) async {
                  final hasil = await kProgress.aturBahasa(v, kBelajar, kKuis, kTes, kDatabase, kProgress);
                  if (hasil) {
                    widget.refresh(v);
                    setState(() {});
                  }
                },
              ),
              Text(kProgress.bahasaInggris ? "ENGLISH" : "INDONESIA"),
              const SizedBox(width: 4),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // =========================================================
        //                  PENGATURAN PROFIL
        // =========================================================
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _dekor(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alat.teksAturanProfil(kProgress),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),

              // NAMA
              TextField(
                controller: cNama,
                decoration: InputDecoration(
                  labelText: alat.teksUtamaNama(kProgress),
                  hintText: alat.teksAturanOpsional(kProgress),
                  prefixIcon: const Icon(Icons.person),
                  errorText: _errorNama,
                ),
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // SEKOLAH
              TextField(
                controller: cSekolah,
                decoration: InputDecoration(
                  labelText: alat.teksUtamaSekolah(kProgress),
                  hintText: alat.teksAturanOpsional(kProgress),
                  prefixIcon: const Icon(Icons.school),
                  errorText: _errorSekolah,
                ),
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // JABATAN
              TextField(
                controller: cJabatan,
                decoration: InputDecoration(
                  labelText: alat.teksUtamaJabatan(kProgress),
                  hintText: alat.teksAturanOpsional(kProgress),
                  prefixIcon: const Icon(Icons.badge),
                  errorText: _errorJabatan,
                ),
                onChanged: (v) => setState(() {}),
              ),

              const SizedBox(height: 20),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _profilValid ? _simpanProfil : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _profilValid ? alat.netral : alat.tidakAktif,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shadowColor: alat.kotakHitam
                  ),
                  child: _profilKosong 
                    ? Text(
                      alat.teksAturanSimpanAnonim(kProgress), 
                      style: TextStyle(color: _profilValid ? alat.teksPutihSedang : alat.teksHitam)
                    ) 
                    : Text(
                      alat.teksAturanSimpan(kProgress), 
                      style: TextStyle(color: _profilValid ? alat.teksPutihSedang : alat.teksHitam)
                    ),
                ),
              ),
              const SizedBox(height: 60),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    kProgress.resetSemuaProgress(kDatabase, kLog);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(kProgress.bahasaInggris ? "Data Is Deleted!" : "Data Dihapus!")));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: alat.salah,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shadowColor: alat.kotakHitam
                  ),
                  child: Text(
                      alat.teksAturanReset(kProgress), 
                      style: TextStyle(color: alat.teksPutihSedang)
                    )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration _dekor() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      );
}