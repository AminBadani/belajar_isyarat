import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_menu.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuBelajarMenuBody extends StatefulWidget {
  const MenuBelajarMenuBody({super.key});

  @override
  State<MenuBelajarMenuBody> createState() => _MenuBelajarMenuBodyState();
}

class _MenuBelajarMenuBodyState extends State<MenuBelajarMenuBody> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kontrolBelajar = context.watch<KontrolBelajar>();
    final kontrolProgress = context.read<KontrolProgress>();
    final kontrolMenu = context.read<KontrolMenu>();
    final kontrolTes = context.read<KontrolTes>();

    final valueProgressIndicator = kontrolBelajar.modulSekarang == 0
      ? 0.0
      : kontrolBelajar.ambilProgressMateri(kontrolBelajar.modulSekarang, kontrolProgress);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Scrollbar(              // ← Scrollbar membungkus seluruh konten scroll
        controller: controller,
        thumbVisibility: true,
        thickness: 10,
        child: SingleChildScrollView( // ← scrollable utama
          controller: controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CardStatis(
                lebar: 100,
                tinggi: 40,
                padding: 4,
                teks: "< kembali",
                pakaiKlik: true,
                pakaiHover: true,
                padaHoverAnimasi: padaHoverAnimasi1,
                padaHoverPakaiBayangan: true,
                padaKlikAnimasi: padaKlikAnimasi1,
                padaKlik: () => kontrolMenu.bukaMenu(0)
              ),
              SizedBox(height: 10),

              // === KOLOM ATAS: Judul ===
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Progress Anda: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    LinearProgressIndicator(
                      value: valueProgressIndicator,
                      minHeight: 20,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ),

              // === KOLOM BAWAH: List modul ===
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Row(
                    children: List.generate(kontrolBelajar.totalMateri, (i) {
                      final materi = kontrolBelajar.ambilMateri(kontrolBelajar.modulSekarang, i + 1);

                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: CardStatis(
                          lebar: 150,
                          tinggi: 200,
                          gambar: materi.gambar,
                          judul: materi.judul,
                          pakaiHover: true,
                          pakaiKlik: true,
                          teksTengah: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                          tepiRadius: 10,
                          garisLuarUkuran: 5,
                          padaHoverGarisLuarWarna: Colors.white,
                          padaHoverPakaiBayangan: true,
                          padaKlikAnimasi: padaKlikAnimasi1,
                          susunGambarTeksBaris: Axis.vertical,
                          padaKlik: () {
                            kontrolBelajar.aturMateriSekarang(kontrolProgress, i + 1);
                            kontrolMenu.bukaMenu(2);
                          },
                        ),
                      );
                    })
                  )
                ),
              ),
              SizedBox(height: 10),

              Center(
                child: CardStatis(
                  lebar: 170,
                  tinggi: 80,
                  padding: 10,
                  garisLuarUkuran: 7,
                  tepiRadius: 10,
                  judul: "Tes materi ${kontrolBelajar.modulSekarang}",
                  judulUkuran: 17,
                  teksTengah: true,
                  pakaiHover: true,
                  pakaiKlik: true,
                  padaHoverGarisLuarWarna: Colors.white,
                  padaHoverPakaiBayangan: true,
                  padaHoverAnimasi: padaHoverAnimasi1,
                  padaKlikAnimasi: padaKlikAnimasi1,
                  padaKlik: () {
                    kontrolTes.bukaMenuTes(kontrolBelajar.modulSekarang);
                    kontrolMenu.bukaMenu(3);
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuBelajarMateriBody extends StatelessWidget {
  const MenuBelajarMateriBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kontrolMenu = context.read<KontrolMenu>();
    final kontrolBelajar = context.watch<KontrolBelajar>(); //
    final materi = kontrolBelajar.modulSekarang == 0 || kontrolBelajar.materiSekarang == 0
      ? kontrolBelajar.ambilMateri(1, 1)
      : kontrolBelajar.ambilMateri(kontrolBelajar.modulSekarang, kontrolBelajar.materiSekarang);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: CardStatis(
              lebar: double.infinity,
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
                kontrolBelajar.tutupMenuMateri();
                kontrolMenu.bukaMenu(1);
              }
            )
          ),
          SizedBox(width: 10),
          
          Expanded(
            flex: 5,
            child: CardStatis(
              lebar: double.infinity,
              tinggi: double.infinity,
              gambar: materi.gambar,
              tepiRadius: 10,
              susunGambarTeksBaris: Axis.vertical,
            ),
          ),

          SizedBox(width: 10),

          Expanded(
            flex: 9,
            child: CardStatis(
              lebar: double.infinity,
              tinggi: double.infinity,
              judul: materi.judul,
              teks: materi.penjelasan,
              tepiRadius: 10,
              susunGambarTeksBaris: Axis.vertical,
              jarakKontenUkuran: 40,
            )
          ),
        ],
      ),
    );
  }
}