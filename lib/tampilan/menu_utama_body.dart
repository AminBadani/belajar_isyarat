import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_menu.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    
    final kProgress = context.read<KontrolProgress>();
    final kBelajar = context.read<KontrolBelajar>();
    final kMenu = context.read<KontrolMenu>();
    final alat = context.read<AlatApp>();
    final kKuisProgressKuis = context.select<KontrolKuis, int>(
      (k) => k.skorKuis(kProgress)
    );
    final kBelajarProgressMateri = context.select<KontrolBelajar, int>(
      (k) => k.totalSemuaMateriSelesai(kProgress)
    );
    final totalMateri = kBelajar.totalSemuaMateri();

    return Row(
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
                    itemCount: alat.itemBelajar(kProgress).length,
                    itemBuilder: (context, index) {
                      final warna = alat.warnaWarnaKotak[index % 5];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 5), // jarak antar item
                        child: CardStatis(
                          lebar: null,
                          tinggi: 110,
                          padding: 5,
                          tepiRadius: 25,
                          pemisahGarisLuarUkuran: 3,
                          bayanganKotak: alat.boxShadow,
                          garisLuarUkuran: 5,
                          judul: alat.itemBelajar(kProgress)[index].name,
                          judulUkuran: 34,
                          judulWarna: alat.teksPutihSedang,
                          fontJudul: alat.judul,
                          isiTengah: true,
                          gambar: [alat.itemBelajar(kProgress)[index].iconPath],
                          besarGambar: null,
                          warnaGambarColor: alat.kotakPutih,
                          tepiRadiusGambar: 20,
                          paddingGambar: 10,
                          kotakWarna: warna,
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
                          padaHoverBayanganGarisLuar: alat.boxShadowHover,
                          bayanganTeks: alat.teksShadow,
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
                borderRadius: BorderRadius.circular(12.5),
                boxShadow: alat.boxShadow
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
                    const SizedBox(height: 30),
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
                                  "${alat.teksUtamaProgress(kProgress)}: ",
                                  style: TextStyle(
                                    fontFamily: alat.judul,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksKuning,
                                    shadows: alat.teksShadow
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kKuisProgressKuis.toString(),
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 34,
                                  beratFont: FontWeight.bold
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
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (kProgress.nama != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${alat.teksUtamaNama(kProgress)}: ",
                                  style: TextStyle(
                                    fontFamily: alat.teks,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksHitam,
                                    shadows: alat.teksShadow
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kProgress.nama!,
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 27,
                                  beratFont: FontWeight.bold
                                ),
                              ],
                            ),
                            
                          if (kProgress.sekolah != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${alat.teksUtamaSekolah(kProgress)}: ",
                                  style: TextStyle(
                                    fontFamily: alat.teks,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksHitam,
                                    shadows: alat.teksShadow
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kProgress.sekolah!,
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 27,
                                  beratFont: FontWeight.bold
                                )
                              ],
                            ),
                            
                          if (kProgress.jabatan != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${alat.teksUtamaJabatan(kProgress)}: ",
                                  style: TextStyle(
                                    fontFamily: alat.teks,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    color: alat.teksHitam,
                                    shadows: alat.teksShadow
                                  ),
                                ),
                                alat.bangunTeksGradien(
                                  teks: kProgress.jabatan!,
                                  warna: alat.progress, 
                                  font: alat.judul, 
                                  ukuranFont: 27,
                                  beratFont: FontWeight.bold
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
                            "${alat.teksUtamaProgressBar(kProgress)}: ",
                            style: TextStyle(
                              fontFamily: alat.judul,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: alat.teksKuning,
                              shadows: alat.teksShadow
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${(kBelajarProgressMateri / totalMateri * 100).toStringAsFixed(0)}%",
                                style: TextStyle(
                                  fontFamily: alat.teks,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: alat.teksKuning
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: alat.bangunProgressBar(
                                  context: context, 
                                  progresss: kBelajarProgressMateri / totalMateri,
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
      
    );
  }
}