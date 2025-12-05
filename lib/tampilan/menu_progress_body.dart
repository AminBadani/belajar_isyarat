import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:flutter/material.dart';
import '../kontrol/kontrol_progress.dart';
import 'package:provider/provider.dart';

class MenuProgressBody extends StatefulWidget {
  const MenuProgressBody({super.key});

  @override
  State<MenuProgressBody> createState() => _MenuProgressBodyState();
}

class _MenuProgressBodyState extends State<MenuProgressBody> {
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
    final kBelajar = context.read<KontrolBelajar>();
    final kProgress = context.read<KontrolProgress>();
    final alat = context.read<AlatApp>();

    final kProgressSkorKuis = context.select<KontrolProgress, int>(
      (k) => k.progressKuis
    );
    final kProgressNilaiTes = context.select<KontrolProgress, List<int>>(
      (k) => k.nilaiTes
    );
    final kProgressItemDipelajari = context.select<KontrolProgress, int>(
      (k) => k.ambilTotalStatusSemuaMateri()
    );
    final kProgressProgressMateri = context.select<KontrolProgress, double>(
      (k) => k.ambilProgressStatusSemuaMateri()
    );
    List<int> totalMateri = [];
    final kProgressProgressBelajar = context.select<KontrolProgress, List<int>>(
      (k) {
        totalMateri.clear;
        List<int> progress = [];
        int materiSelesai = 0;
        for (var i = 0; i < kBelajar.totalModul; i++) {
          materiSelesai = 0;
          for (var nilai in k.ambilStatusBelajar(i)) {
            if (nilai) {materiSelesai++;}
          }
          progress.add(materiSelesai);
          totalMateri.add(kBelajar.totalMateri(i+1));
        }
        return progress;
      }
    );

    int jumlahLulusTes = 0;
    for (var nilai in kProgressNilaiTes) {
      if (nilai > 80) {
        jumlahLulusTes++;
      }
    };

    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Scrollbar(              // ← Scrollbar membungkus seluruh konten scroll
        controller: controller,
        thumbVisibility: true,
        thickness: 10,
        child: SingleChildScrollView( // ← scrollable utama
          controller: controller,
          child: Column(
            children:[
              LayoutBuilder(builder: (context, c) {
                final maxWidth = c.maxWidth;

                return SizedBox(
                  width: maxWidth,
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: CardStatis(
                          padding: 10,
                          isiTengah: true,
                          kotakWarna: alat.kotak1,
                          tepiRadius: 10,
                          pemisahGarisLuarUkuran: 4,
                          pemisahGarisLuarWarna: alat.kotak2,
                          judul: "Item dipelajari:  ${kProgress.ambilTotalSemuaMateri()}/$kProgressItemDipelajari",
                          judulUkuran: 17,
                          fontJudul: alat.judul,
                          judulWarna: alat.teksKuning,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                        )
                      ),
                      SizedBox(width: 10),

                      Expanded(
                        child: CardStatis(
                          padding: 10,
                          isiTengah: true,
                          kotakWarna: alat.kotak2,
                          tepiRadius: 10,
                          pemisahGarisLuarUkuran: 4,
                          pemisahGarisLuarWarna: alat.kotak3,
                          judul: "Progress Belajar:  ${kProgressProgressMateri * 100}%",
                          judulUkuran: 17,
                          fontJudul: alat.judul,
                          judulWarna: alat.teksKuning,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                        )
                      ),
                      SizedBox(width: 10),
                      
                      Expanded(
                        child: CardStatis(
                          padding: 10,
                          isiTengah: true,
                          kotakWarna: alat.kotak3,
                          tepiRadius: 10,
                          pemisahGarisLuarUkuran: 4,
                          pemisahGarisLuarWarna: alat.kotak4,
                          judul: "Skor Kuis:  $kProgressSkorKuis",
                          judulUkuran: 17,
                          fontJudul: alat.judul,
                          judulWarna: alat.teksKuning,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                        )
                      ),
                      SizedBox(width: 10),
                      
                      Expanded(
                        child: CardStatis(
                          padding: 10,
                          isiTengah: true,
                          kotakWarna: alat.kotak4,
                          tepiRadius: 10,
                          pemisahGarisLuarUkuran: 5,
                          pemisahGarisLuarWarna: alat.kotak4,
                          judul: "Jumlah Tes Lulus:  $jumlahLulusTes / ${kProgressNilaiTes.length}",
                          judulUkuran: 17,
                          fontJudul: alat.judul,
                          judulWarna: alat.teksKuning,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                        )
                      )
                    ]
                  )
                );
              }),
              /*Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: alat.progress
                ),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: alat.kotakPutih,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ListView.builder(
                        controller: controller,
                        itemExtent: 2,
                        itemCount: totalMateri.length,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: alat.progress
                            ),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: alat.kotakPutih,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Progress Pelajaran ${i + 1}",
                                    style: TextStyle(
                                      color: alat.teksKuning,
                                      fontFamily: alat.judul,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${kProgressProgressBelajar[i]} / ${totalMateri[i]}",
                                        style: TextStyle(
                                          color: alat.teksKuning,
                                          fontFamily: alat.judul,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      alat.bangunProgressBar(
                                        context: context, 
                                        progress: kProgressProgressBelajar[i] / totalMateri[i], 
                                        tinggi: 20
                                      )
                                    ]
                                  )
                                ],
                              ),
                            )
                          );
                        }
                      )
                    ],
                  )
                )
              )*/
            ]
          ),
        ),
      )
    );
  }
}
