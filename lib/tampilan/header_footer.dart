import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_log.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/lingkaran.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../kontrol/kontrol_menu.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final kontrolMenu = context.watch<KontrolMenu>();
    final kontrolDatabase = context.read<KontrolDatabase>();
    final alatApp = context.read<AlatApp>();
    final kProgress = context.read<KontrolProgress>();
    final kBelajar = context.read<KontrolBelajar>();
    final kTes = context.read<KontrolTes>();

    final menuTentang = kontrolMenu.halaman == 8;
    final menuBelajar = kontrolMenu.halaman == 0 
                          || kontrolMenu.halaman == 1 
                          || kontrolMenu.halaman == 2 
                          || kontrolMenu.halaman == 3 
                          || kontrolMenu.halaman == 4;

    final menuKuis = kontrolMenu.halaman == 5 || kontrolMenu.halaman == 6;
    final menuProgres = kontrolMenu.halaman == 7;
    final menuPengaturan = kontrolMenu.halaman == 9;

    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        elevation: 1,
        titleSpacing: 10,
        flexibleSpace: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
            gradient: alatApp.warnaHeader,
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: alatApp.kotakPutih,
                            shape: BoxShape.circle,
                            boxShadow: alatApp.boxShadow,
                          ),
                          child: kontrolDatabase.ambilGambar("placeholder"),
                        ),
                        SizedBox(width: 10),

                        CardStatis(
                          lebar: 200,
                          tinggi: 40,
                          tepiRadius: 5,
                          isiTengah: true,
                          judul: alatApp.teksAplikasi(kProgress),
                          judulUkuran: 22,
                          judulWarna: menuTentang ? alatApp.teksKuning : alatApp.teksPutihSedang,
                          fontJudul: alatApp.namaAplikasi,
                          garisBawahJudul: true,
                          kotakWarna: menuTentang ? alatApp.kotakPutih : Colors.transparent,
                          pakaiKlik: true,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi2,
                          padaKlikAnimasi: padaKlikAnimasi1,
                          padaKlik: () {
                            kontrolMenu.bukaMenu(8);
                          },
                          bayanganKotak: menuTentang ? alatApp.boxShadow : null,
                          padaHoverBayanganKotak: menuTentang ? alatApp.boxShadow : null,
                          bayanganJudul: alatApp.teksShadow,
                        )
                      ]
                    ),
                  ),
                ),
                
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CardStatis(
                        lebar: 100,
                        tinggi: 40,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: alatApp.teksHeaderBelajar(kProgress),
                        judulUkuran: 20,
                        judulWarna: menuBelajar ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: menuBelajar ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          kontrolMenu.bukaMenu(0);
                        },
                        bayanganKotak: menuBelajar ? alatApp.boxShadow : null,
                        padaHoverBayanganKotak: menuBelajar ? alatApp.boxShadow : null,
                        bayanganJudul: alatApp.teksShadow,
                      ),
                      SizedBox(width: 10),

                      CardStatis(
                        lebar: 100,
                        tinggi: 40,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: alatApp.teksHeaderKuis(kProgress),
                        judulUkuran: 20,
                        judulWarna: menuKuis ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: menuKuis ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          kontrolMenu.bukaMenu(5);
                        },
                        bayanganKotak: menuKuis ? alatApp.boxShadow : null,
                        padaHoverBayanganKotak: menuKuis ? alatApp.boxShadow : null,
                        bayanganJudul: alatApp.teksShadow,
                      ),
                      SizedBox(width: 10),

                      CardStatis(
                        lebar: 100,
                        tinggi: 40,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: alatApp.teksHeaderProgres(kProgress),
                        judulUkuran: 20,
                        judulWarna: menuProgres ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: menuProgres ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          kontrolMenu.bukaMenu(7);
                        },
                        bayanganKotak: menuProgres ? alatApp.boxShadow : null,
                        padaHoverBayanganKotak: menuProgres ? alatApp.boxShadow : null,
                        bayanganJudul: alatApp.teksShadow,
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CardStatis(
                        lebar: 140,
                        tinggi: 40,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: alatApp.teksHeaderPengaturan(kProgress),
                        judulUkuran: 20,
                        judulWarna: menuPengaturan ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: menuPengaturan ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          kontrolMenu.bukaMenu(9);
                        },
                        bayanganKotak: menuPengaturan ? alatApp.boxShadow : null,
                        padaHoverBayanganKotak: menuPengaturan ? alatApp.boxShadow : null,
                        bayanganJudul: alatApp.teksShadow,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// == FOOTER == MODEL 1 == KUIS
class FooterModel1 extends StatefulWidget {
  const FooterModel1({
    super.key,
  });

  @override
  State<FooterModel1> createState() => _FooterModel1State();
}

