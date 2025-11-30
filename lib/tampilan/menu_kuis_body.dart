import 'package:belajar_isyarat/kontrol/kontrol_menu.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/soal_model.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuKuisMenuBody extends StatelessWidget {
  const MenuKuisMenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kMenu = context.read<KontrolMenu>();

    return Padding (
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: KuisTesMenu(
            judul: "Menu Kuis",
            teks: 
              "Kuis ini opsional dan tidak akan mempengaruhi progress belajar anda,\n "
              "tetapi akan menambah skor kuis anda. Sangat disarankan untuk menguji kemampuan!",
            padaMulai: [
              () => kMenu.bukaMenu(4),
            ],
          )
        )
      )
    );
  }
}

class KuisTesMenu extends StatelessWidget {
  final String judul;
  final String teks;
  final List<VoidCallback> padaMulai;

  const KuisTesMenu({super.key, required this.judul, required this.teks, required this.padaMulai});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          judul,
          style: TextStyle(
            fontSize: 37,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        
        Text(
          teks,
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),

        CardStatis(
          lebar: 120,
          tinggi: 80,
          padding: 10,
          garisLuarUkuran: 7,
          judul: "Mulai",
          teksTengah: true,
          teksWarna: Colors.white54,
          kotakWarna: Colors.blue,
          tepiRadius: 10,
          pakaiKlik: true,
          pakaiHover: true,
          padaHoverGarisLuarWarna: Colors.white,
          padaHoverPakaiBayangan: true,
          padaHoverAnimasi: padaHoverAnimasi1,
          padaKlikAnimasi: padaKlikAnimasi1,
          padaKlik: () {
            for (var fungsi in padaMulai) {
              fungsi();
            }
          },
        )
      ]
    );
  }
}

class MenuKuisSoalBody extends StatelessWidget {
  const MenuKuisSoalBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kKuisSoal = context.select<KontrolKuis, int>(
      (k) => k.ambilAwalAntrianKuis
    );
    final kKuis = context.read<KontrolKuis>();

    final soal = kKuis.ambilKuis(kKuisSoal);

    switch (soal.mode.index) {
      case 0: 
        return SoalModel1(
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar as List<String>,
          gambarJawaban: soal.opsi as List<String>,
          tes: false,
        );
      case 1:
        return SizedBox.shrink();
      case 2:
        return SizedBox.shrink();
      case 3:
        return SizedBox.shrink();
      case 4:
        return SizedBox.shrink();
      default:
        return SizedBox.shrink();
    }
  }
}