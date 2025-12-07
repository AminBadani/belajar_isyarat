import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
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
    final kBelajar = context.read<KontrolBelajar>();
    final kMenu = context.read<KontrolMenu>();
    final alat = context.read<AlatApp>();
    final kTesNilai = context.select<KontrolProgress, int> (
      (k) => k.ambilSatuNilaiTes(kBelajar.modulSekarang)
    );

    return Padding (
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CardStatis(
            lebar: 40,
            tinggi: null,
            padding: 4,
            tepiRadius: 5,
            kotakGradient: alat.gradientKembali,
            pemisahGarisLuarUkuran: 4,
            teks: "<",
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi1,
            padaHoverPemisahGarisLuarWarna: alat.garisLuarHoverAbu,
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
                color: alat.kotakUtama,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: alat.kotakPutih,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Menu Tes",
                      style: TextStyle(
                        fontFamily: alat.judul,
                        color: alat.teksKuning,
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    Text(
                      "Tes adalah langkah terakhir untuk menyelesaikan progress materi.\n"
                      "Kemampuan anda akan diuji disini, anda dapat mengerjakan tes berulang-kali",
                      style: TextStyle(
                        fontFamily: alat.teks,
                        fontSize: 20,
                        color: alat.teksHitam
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Nilai Anda:   ",
                          style: TextStyle(
                            fontFamily: alat.teks,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: alat.teksKuning
                          ),
                        ),
                        Text(
                          kTesNilai.toString(),
                          style: TextStyle(
                            fontFamily: alat.teks,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: kTesNilai < 80 ? alat.salah : alat.benar
                          ),
                        ),
                      ],
                    ),
                    
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CardStatis(
                          lebar: 120,
                          tinggi: 80,
                          padding: 10,
                          isiTengah: true,
                          pemisahGarisLuarUkuran: 7,
                          judul: "Mulai",
                          judulUkuran: 32,
                          judulWarna: alat.teksPutihSedang,
                          fontJudul: alat.judul,
                          kotakGradient: alat.terpilih,
                          tepiRadius: 10,
                          pakaiKlik: true,
                          pakaiHover: true,
                          padaHoverPemisahGarisLuarWarna: alat.kotakUtama,
                          padaHoverAnimasi: padaHoverAnimasi1,
                          padaKlikAnimasi: padaKlikAnimasi1,
                          padaKlik: () {
                            kMenu.bukaMenu(4);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10)
                  ]
                ),
              ),
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
    final alat = context.read<AlatApp>();

    final kTesPilihanKotak = context.select<KontrolTes, int>(
      (k) => kTes.pilihanKotak
    );
    final kTesSusunanSatu = context.select<KontrolTes, List<String>>(
      (k) => kTes.susunanJawabanListString
    );
    final kTesSusunanDua = context.select<KontrolTes, List<List<String>>>(
      (k) => kTes.susunanJawabanListListString
    );
    final kTesSusunanAtas = context.select<KontrolTes, List<dynamic>>(
      (k) => kTes.susunanJawabanListDynamic
    );
    final kTesSusunanRangkaian = context.select<KontrolTes, List<dynamic>>(
      (k) => kTes.susunanJawabanListDynamic
    );
    
    final soal = kTes.ambilSoalTes(kTes.modul, kTesSoal);

    final body = switch (soal.mode.index) {
      0 => SoalModel1(
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar,
          gambarOpsi: soal.opsi,
          padaSusun: (susunan) {
            kTes.aturSusunanJawabanListString(List.from(susunan));
            return;
          },
          susunan: kTesSusunanSatu,
        ),
      1 => SoalModel2(
          penjelas: soal.pertanyaan,
          gambarSoal: soal.gambar,
          gambarOpsi: soal.opsi,
          padaKlik: (index) {
            final pilihan = kTes.aturPilihanKotak(index);
            return pilihan;
          },
          pilihan: kTesPilihanKotak,
        ),
      2 => SoalModel3(
          penjelas: soal.pertanyaan,
          susunanSemua: kTesSusunanDua,
          padaSusun: (susunan) {
            kTes.aturSusunanJawabanListListString(susunan);
            return;
          },
        ),
      3 => SoalModel4(
        penjelas: soal.pertanyaan, 
        susunanAwal: soal.gambar, 
        susunanAtas: kTesSusunanAtas, 
        opsi: soal.opsi,
        padaSelesaiSusun: (susunan) {
          kTes.aturSusunanJawabanListDynamic(susunan[0]);
        },
      ),
      4 => SoalModel5(
        penjelas: soal.pertanyaan,
        gambarSoal: soal.gambar, 
        panjangRangkaian: soal.jawaban.length, 
        rangkaian: kTesSusunanRangkaian.map((isi) => isi?.toString()).toList(),
        padaRangkai: (susunan) => kTes.aturSusunanJawabanListDynamic(susunan),
      ),
      _ => SizedBox.shrink(),
    };

    final bodyAkhir = Row(
      children: [
        CardStatis(
          lebar: 40,
          tinggi: null,
          padding: 4,
          tepiRadius: 5,
          kotakGradient: alat.gradientKembali,
          pemisahGarisLuarUkuran: 4,
          teks: "<",
          pakaiKlik: true,
          pakaiHover: true,
          padaHoverAnimasi: padaHoverAnimasi1,
          padaHoverPemisahGarisLuarWarna: alat.garisLuarHoverAbu,
          padaKlikAnimasi: padaKlikAnimasi1,
          padaKlik: () {
            kTes.tutupMenuTes();
            kMenu.bukaMenu(3);
            return;
          }
        ),
        SizedBox(width: 10),

        Expanded(
          child: body
        )
      ],
    );

    return bodyAkhir;
  }
}