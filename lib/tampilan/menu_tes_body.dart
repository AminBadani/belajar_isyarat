import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
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
    final kProgress = context.read<KontrolProgress>();
    final kMenu = context.read<KontrolMenu>();
    final alat = context.read<AlatApp>();
    final kTesNilai =  context.select<KontrolTes, List<int>> (
      (k) => k.semuaNilaiTes(kProgress)
    );

    return SizedBox.expand(
      child: Row(
        children: [
          alat.bangunTombolKembali(
            () {
              kTes.tutupMenuTes(kBelajar.modulSekarang);
              kMenu.bukaMenu(1);
            }
          ),
          SizedBox(width: 10),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
              decoration: BoxDecoration(
                color: alat.kotakUtama,
                borderRadius: BorderRadius.circular(25),
                boxShadow: alat.boxShadow,
              ),
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: alat.kotakPutih,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Expanded(child: SizedBox()),
                    Text(
                      alat.teksTesJudul(kProgress),
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
                      alat.teksTesPenjelasan(kProgress),
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
                          "${alat.teksTesNilai(kProgress)}:   ",
                          style: TextStyle(
                            fontFamily: alat.teks,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: alat.teksKuning,
                            shadows: alat.teksShadow
                          ),
                        ),
                        Text(
                          kTesNilai[kBelajar.modulSekarang - 1].toString(),
                          style: TextStyle(
                            fontFamily: alat.teks,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: kTesNilai[kBelajar.modulSekarang - 1] < 80 ? alat.salah : alat.benar,
                            shadows: alat.teksShadow
                          ),
                        ),
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
                          judulUkuran: 32,
                          judulWarna: alat.teksPutihSedang,
                          bayanganJudul: alat.teksShadow,
                          fontJudul: alat.judul,
                          kotakGradient: alat.terpilih,
                          tepiRadius: 10,
                          pakaiKlik: true,
                          pakaiHover: true,
                          padaHoverPemisahGarisLuarWarna: alat.garisLuarHoverAbu,
                          padaHoverAnimasi: padaHoverAnimasi1,
                          padaKlikAnimasi: padaKlikAnimasi1,
                          padaKlik: () {
                            kTes.bukaMenuTes(kBelajar.modulSekarang, kProgress);
                            kMenu.bukaMenu(4);
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
            ),
          )
          )
        ]
      )
    );
  }
}

class MenuTesSoalBody extends StatelessWidget {
  const MenuTesSoalBody({super.key});

  Widget blokPointer(Widget child, bool selesai) {
    if (selesai) {
      return IgnorePointer(
        child: child,
      );
    }
    return child;
  }

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
    final kTesSelesai = context.select<KontrolTes, bool>(
      (k) => kTes.tesSelesai
    );
    final kTesMenuSelesai = context.select<KontrolTes, bool>(
      (k) => kTes.menuSelesai
    );
    
    final soal = kTes.ambilSoalTes(kTes.modul, kTesSoal);
    final key = ValueKey(kTesSoal);


      final body = !kTesMenuSelesai
      ? switch (soal.mode.index) {
          0 => SoalModel1(
              key: key,
              penjelas: soal.pertanyaan,
              gambarSoal: soal.gambar,
              gambarOpsi: soal.opsi,
              padaSusun: (susunan) {
                kTes.aturSusunanJawabanListString(List.from(susunan));
                return;
              },
              susunan: kTesSusunanSatu,
              selesai: kTesSelesai,
              benar: kTesSelesai ? kTes.cekJawaban(kTes.modul, kTesSoal, kTesSusunanSatu) : false,
            ),
          1 => SoalModel2(
              key: key,
              penjelas: soal.pertanyaan,
              gambarSoal: soal.gambar,
              gambarOpsi: soal.opsi,
              padaKlik: (index) {
                final pilihan = kTes.aturPilihanKotak(index);
                return pilihan;
              },
              pilihan: kTesPilihanKotak,
              selesai: kTesSelesai,
              benar: kTesSelesai ? kTes.cekJawaban(kTes.modul, kTesSoal, soal.opsi.indexOf(kTesPilihanKotak - 1)) : false,
            ),
          2 => SoalModel3(
              key: key,
              penjelas: soal.pertanyaan,
              susunanSemua: kTesSusunanDua,
              padaSusun: (susunan) {
                kTes.aturSusunanJawabanListListString(susunan);
                return;
              },
              selesai: kTesSelesai,
              benar: kTesSelesai ? kTes.cekJawaban(kTes.modul, kTesSoal, kTesSusunanDua) : false,
            ),
          3 => SoalModel4(
              key: key,
              penjelas: soal.pertanyaan, 
              susunanAwal: soal.gambar, 
              susunanAtas: kTesSusunanAtas, 
              opsi: soal.opsi,
              padaSelesaiSusun: (susunan) {
                kTes.aturSusunanJawabanListDynamic(susunan[0]);
              },
              selesai: kTesSelesai,
              benar: kTesSelesai ? kTes.cekJawaban(kTes.modul, kTesSoal, kTesSusunanAtas) : false,
          ),
          4 => SoalModel5(
              key: key,
              penjelas: soal.pertanyaan,
              gambarSoal: soal.gambar, 
              panjangRangkaian: soal.jawaban.length, 
              rangkaian: kTesSusunanRangkaian.map((isi) => isi?.toString()).toList(),
              padaRangkai: (susunan) => kTes.aturSusunanJawabanListDynamic(susunan),
              selesai: kTesSelesai,
              benar: kTesSelesai ? kTes.cekJawaban(kTes.modul, kTesSoal, kTesSusunanRangkaian) : false,
          ),
          _ => SizedBox.shrink(),
        }
      : MenuTesSelesaiBody();