class _FooterModel1State extends State<FooterModel1>
    with SingleTickerProviderStateMixin {
  late VoidCallback padaJawab;
  bool gagal = false;
  bool animasiSkor = false;
  int nilaiJawaban = 0;
  bool jawabanBenar = false;

  void trigger() async {
    setState(() => gagal = true);
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() => gagal = false);
  }
  void animasikanSkor() async {
    setState(() => animasiSkor = true);
    await Future.delayed(Duration(milliseconds: 1500));
    if (mounted) setState(() => animasiSkor = false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final kLog = context.read<KontrolLog>();
    final kKuis = context.read<KontrolKuis>();
    final kProgress = context.read<KontrolProgress>();
    final alat = context.read<AlatApp>();
    final kDatabase = context.read<KontrolDatabase>();
    final kKuisSkorKuis = context.select<KontrolKuis, int>(
      (k) => k.skorKuis(kProgress)
    );

    padaJawab = () {
      if (kKuis.cekSatuKuisSelesai()) {
        nilaiJawaban = kKuis.ajukanKuis(kProgress, kLog, kDatabase);
        jawabanBenar = kKuis.cekJawaban(kKuis.susunanJawabanListDynamic);
        animasikanSkor();
        kKuis.aturSoalSelanjutnya(kProgress);
      } else {
        trigger();
      }
    };

    return Container(
      height: alat.ukuranFooter,
      width: double.maxFinite,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        gradient: alat.warnaHeader,
      ),
      child: Row(
        children: [
          // Foto + skor animasi
          Expanded(
            child: Row(
              children: [
                SizedBox(width: 10,),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: alat.kotakPutih,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: alat.boxShadow
                  ),
                  child: kDatabase.ambilGambar("trophy.png"),
                ),
                const SizedBox(width: 16),

                alat.bangunAnimasi(
                  key: ValueKey("$kKuisSkorKuis$animasiSkor"),
                  child: Row(
                    children: [
                      Text(
                        "${alat.teksFooterSkor(kProgress)}: ",
                        style: TextStyle(
                          color: alat.teksPutihSedang,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          shadows: alat.judulShadow,
                          fontFamily: alat.judul
                        ),
                      ),
                      alat.bangunTeksGradien(
                        teks: "$kKuisSkorKuis${animasiSkor ? " + $nilaiJawaban" : ""}", 
                        warna: alat.progress, 
                        font: alat.judul, 
                        ukuranFont: 27,
                        beratFont: FontWeight.bold
                      ),
                      SizedBox(width: 30,),
                      if (animasiSkor)
                        alat.bangunAnimasi(
                          key: ValueKey("$kKuisSkorKuis$animasiSkor"),
                            child: Lingkaran(
                            besar: 40, 
                            besarGarisLuar: 7, 
                            warnaGarisLuar: alat.kotakPutih, 
                            benarSalahNetral: jawabanBenar ? 1 : 2, 
                            warnaLingkaran: jawabanBenar ? alat.benar : alat.salah, 
                            warnaSimbolAngka: alat.teksPutihSedang,
                            )
                          )
                    ],
                  ),
                )
              ]
            )
          ),

          // Tombol Jawab
          CardStatis(
            lebar: 140,
            tinggi: 55,
            isiTengah: true,
            padding: 10,
            tepiRadius: 10,
            pemisahGarisLuarUkuran: 4,
            pemisahGarisLuarWarna: gagal ? alat.salah : null,
            garisLuarUkuran: 4,
            judul: alat.teksFooterJawab(kProgress),
            judulUkuran: 14,
            fontJudul: alat.judul,
            judulWarna: alat.teksPutihSedang,
            kotakGradient: alat.terpilih,
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi2,
            padaHoverPemisahGarisLuarWarna: gagal ? null : alat.garisLuarHoverAbu,
            padaHoverGarisLuarWarna: gagal ? alat.garisLuarHoverAbu : null,
            padaKlikAnimasi: padaKlikAnimasi1,
            padaKlik: () {
              padaJawab();
            },
            bayanganKotak: alat.boxShadow,
            padaHoverBayanganPemisahGarisLuar: alat.boxShadowHover,
            bayanganJudul: alat.teksShadow,
          ),
          SizedBox(width: 10,)
        ],
      ),
    );
  }
}

// == FOOTER == MODEL 2
class FooterModel2 extends StatefulWidget {
  final bool belajar;

  const FooterModel2({
    super.key,
    required this.belajar,
  });

  @override
  State<FooterModel2> createState() => _FooterModel2State();
}

class _FooterModel2State extends State<FooterModel2> {
  bool gagal = false;

