import 'package:belajar_isyarat/alat/alat_app.dart';
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
    final kBelajar = context.watch<KontrolBelajar>();
    final kontrolProgress = context.read<KontrolProgress>();
    final kontrolMenu = context.read<KontrolMenu>();
    final kontrolTes = context.read<KontrolTes>();
    final alat = context.read<AlatApp>();

    final kBelajarProgressMateri = context.select<KontrolBelajar, double> (
      (k) => k.ambilProgressMateri(kBelajar.modulSekarang, kontrolProgress)
    );

    final totalMateri = kontrolProgress.ambilStatusBelajar(kBelajar.modulSekarang).length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
            children: [
              CardStatis(
                lebar: 40,
                tinggi: null,
                isiTengah: true,
                padding: 4,
                tepiRadius: 25,
                kotakGradient: alat.gradientKembali,
                pemisahGarisLuarUkuran: 4,
                judul: "<",
                judulWarna: alat.teksPutihSedang,
                fontJudul: alat.judul,
                pakaiKlik: true,
                pakaiHover: true,
                padaHoverAnimasi: padaHoverAnimasi1,
                padaHoverPemisahGarisLuarWarna: alat.garisLuarHoverAbu,
                padaKlikAnimasi: padaKlikAnimasi1,
                padaKlik: () => kontrolMenu.bukaMenu(0)
              ),

              SizedBox(width: 20),
              Expanded(
                child: Scrollbar(              // ← Scrollbar membungkus seluruh konten scroll
                  controller: controller,
                  thumbVisibility: true,
                  thickness: 10,
                  child: SingleChildScrollView( // ← scrollable utama
                    controller: controller,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === KOLOM ATAS: Judul ===
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 120,
                          maxWidth: double.maxFinite
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Progress Anda: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: alat.teksKuning
                                      ),
                                    ),
                                    const SizedBox(height: 15),

                                    Row(
                                      children: [
                                        Text(
                                          "$kBelajarProgressMateri / $totalMateri",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: alat.bangunProgressBar(
                                            context: context, 
                                            progress: kBelajarProgressMateri, 
                                            tinggi: 20
                                          )
                                        )
                                      ]
                                    )
                                    
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),

                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: CardStatis(
                                    lebar: 170,
                                    tinggi: 80,
                                    padding: 10,
                                    kotakWarna: alat.kotakUtama,
                                    isiTengah: true,
                                    pemisahGarisLuarUkuran: 7,
                                    tepiRadius: 10,
                                    judul: "Tes materi ${kBelajar.modulSekarang}",
                                    judulUkuran: 17,
                                    judulWarna: alat.teksPutihSedang,
                                    fontJudul: alat.judul,
                                    pakaiHover: true,
                                    pakaiKlik: true,
                                    padaHoverPemisahGarisLuarGradient: alat.terpilih,
                                    padaHoverPakaiBayangan: true,
                                    padaHoverAnimasi: padaHoverAnimasi1,
                                    padaKlikAnimasi: padaKlikAnimasi1,
                                    padaKlik: () {
                                      kontrolTes.bukaMenuTes(kBelajar.modulSekarang);
                                      kontrolMenu.bukaMenu(3);
                                    },
                                  )
                                ),
                              ),
                            ]
                          )
                        ),
                      ),
                      SizedBox(height: 10),

                      // === KOLOM BAWAH: List modul ===
                      Center(
                        child: Wrap(
                          spacing: 13,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: List.generate(kBelajar.totalMateriSekarang, (i) {
                            final materi = kBelajar.ambilMateri(kBelajar.modulSekarang, i + 1);
                            return CardStatis(
                              lebar: 150,
                              tinggi: 180,
                              padding: 5,
                              tepiRadius: 10,
                              kotakWarna: alat.kotak1,
                              pemisahGarisLuarUkuran: 3,
                              garisLuarUkuran: 4,
                              gambar: materi.gambar,
                              paddingGambar: 10,
                              tepiRadiusGambar: 10,
                              warnaGambarColor: alat.kotakPutih,
                              judul: materi.judul,
                              judulUkuran: 25,
                              fontJudul: alat.judul,
                              judulWarna: alat.teksPutihSedang,
                              isiTengah: true,
                              pakaiHover: true,
                              pakaiKlik: true,
                              padaHoverAnimasi: padaHoverAnimasi1,
                              padaHoverPemisahGarisLuarWarna: alat.kotakPutih,
                              padaHoverGarisLuarGradient: alat.terpilih,
                              padaKlikAnimasi: padaKlikAnimasi1,
                              susunGambarTeksBaris: Axis.vertical,
                              padaKlik: () {
                                kBelajar.aturMateriSekarang(kontrolProgress, i + 1);
                                kontrolMenu.bukaMenu(2);
                              },
                            );
                          })
                        )
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              )
            )
          ]
        ),
      );
  }
}

class MenuBelajarMateriBody extends StatelessWidget {
  const MenuBelajarMateriBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kontrolMenu = context.read<KontrolMenu>();
    final kBelajar = context.watch<KontrolBelajar>(); //
    final materi = kBelajar.modulSekarang == 0 || kBelajar.materiSekarang == 0
      ? kBelajar.ambilMateri(1, 1)
      : kBelajar.ambilMateri(kBelajar.modulSekarang, kBelajar.materiSekarang);
    final alat = context.read<AlatApp>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardStatis(
            lebar: 40,
            tinggi: null,
            isiTengah: true,
            padding: 4,
            tepiRadius: 25,
            kotakGradient: alat.gradientKembali,
            pemisahGarisLuarUkuran: 4,
            judul: "<",
            judulWarna: alat.teksPutihSedang,
            fontJudul: alat.judul,
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi1,
            padaHoverPemisahGarisLuarWarna: alat.garisLuarHoverAbu,
            padaKlikAnimasi: padaKlikAnimasi1,
            padaKlik: () {
              kBelajar.tutupMenuMateri();
              kontrolMenu.bukaMenu(1);
            }
          ),
          SizedBox(width: 10),
          
          CardStatis(
            lebar: null,
            tinggi: null,
            kotak: true,
            padding: 20,
            tepiRadius: 30,
            kotakGradient: alat.progress,
            gambar: materi.gambar,
            besarGambar: null,
            warnaGambarColor: alat.kotakPutih,
            tepiRadiusGambar: 10,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(right: 40, left: 40, bottom: 15, top: 15),
                    child: Center(
                      child: CardStatis(
                        lebar: null,
                        tinggi: null,
                        isiTengah: true,
                        tepiRadius: 10,
                        kotakWarna: alat.kotakUtama,
                        judul: materi.judul,
                        judulUkuran: 27,
                        judulWarna: alat.teksPutihSedang,
                        fontJudul: alat.judul,
                      ),
                    ),
                  )
                ),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CardStatis(
                      lebar: null,
                      tinggi: null,
                      isiTengah: true,
                      padding: 7,
                      tepiRadius: 10,
                      kotakWarna: alat.kotakPutih,
                      pemisahGarisLuarUkuran: 4,
                      pemisahGarisLuarWarna: alat.kotakUtama,
                      teks: materi.penjelasan,
                      teksUkuran: 27,
                      teksWarna: alat.teksKuning,
                      fontTeks: alat.teks,
                    ),
                  )
                )
              ]
            )
          ),
        ],
      ),
    );
  }
}