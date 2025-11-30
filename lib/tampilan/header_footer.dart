import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../kontrol/kontrol_menu.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({super.key, this.title = "Belajar Isyarat"});

  @override
  Widget build(BuildContext context) {
    final kontrolMenu = context.watch<KontrolMenu>();
    final kontrolDatabase = context.read<KontrolDatabase>();
    final alatApp = context.read<AlatApp>();

    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        titleSpacing: 10,
        title: Container(
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: kontrolDatabase.ambilGambar("lib/database/gambar/placeholder.png"),
                        ),
                        SizedBox(width: 10),

                        CardStatis(
                          lebar: 180,
                          tinggi: 40,
                          padding: 5,
                          tepiRadius: 5,
                          isiTengah: true,
                          judul: "Belajar Isyarat",
                          judulUkuran: 27,
                          judulWarna: kontrolMenu.halaman == 8 ? alatApp.teksKuning : alatApp.teksPutihSedang,
                          fontJudul: alatApp.namaAplikasi,
                          teksTengah: true,
                          garisBawahJudul: true,
                          kotakWarna: kontrolMenu.halaman == 8 ? alatApp.kotakPutih : Colors.transparent,
                          pakaiKlik: true,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi2,
                          padaKlikAnimasi: padaKlikAnimasi1,
                          padaKlik: () {
                            kontrolMenu.bukaMenu(8);
                          },
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
                        padding: 5,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: "Belajar",
                        judulUkuran: 20,
                        judulWarna: kontrolMenu.halaman == 0 
                          || kontrolMenu.halaman == 1 
                          || kontrolMenu.halaman == 2 
                          || kontrolMenu.halaman == 3 
                          || kontrolMenu.halaman == 4 ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: kontrolMenu.halaman == 0 
                          || kontrolMenu.halaman == 1 
                          || kontrolMenu.halaman == 2 
                          || kontrolMenu.halaman == 3 
                          || kontrolMenu.halaman == 4 ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          kontrolMenu.bukaMenu(0);
                        },
                      ),
                      SizedBox(width: 10),

                      CardStatis(
                        lebar: 100,
                        tinggi: 40,
                        padding: 5,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: "Kuis",
                        judulUkuran: 20,
                        judulWarna: kontrolMenu.halaman == 5 || kontrolMenu.halaman == 6 ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: kontrolMenu.halaman == 5 || kontrolMenu.halaman == 6 ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          kontrolMenu.bukaMenu(5);
                        },
                      ),
                      SizedBox(width: 10),

                      CardStatis(
                        lebar: 100,
                        tinggi: 40,
                        padding: 5,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: "Progress",
                        judulUkuran: 20,
                        judulWarna: kontrolMenu.halaman == 7 ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: kontrolMenu.halaman == 7 ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          kontrolMenu.bukaMenu(7);
                        },
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CardStatis(
                        lebar: 100,
                        tinggi: 40,
                        padding: 5,
                        tepiRadius: 5,
                        isiTengah: true,
                        judul: "Bantuan",
                        judulUkuran: 20,
                        judulWarna: kontrolMenu.halaman == 9 ? alatApp.teksKuning : alatApp.teksPutihSedang,
                        fontJudul: alatApp.judul,
                        kotakWarna: kontrolMenu.halaman == 9 ? alatApp.kotakPutih : Colors.transparent,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi2,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: () {
                          //kontrolMenu.bukaMenu(9);
                        },
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
  late AnimationController _controller;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _hoverJawab = false;

  @override
  Widget build(BuildContext context) {
    final kontrolKuisSkorKuis = context.select<KontrolKuis, int>(
      (k) => k.skorKuis
    );
    final kontrolKuisNilaiJawaban = context.select<KontrolKuis, int>(
      (k) => k.cekNilaiKuis(true)
    );
    final kontrolKuis = context.read<KontrolKuis>();
    final kontrolProgress = context.read<KontrolProgress>();

    final padaJawab = [
      () => kontrolKuis.ajukanKuis(kontrolProgress)
    ];

    _scoreAnimation = IntTween(
      begin: kontrolKuisSkorKuis,
      end: kontrolKuisSkorKuis + kontrolKuisNilaiJawaban,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Foto + skor animasi
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(width: 16),

              // Animasi skor
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Text(
                    "Skor: ${_scoreAnimation.value} + $kontrolKuisNilaiJawaban",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),

          // Tombol Jawab
          MouseRegion(
            onEnter: (_) => setState(() => _hoverJawab = true),
            onExit: (_) => setState(() => _hoverJawab = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                for (var fungsi in padaJawab) {
                  fungsi();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      _hoverJawab ? Colors.blue.shade600 : Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _hoverJawab
                      ? [BoxShadow(color: Colors.black26, blurRadius: 6)]
                      : [],
                ),
                child: const Text(
                  "Jawab",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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
  bool _hoverPrev = false;
  bool _hoverNext = false;

  @override
  Widget build(BuildContext context) {
    final kontrolProgress = context.read<KontrolProgress>();

    late int sekarang;
    late int total;
    late double progress;
    late List<VoidCallback> padaSebelumnya;
    late List<VoidCallback> padaSelanjutnya;
    late bool akhirSebelumnya;
    late String akhirSelanjutnya;

    if (widget.belajar) {
      final kBelajar = context.read<KontrolBelajar>();
      final kMenu = context.read<KontrolMenu>();
      sekarang = context.select<KontrolBelajar, int>((k) => k.materiSekarang);
      total = kBelajar.totalMateri;
      progress = sekarang / total;

      padaSebelumnya = [() => kBelajar.aturMateriSebelumnya()];
      padaSelanjutnya = sekarang != total 
        ? [() => kBelajar.aturMateriSelanjutnya(kontrolProgress)]
        : [
          () => kBelajar.tutupMenuMateri(),
          () => kMenu.bukaMenu(1),
        ];

      akhirSebelumnya = sekarang == 1 ? true : false;
      akhirSelanjutnya = sekarang == total ? "Keluar" : "Selanjutnya";
    } else {
      final kTes = context.read<KontrolTes>();
      sekarang = context.select<KontrolTes, int>((k) => k.soal);
      total = kTes.totalSoal;
      progress = sekarang / total;

      padaSebelumnya = [() => kTes.aturSoalSebelumnya()];
      padaSelanjutnya = sekarang < total
          ? [() => kTes.aturSoalSelanjutnya()]
          : [() => kTes.ajukanTes(kontrolProgress)];

      akhirSebelumnya = sekarang == 1 ? true : false;
      akhirSelanjutnya = sekarang == total ? "Kumpul Tes" : "Selanjutnya";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Angka progress
          Text(
            "$sekarang/$total",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),

          // Progress Bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 15,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    AlwaysStoppedAnimation(Colors.blue.shade400),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Tombol Sebelumnya
          CardStatis(
            lebar: 100, 
            tinggi: 40,
            padding: 10,
            tepiRadius: 10,
            garisLuarUkuran: 3,
            judul: "Sebelumnya",
            judulUkuran: 10,
            judulWarna: Colors.white54,
            teksTengah: true,
            kotakWarna: akhirSebelumnya ? Colors.blueGrey : Colors.blue,
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi2,
            padaHoverGarisLuarWarna: Colors.white,
            padaHoverPakaiBayangan: true,
            padaKlikAnimasi: padaKlikAnimasi1,
            padaKlik: () {
              for (var fungsi in padaSebelumnya) {
                fungsi();
              }
            },
          ),
          const SizedBox(width: 10),

          // Tombol Selanjutnya
          CardStatis(
            lebar: 100, 
            tinggi: 40,
            padding: 10,
            tepiRadius: 10,
            garisLuarUkuran: 3,
            judul: akhirSelanjutnya,
            judulUkuran: 10,
            judulWarna: Colors.white54,
            teksTengah: true,
            kotakWarna: Colors.blue,
            pakaiKlik: true,
            pakaiHover: true,
            padaHoverAnimasi: padaHoverAnimasi2,
            padaHoverGarisLuarWarna: Colors.white,
            padaHoverPakaiBayangan: true,
            padaKlikAnimasi: padaKlikAnimasi1,
            padaKlik: () {
              for (var fungsi in padaSelanjutnya) {
                fungsi();
              }
            },
          ),
        ],
      ),
    );
  }
}