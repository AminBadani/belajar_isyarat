import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:belajar_isyarat/tampilan/menu_kuis_body.dart';
import 'package:belajar_isyarat/tampilan/soal_model.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuTesMenuBody extends StatelessWidget {
  const MenuTesMenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kTes = context.read<KontrolTes>();
    final kMenu = context.read<KontrolMenu>();

    return Padding (
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CardStatis(
            lebar: 40,
            tinggi: double.infinity,
            teksTengah: true,
            judul: "<",
            tepiRadius: 10,
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi1,
            padaHoverPakaiBayangan: true,
            padaKlikAnimasi: padaKlikAnimasi1,
            padaKlik: () {
              kTes.tutupMenuTes();
              kMenu.bukaMenu(1);
            }
          ),
          SizedBox(width: 10),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: KuisTesMenu(
                  judul: "Menu Tes",
                  teks: 
                    "Tes adalah langkah terakhir untuk menyelesaikan progress materi.\n"
                    "Kemampuan anda akan diuji disini, anda dapat mengerjakan tes berulang-kali",
                  padaMulai: [
                    () => kMenu.bukaMenu(4),
                  ],
                )
              )
            ),
          )
        ]
      )
    );
  }
}

class MenuTesSoalBody extends StatelessWidget {
  const MenuTesSoalBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kTesSoal = context.select<KontrolTes, int>(
      (k) => k.soal
    );
    final kTes = context.read<KontrolTes>();
    final kMenu = context.read<KontrolMenu>();

    final soal = kTes.ambilSoalTes(kTes.modul, kTesSoal);

    final body = switch (soal.mode.index) {
      0 => SoalModel2(
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar,
          gambarJawaban: soal.opsi,
          tes: true,
        ),
      1 => SoalModel1(
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar,
          gambarJawaban: soal.opsi,
          tes: true,
        ),
      2 => SoalModel3(
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar,
          gambarJawaban: soal.opsi,
          tes: true,
        ),
      3 => SizedBox.shrink(),
      4 => SizedBox.shrink(),
      _ => SizedBox.shrink(),
    };

    final bodyAkhir = Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CardStatis(
              lebar: 40,
              tinggi: double.infinity,
              teksTengah: true,
              judul: "<",
              tepiRadius: 10,
              pakaiKlik: true,
              pakaiHover: true,
              padaHoverAnimasi: padaHoverAnimasi1,
              padaHoverPakaiBayangan: true,
              padaKlikAnimasi: padaKlikAnimasi1,
              padaKlik: () {
                kTes.tutupMenuTes();
                kMenu.bukaMenu(3);
              }
            ),
          ),
          SizedBox(width: 10),

          Expanded(
            flex: 14,
            child: body
          )
        ],
      )
    );

    return bodyAkhir;
  }
}