  void trigger() async {
    setState(() => gagal = true);
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() => gagal = false);
  }

  @override
  Widget build(BuildContext context) {
    final kBelajar = context.read<KontrolBelajar>();
    final kMenu = context.read<KontrolMenu>();
    final kLog = context.read<KontrolLog>();
    final kProgress = context.read<KontrolProgress>();
    final alat = context.read<AlatApp>();
    final kTes = context.read<KontrolTes>();
    final kDatabase = context.read<KontrolDatabase>();

    late int sekarang;
    late int total;
    late double progress;
    late VoidCallback padaSebelumnya;
    late VoidCallback padaSelanjutnya;
    late bool akhirSebelumnya;
    late bool akhirSelanjutnya;
    late String teksAkhirSelanjutnya;
    late bool menuSelesai;

    if (widget.belajar) {
      sekarang = context.select<KontrolBelajar, int>((k) => k.materiSekarang);
      total = kBelajar.totalMateriSekarang;
      progress = sekarang / total;

      padaSebelumnya = () {kBelajar.aturMateriSebelumnya(kProgress, kLog, kDatabase);};
      padaSelanjutnya = () {
        if (sekarang == total) {
          kBelajar.tutupMenuMateri();
          kMenu.bukaMenu(1);
          return;
        }
        kBelajar.aturMateriSelanjutnya(kProgress, kLog, kDatabase);
      };

      akhirSebelumnya = sekarang == 1 ? true : false;
      akhirSelanjutnya = sekarang == 0 ? true : false;
      teksAkhirSelanjutnya = sekarang == total ? alat.teksFooterKeluar(kProgress) : alat.teksFooterSelanjutnya(kProgress);
      menuSelesai = false;
    } else {
      sekarang = context.select<KontrolTes, int>((k) => k.soal);
      menuSelesai = context.select<KontrolTes, bool>((k) => k.menuSelesai);
      total = kTes.totalSoal;
      progress = sekarang / total;

      padaSebelumnya = () {
        if (sekarang == total && kTes.menuSelesai) {
          kTes.keluarMenuSelesai();
          return;
        }
        kTes.aturSoalSebelumnya();
      };
      padaSelanjutnya = () {
        if (!kTes.tesSelesai && sekarang == total) {
          kTes.jawabSoal(notify: true);
          if (kTes.cekSemuaTesSelesai()) {
            kTes.ajukanTes(kProgress, kLog, kDatabase);
            return;
          } else {
            trigger();
            return;
          }
        }
        if (sekarang == total) {
          kTes.masukMenuSelesai();
          return;
        }
        kTes.aturSoalSelanjutnya();
      };
      akhirSebelumnya = sekarang == 1 ? true : false;
      akhirSelanjutnya = sekarang == total && kTes.menuSelesai ? true : false;
      teksAkhirSelanjutnya = sekarang >= total ? alat.teksFooterKumpul(kProgress) : alat.teksFooterSelanjutnya(kProgress);
    }

    return Container(
      height: alat.ukuranFooter,
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        gradient: alat.warnaHeader,
      ),
      child: Row(
        children: [
          // Angka progress
          Text(
            "$sekarang/$total",
            style: TextStyle(
              fontFamily: alat.judul,
              fontSize: 16, 
              fontWeight: FontWeight.bold,
              color: alat.teksPutihSedang,
              shadows: alat.judulShadow
            ),
          ),
          const SizedBox(width: 16),

          // Progress Bar
          Expanded(
            child: alat.bangunProgressBar(
              context: context,
              progresss: progress, 
              tinggi: 20
            )
          ),
          const SizedBox(width: 16),

          // Tombol Sebelumnya
          CardStatis(
            lebar: 100, 
            tinggi: 40,
            isiTengah: true,
            tepiRadius: 10,
            pemisahGarisLuarUkuran: 4,
            judul: alat.teksFooterSebelumnya(kProgress),
            judulUkuran: 10,
            fontJudul: alat.judul,
            judulWarna: alat.teksHitam,
            judulGradient: akhirSebelumnya ? null : alat.terpilih,
            kotakWarna: akhirSebelumnya ? alat.tidakAktif : alat.kotakPutih,
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi2,
            padaHoverPemisahGarisLuarWarna: akhirSebelumnya ? null : alat.garisLuarHoverAbu,
            padaKlikAnimasi: padaKlikAnimasi1,
            padaKlik: () {
              padaSebelumnya();
            },
            bayanganKotak: alat.boxShadow,
            padaHoverBayanganPemisahGarisLuar: alat.boxShadowHover,
            bayanganJudul: alat.teksShadow,
          ),
          const SizedBox(width: 10),

          // Tombol Selanjutnya
          CardStatis(
            lebar: 100, 
            tinggi: 40,
            isiTengah: true,
            tepiRadius: 10,
            pemisahGarisLuarUkuran: 4,
            pemisahGarisLuarWarna: gagal ? alat.salah : null,
            judul: teksAkhirSelanjutnya,
            judulUkuran: 10,
            fontJudul: alat.judul,
            judulWarna: akhirSelanjutnya ? alat.teksHitam : alat.teksPutihSedang,
            kotakWarna: akhirSelanjutnya ? alat.tidakAktif : null,
            kotakGradient: akhirSelanjutnya ? null : alat.terpilih,
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi2,
            padaHoverPemisahGarisLuarWarna: gagal ? null : (akhirSelanjutnya ? null : alat.garisLuarHoverAbu),
            padaHoverGarisLuarWarna: gagal ? alat.garisLuarHoverAbu : null,
            padaKlikAnimasi: padaKlikAnimasi1,
            padaKlik: () {
              padaSelanjutnya();
            },
            bayanganKotak: alat.boxShadow,
            padaHoverBayanganPemisahGarisLuar: alat.boxShadowHover,
            bayanganJudul: alat.teksShadow,
          ),
        ],
      ),
    );
  }
}