    final bodyAkhir = Row(
      children: [
        alat.bangunTombolKembali(
          () {
            kMenu.bukaMenu(3);
            return;
          }
        ),
        SizedBox(width: 10),

        Expanded(
          child: kTesMenuSelesai ? alat.bangunAnimasi(child: body, key: key) : alat.bangunAnimasi(child:blokPointer(body, kTesSelesai), key: key ) ,
        )
      ],
    );

    return bodyAkhir;
  }
}


class MenuTesSelesaiBody extends StatelessWidget {
  const MenuTesSelesaiBody({super.key});

  @override
  Widget build(BuildContext context) {
    final kTes = context.read<KontrolTes>();
    final kBelajar = context.read<KontrolBelajar>();
    final kProgress = context.read<KontrolProgress>();
    final kMenu = context.read<KontrolMenu>();
    final alat = context.read<AlatApp>();
    final kTesNilai = context.select<KontrolTes, int> (
      (k) => k.nilaiTes
    );

    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
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
            Expanded(child: SizedBox()),
            Text(
              alat.teksTesSelesaiJudul(kProgress),
              style: TextStyle(
                fontFamily: alat.judul,
                color: alat.teksKuning,
                fontSize: 37,
                fontWeight: FontWeight.bold,
                shadows: alat.teksShadow
              ),
            ),
            SizedBox(height: 20),
            
            Padding(
              padding: EdgeInsetsGeometry.only(left: 70, right: 70),
                child: Text(
                kTesNilai < 60 
                  ? alat.teksTesSelesaiPenjelas1(kProgress)
                : kTesNilai < 75
                  ? alat.teksTesSelesaiPenjelas2(kProgress)
                : kTesNilai < 89
                  ? alat.teksTesSelesaiPenjelas3(kProgress)
                : kTesNilai >= 90
                  ? alat.teksTesSelesaiPenjelas4(kProgress)
                  : "",
                style: TextStyle(
                  fontFamily: alat.teks,
                  fontSize: 20,
                  color: alat.teksHitam,
                  shadows: alat.teksShadow
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${alat.teksTesSelesaiJawabanBenar(kProgress)}:   ",
                  style: TextStyle(
                    fontFamily: alat.teks,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: alat.teksKuning,
                    shadows: alat.teksShadow
                  ),
                ),
                Text(
                  kTes.jawabanBenar.toString(),
                  style: TextStyle(
                    fontFamily: alat.teks,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: kTesNilai < 80 ? alat.salah : alat.benar,
                    shadows: alat.teksShadow
                  ),
                ),
                Text(
                  " / ${kTes.totalSoal.toString()}",
                  style: TextStyle(
                    fontFamily: alat.teks,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: alat.teksHitam,
                    shadows: alat.teksShadow
                  ),
                ),
              ],
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${alat.teksTesNilai(kProgress)}:   ",
                  style: TextStyle(
                    fontFamily: alat.teks,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: alat.teksKuning,
                    shadows: alat.teksShadow
                  ),
                ),
                Text(
                  kTesNilai.toString(),
                  style: TextStyle(
                    fontFamily: alat.teks,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: kTesNilai < 80 ? alat.salah : alat.benar,
                    shadows: alat.teksShadow
                  ),
                ),
              ],
            ),
            
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CardStatis(
                  lebar: 300,
                  tinggi: 80,
                  padding: 10,
                  isiTengah: true,
                  pemisahGarisLuarUkuran: 7,
                  judul: alat.teksTombolUlang(kProgress),
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
                    kTes.tutupMenuTes(kBelajar.modulSekarang);
                    kMenu.bukaMenu(3);
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