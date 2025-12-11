import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_menu.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/soal_model.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuKuisMenuBody extends StatelessWidget {
  const MenuKuisMenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kProgress = context.read<KontrolProgress>();
    final kMenu = context.read<KontrolMenu>();
    final kKuis = context.read<KontrolKuis>();
    final alat = context.read<AlatApp>();
    final kKuisProgressKuis = context.select<KontrolKuis, int> (
      (k) => k.skorKuis(kProgress)
    );

    return Container(
          decoration: BoxDecoration(
            color: alat.kotakUtama,
            borderRadius: BorderRadius.circular(25),
            boxShadow: alat.boxShadow
          ),
          padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: alat.kotakPutih,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: SizedBox()),
                Text(
                  alat.teksKuisJudul(kProgress),
                  style: TextStyle(
                    fontFamily: alat.judul,
                    color: alat.teksKuning,
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    shadows: alat.teksShadow
                  ),
                ),
                SizedBox(height: 20),
                
                Text(
                  alat.teksKuisPenjelasan(kProgress),
                  style: TextStyle(
                    fontFamily: alat.teks,
                    fontSize: 20,
                    color: alat.teksHitam,
                    shadows: alat.teksShadow
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${alat.teksFooterSkor(kProgress)}:   ",
                      style: TextStyle(
                        fontFamily: alat.teks,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: alat.teksKuning,
                        shadows: alat.teksShadow
                      ),
                    ),
                    alat.bangunTeksGradien(
                      font: alat.teks,
                      teks: kKuisProgressKuis.toString(),
                      ukuranFont: 27,
                      beratFont: FontWeight.bold,
                      warna: alat.progress,
                    )
                  ],
                ),
                
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CardStatis(
                      lebar: 120,
                      tinggi: 80,
                      padding: 10,
                      isiTengah: true,
                      pemisahGarisLuarUkuran: 7,
                      judul: alat.teksTombolMulai(kProgress),
                      bayanganJudul: alat.teksShadow,
                      judulUkuran: 32,
                      judulWarna: alat.teksPutihSedang,
                      fontJudul: alat.judul,
                      kotakGradient: alat.terpilih,
                      tepiRadius: 10,
                      pakaiKlik: true,
                      pakaiHover: true,
                      padaHoverPemisahGarisLuarWarna: alat.garisLuarHoverAbu,
                      padaHoverAnimasi: padaHoverAnimasi1,
                      padaKlikAnimasi: padaKlikAnimasi1,
                      padaKlik: () {
                        kKuis.bukaMenuKuis(kProgress);
                        kMenu.bukaMenu(6);
                      },
                      bayanganKotak: alat.boxShadow,
                      padaHoverBayanganPemisahGarisLuar: alat.boxShadowHover,
                    ),
                  ),
                ),
                SizedBox(height: 10)
              ]
            ),
          ),
    );
  }
}

class MenuKuisSoalBody extends StatelessWidget {
  const MenuKuisSoalBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kKuis = context.read<KontrolKuis>();
    final alat = context.read<AlatApp>();
    final kKuisSoal = context.select<KontrolKuis, int>(
      (k) => k.ambilAwalAntrianKuis
    );
    final kKuisPilihanKotak = context.select<KontrolKuis, int>(
      (k) => kKuis.pilihanKotak
    );
    final kKuisSusunanSatu = context.select<KontrolKuis, List<String>>(
      (k) => kKuis.susunanJawabanListString
    );
    final kKuisSusunanDua = context.select<KontrolKuis, List<List<String>>>(
      (k) => kKuis.susunanJawabanListListString
    );
    final kKuisSusunanAtas = context.select<KontrolKuis, List<dynamic>>(
      (k) => kKuis.susunanJawabanListDynamic
    );
    final kKuisSusunanRangkaian = context.select<KontrolKuis, List<dynamic>>(
      (k) => kKuis.susunanJawabanListDynamic
    );
    final key = ValueKey(kKuisSoal);

    final soal = kKuis.ambilKuis(kKuisSoal + 1);

    final body = switch (soal.mode.index) {
      0 => SoalModel1(
          key: key,
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar,
          gambarOpsi: soal.opsi,
          padaSusun: (susunan) {
            kKuis.aturSusunanJawabanListString(List.from(susunan));
            return;
          },
          susunan: kKuisSusunanSatu,
          selesai: false,
        ),
      1 => SoalModel2(
          key: key,
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar,
          gambarOpsi: soal.opsi,
          padaKlik: (index) {
            final pilihan = kKuis.aturPilihanKotak(index);
            return pilihan;
          },
          pilihan: kKuisPilihanKotak,
        ),
      2 => SoalModel3(
          key: key,
          penjelas: soal.pertanyaan,
          susunanSemua: kKuisSusunanDua,
          padaSusun: (susunan) {
            kKuis.aturSusunanJawabanListListString(susunan);
            return;
          },
        ),
      3 => SoalModel4(
          key: key,
          penjelas: soal.pertanyaan, 
          susunanAwal: soal.gambar, 
          susunanAtas: kKuisSusunanAtas, 
          opsi: soal.opsi,
          padaSelesaiSusun: (susunan) {
            kKuis.aturSusunanJawabanListDynamic(susunan[0]);
          },
        ),
      4 => SoalModel5(
            key: key,
            penjelas: soal.pertanyaan,
            gambarSoal: soal.gambar, 
            panjangRangkaian: soal.jawaban.length, 
            rangkaian: kKuisSusunanRangkaian.map((isi) => isi?.toString()).toList(),
            padaRangkai: (susunan) => kKuis.aturSusunanJawabanListDynamic(susunan),
          ),
      _ => SizedBox.shrink()
    };

    return alat.bangunAnimasi(child: body, key: key);
  }
}