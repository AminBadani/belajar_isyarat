import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_menu.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pelajaran {
  final String name;
  final String iconPath;

  Pelajaran(this.name, this.iconPath);
}

final List<Pelajaran> items = [
  Pelajaran("Angka", "numbers"),
  Pelajaran("Huruf", "abc-block"),
];

class MenuUtamaBody extends StatefulWidget {
  const MenuUtamaBody({super.key});

  @override
  State<MenuUtamaBody> createState() => _MenuUtamaBodyState();
}

class _MenuUtamaBodyState extends State<MenuUtamaBody> {
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
    final kProgressProgressKuis = context.select<KontrolProgress, int>(
      (k) => k.progressKuis
    );
    final kProgressProgressMateri = context.select<KontrolProgress, double>(
      (k) => k.ambilProgressStatusSemuaMateri()
    );
    final kProgress = context.read<KontrolProgress>();
    final kBelajar = context.read<KontrolBelajar>();
    final kMenu = context.read<KontrolMenu>();
    final alat = context.read<AlatApp>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === KOLOM KIRI: Daftar Pelajaran ===
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Scrollbar(
                controller: controller ,
                thumbVisibility: true,
                thickness: 10,
                child: Center(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 5), // jarak antar item
                        child: CardStatis(
                          lebar: null,
                          tinggi: 90,
                          padding: 5,
                          tepiRadius: 12.5,
                          pemisahGarisLuarUkuran: 3,
                          garisLuarUkuran: 5,
                          judul: items[index].name,
                          judulUkuran: 27,
                          judulWarna: alat.teksPutihSedang,
                          fontJudul: alat.judul,
                          isiTengah: true,
                          gambar: [items[index].iconPath],
                          besarGambar: null,
                          warnaGambarColor: alat.kotakPutih,
                          tepiRadiusGambar: 20,
                          kotakWarna: alat.kotak1,
                          pakaiKlik: true,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi2,
                          padaHoverPemisahGarisLuarWarna: alat.kotakPutih,
                          padaHoverGarisLuarGradient: alat.terpilih,
                          padaKlikAnimasi: padaKlikAnimasi1,
                          padaKlik: () {
                            kBelajar.aturModulSekarang(index + 1);
                            kMenu.bukaMenu(1);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // === KOLOM KANAN: Progress penting ===
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: alat.kotakUtama,
                borderRadius: BorderRadius.circular(12.5)
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: alat.kotakPutih,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Image.asset("lib/database/gambar/trophy.png", width: 50, height: 50),
                            const SizedBox(height: 15),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Progress Anda: ",
                                  style: TextStyle(
                                    fontFamily: alat.judul,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksKuning
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kProgressProgressKuis.toString(),
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 27
                                )
                              ],
                            ),
                          ],
                        )
                      )
                    ),
                    SizedBox(height: 20),
                    
                    Expanded(
                    child: Column(
                        children: [
                          if (kProgress.nama != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Nama: ",
                                  style: TextStyle(
                                    fontFamily: alat.teks,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksHitam
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kProgress.nama!,
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 16
                                ),
                              ],
                            ),
                            
                          if (kProgress.sekolah != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sekolah: ",
                                  style: TextStyle(
                                    fontFamily: alat.teks,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksHitam
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kProgress.sekolah!,
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 16
                                )
                              ],
                            ),
                            
                          if (kProgress.jabatan != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Jabatan: ",
                                  style: TextStyle(
                                    fontFamily: alat.teks,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksHitam
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kProgress.jabatan!,
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 16
                                )
                              ],
                            ),
                          ]
                        )
                      ),
                    
                    SizedBox(height: 20),
                    
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Total progress belajar: ",
                            style: TextStyle(
                              fontFamily: alat.judul,
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: alat.teksKuning
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${kProgressProgressMateri * 100}%",
                                style: TextStyle(
                                  fontFamily: alat.teks,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: alat.teksHitam
                                ),
                              ),
                              Expanded(
                                child: alat.bangunProgressBar(
                                  context: context, 
                                  progress: kProgressProgressMateri,
                                  tinggi: 20
                                )
                              )
                            ],
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}