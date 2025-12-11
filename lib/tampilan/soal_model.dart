import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/lingkaran.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SoalModel2 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarOpsi;
  final bool benar;

  final int Function(int index)? padaKlik;
  final int pilihan;
  final bool selesai;


  const SoalModel2({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarOpsi,
    this.padaKlik,
    this.pilihan = 0,
    this.selesai = false,this.benar = false
  });

  @override
  State<SoalModel2> createState() => _SoalModel2State();
}

class _SoalModel2State extends State<SoalModel2> {
  late AlatApp alat;
  List<String> gambarSoal = [];

  @override
  void initState() {
    super.initState();
    alat = context.read<AlatApp>();
    
    for (var gambar in widget.gambarSoal) {
      gambarSoal.add(gambar.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> gambarSoal = [];
    for (var gambar in widget.gambarSoal) {
      gambarSoal.add(gambar.toString());
    }
    
    return Column(
      children: [
        alat.bangunMenuAtasSoal(gambarSoal, widget.penjelas, widget.selesai, widget.benar),

        const SizedBox(height: 10),

        // ============================
        // Card Jawaban Dinamis
        // ============================
        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final parentHeight = constraints.maxHeight;
              final side = min(parentWidth, parentHeight);

              return Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,     // <= PENTING: agar ditengah
                  children: List.generate(
                    widget.gambarOpsi.length,
                    (i) {
                      final bukanGambar = widget.gambarOpsi.isNotEmpty ? widget.gambarOpsi.every((g) => g.startsWith("an") || g.startsWith("hu")) : false;

                      return CardStatis(
                        isiTengah: true,
                        lebar: side,
                        tinggi: side,
                        padding: 10,
                        tepiRadius: 10,
                        kotakWarna: alat.kotak6,
                        pemisahGarisLuarUkuran: 10,
                        pemisahGarisLuarWarna: alat.outline6,
                        garisLuarUkuran: 10,
                        warnaGambarColor: alat.kotakPutih,
                        tepiRadiusGambar: 10,
                        gambar: bukanGambar ? null : [widget.gambarOpsi[i].toString()],
                        besarGambar: bukanGambar ? null : double.maxFinite,
                        gambarWidget: bukanGambar ? CardStatis(
                          kotak: true,
                          tepiRadius: 10,
                          kotakWarna: alat.kotakPutih,
                          gambarWidget: FittedBox(
                            child: alat.bangunTeksGradien(
                              teks: widget.gambarOpsi[i].toString().split("_").last.toUpperCase(), 
                              warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                            )
                          ),
                          tanpaProvider: true,
                          bayanganKotak: alat.boxShadow,
                        ) : null,
                        pakaiKlik: true,
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi1,
                        padaHoverPemisahGarisLuarWarna: widget.pilihan == i+1 ? alat.garisLuarHoverAbu : alat.outline6,
                        padaHoverGarisLuarWarna: widget.pilihan == i+1 ? null : alat.garisLuarHoverAbu,
                        padaKlikAnimasi: padaKlikAnimasi1,
                        padaKlik: widget.padaKlik != null ? () {
                          widget.padaKlik!(i + 1);
                          } : null,
                        dipilih: widget.pilihan == i+1,
                        padaDipilihGradientGarisLuar: alat.terpilih,
                        susunGambarTeksBaris: Axis.vertical,
                        bayanganGarisLuar: widget.pilihan == i+1 ? alat.boxShadow : null,
                        bayanganPemisahGarisLuar: widget.pilihan == i+1 ? null : alat.boxShadow,
                        padaHoverBayanganGarisLuar: alat.boxShadowHover,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// soal model 1
class SoalModel1 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarOpsi;
  final bool benar;
  final Function(List<String> susunan)? padaSusun;
  final List<String> susunan;
  final bool selesai;
  

  const SoalModel1({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarOpsi,
    this.padaSusun,
    required this.susunan,this.selesai = false,this.benar = false
  });

  @override
  State<SoalModel1> createState() => _SoalModel1State();
}

class _SoalModel1State extends State<SoalModel1> with TickerProviderStateMixin {
  late KontrolDatabase kDatabase;
  late AlatApp alat;
  List<String> gambarSoal = [];
  late List<String> gambarJawaban;
  int? objekDrag;      // index yang sedang didrag
  int? objekDiganti;   // index target saat hover
  late AnimationController wiggleController;
  late Animation<double> wiggle;
  bool dragging = false;
  bool hovering = false;

  @override
  void initState() {
    super.initState();
    alat = context.read<AlatApp>();
    kDatabase = context.read<KontrolDatabase>();
    
    for (var gambar in widget.gambarSoal) {
      gambarSoal.add(gambar.toString());
    }
    gambarJawaban = widget.susunan;
    wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    wiggle = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: wiggleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void tukar(int dari, int ke) {
      final tmp = gambarJawaban[dari];
      gambarJawaban[dari] = gambarJawaban[ke];
      gambarJawaban[ke] = tmp;
    }

    return Column(
      children: [
        alat.bangunMenuAtasSoal(gambarSoal, widget.penjelas , widget.selesai, widget.benar),
        const SizedBox(height: 30),

        // ============================
        // Card Jawaban Dinamis
        // ============================
        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final parentHeight = constraints.maxHeight;
              final side = min(parentWidth, parentHeight);

              return Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    gambarJawaban.length,
                    (i) {
                      return DragTarget<int>(
                        onWillAcceptWithDetails: (details) {
                          return true;
                        },
                        onAcceptWithDetails: (details) {
                          final from = details.data;
                          final to = i;
                          tukar(from, to);
                          if (widget.padaSusun != null) {
                            widget.padaSusun!(gambarJawaban);
                          }
                        },
                        builder: (context, candidate, rejected) {
                          final bukanGambar = gambarJawaban[i].startsWith("an") || gambarJawaban[i].startsWith("hu");
                          return MouseRegion(
                            cursor: dragging
                                ? SystemMouseCursors.move
                                : hovering
                                    ? SystemMouseCursors.move
                                    : SystemMouseCursors.basic,

                            onEnter: (_) => setState(() => hovering = true),
                            onExit: (_) => setState(() => hovering = false),

                            child: Draggable<int>(
                              onDragStarted: () => setState(() => dragging = true),
                              onDragEnd: (_) => setState(() => dragging = false),
                              onDraggableCanceled: (_, _) => setState(() => dragging = false),
                              onDragCompleted: () => setState(() => dragging = false),
                              data: i,
                              feedback: AnimatedBuilder(
                                animation: wiggle,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.17, // membesarkan 10%
                                    child: Transform.rotate(
                                      angle: wiggle.value * 0.02, // kecil saja biar lembut
                                      child: child,
                                    )
                                  );
                                },
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Opacity(
                                    opacity: 0.76,
                                    child: CardStatis(
                                      lebar: side,
                                      tinggi: side,
                                      padding: 10,
                                      tepiRadius: 10,
                                      kotakWarna: alat.kotak6,
                                      pemisahGarisLuarUkuran: 10,
                                      pemisahGarisLuarWarna: alat.outline6,
                                      garisLuarUkuran: 10,
                                      garisLuarWarna: alat.garisLuarHoverAbu,
                                      warnaGambarColor: alat.kotakPutih,
                                      tepiRadiusGambar: 10,
                                      gambarWidget: bukanGambar ? CardStatis(
                                        kotak: true,
                                        tepiRadius: 10,
                                        kotakWarna: alat.kotakPutih,
                                        gambarWidget: FittedBox(
                                          child: alat.bangunTeksGradien(
                                            teks: gambarJawaban[i].split("_").last.toUpperCase(), 
                                            warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                                          )
                                        ),
                                        tanpaProvider: true,
                                        bayanganKotak: alat.boxShadow,
                                      ) : null,
                                      gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(gambarJawaban[i])],
                                      tanpaProvider: true,
                                      bayanganPemisahGarisLuar: alat.boxShadowHover,
                                      susunGambarTeksBaris: Axis.vertical,
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: CardStatis(
                                  lebar: side,
                                  tinggi: side,
                                  padding: 10,
                                  tepiRadius: 10,
                                  kotakWarna: alat.kotak6,
                                  pemisahGarisLuarUkuran: 10,
                                  pemisahGarisLuarWarna: alat.outline6,
                                  garisLuarUkuran: 10,
                                  warnaGambarColor: alat.kotakPutih,
                                  tepiRadiusGambar: 10,
                                  gambarWidget: bukanGambar ? CardStatis(
                                      kotak: true,
                                      tepiRadius: 10,
                                      kotakWarna: alat.kotakPutih,
                                      gambarWidget: FittedBox(
                                      child: alat.bangunTeksGradien(
                                        teks: gambarJawaban[i].split("_").last.toUpperCase(), 
                                        warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                                      ),
                                    ),
                                    bayanganKotak: alat.boxShadow,
                                  ) : null,
                                  gambar: bukanGambar ? null : [gambarJawaban[i]],
                                  bayanganPemisahGarisLuar: alat.boxShadow,
                                  susunGambarTeksBaris: Axis.vertical,
                                ),
                              ),
                              child: CardStatis(
                                lebar: side,
                                tinggi: side,
                                key: ValueKey(gambarJawaban[i]),
                                padding: 10,
                                tepiRadius: 10,
                                kotakWarna: alat.kotak6,
                                pemisahGarisLuarWarna: alat.outline6,
                                pemisahGarisLuarUkuran: 10,
                                garisLuarUkuran: 10,
                                warnaGambarColor: alat.kotakPutih,
                                tepiRadiusGambar: 10,
                                gambarWidget: bukanGambar ? CardStatis(
                                  kotak: true,
                                  tepiRadius: 10,
                                  kotakWarna: alat.kotakPutih,
                                  gambarWidget: FittedBox(
                                    child: alat.bangunTeksGradien(
                                      teks: gambarJawaban[i].split("_").last.toUpperCase(), 
                                      warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                                    )
                                  ),
                                  bayanganKotak: alat.boxShadow,
                                ) : null,
                                gambar: bukanGambar ? null : [gambarJawaban[i]],
                                pakaiHover: true,
                                padaHoverAnimasi: padaHoverAnimasi1,
                                padaHoverGarisLuarGradient: alat.terpilih,
                                padaHoverBayanganGarisLuar: alat.boxShadowHover,
                                bayanganPemisahGarisLuar: alat.boxShadow,
                                susunGambarTeksBaris: Axis.vertical,
                              ),
                            )
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SoalModel3 extends StatefulWidget {
  final String penjelas;

  final Function(List<List<String>> susunan)? padaSusun;
  final List<List<String>> susunanSemua;
  final bool selesai;
  final bool benar;
  
  

  const SoalModel3({
    super.key,
    required this.penjelas,
    required this.padaSusun,
    required this.susunanSemua,this.selesai = false,this.benar = false
  });

  @override
  State<SoalModel3> createState() => _SoalModel3State();
}

class _SoalModel3State extends State<SoalModel3> with TickerProviderStateMixin {
  late KontrolDatabase kDatabase;
  late AlatApp alat;
  late List<List<String>> susunanSemua;
  int? objekDrag;
  int? objekDiganti;
  late AnimationController wiggleController;
  late Animation<double> wiggle;
  bool dragging = false;
  bool hovering = false;

  @override
  void initState() {
    super.initState();
    alat = context.read<AlatApp>();
    kDatabase = context.read<KontrolDatabase>();
    
    susunanSemua = widget.susunanSemua;
    wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    wiggle = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: wiggleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 12.0;

    void perbaruiSusunan(List<String> susunan, int indexSusunan) {
      susunanSemua[indexSusunan] = susunan;
      if (widget.padaSusun != null) {
        widget.padaSusun!(susunanSemua);
      }
    }

    Widget bangunPemisah() {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxHeight = (constraints.maxHeight - (spacing * (susunanSemua[0].length - 1))) / susunanSemua[0].length - 10;

                  return Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: spacing,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: List.generate(
                      susunanSemua[0].length,
                      (i) {
                        return SizedBox(
                          width: maxHeight,
                          height: maxHeight,
                          child: FittedBox(
                            child: Icon(Icons.drag_handle, color: alat.teksHitam,)
                          )
                        );
                      }),
                    )
                  );
                }
              )
            )
          ]
        )
      );
    }

    Widget bangunSusunan({
      required List<String> susunan,
      required int indexSusunan
    }) {
      void tukar(int dari, int ke) {
        final tmp = susunan[dari];
        susunan[dari] = susunan[ke];
        susunan[ke] = tmp;
      }
      return Expanded(
        flex: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight - alat.ukuranFooter;
                  final tinggi = (maxHeight - (spacing * (susunan.length - 1))) / susunan.length;

                  return Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: spacing,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                      susunan.length,
                      (i) {
                        return DragTarget<Map<String, int>>(
                          onWillAcceptWithDetails: (details) {
                            final data = details.data;
                            return data["group"] == indexSusunan; // hanya terima dari kolom yg sama
                          },
                          onAcceptWithDetails: (details) {
                            final data = details.data;
                            if (data["group"] != indexSusunan) return; // jaga-jaga

                            final from = data["index"]!;
                            final to = i;

                            tukar(from, to);
                            perbaruiSusunan(susunan, indexSusunan);
                          },
                          builder: (context, candidate, rejected) {
                            final bukanGambar = susunan[i].startsWith("an") || susunan[i].startsWith("hu");
                            return MouseRegion(
                              cursor: dragging
                                  ? SystemMouseCursors.move
                                  : hovering
                                      ? SystemMouseCursors.move
                                      : SystemMouseCursors.basic,

                              onEnter: (_) => setState(() => hovering = true),
                              onExit: (_) => setState(() => hovering = false),
                                
                              child: Draggable<Map<String, int>>(
                                onDragStarted: () => setState(() => dragging = true),
                                onDragEnd: (_) => setState(() => dragging = false),
                                onDraggableCanceled: (_, _) => setState(() => dragging = false),
                                onDragCompleted: () => setState(() => dragging = false),
                                data: {"group": indexSusunan, "index": i},
                                feedback: AnimatedBuilder(
                                  animation: wiggle,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 1.1, // membesarkan 10%
                                      child: Transform.rotate(
                                        angle: wiggle.value * 0.02, // kecil saja biar lembut
                                        child: child,
                                      )
                                    );
                                  },
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: CardStatis(
                                        lebar: maxWidth,
                                        tinggi: tinggi,
                                        isiTengah: true,
                                        padding: 10,
                                        tepiRadius: 10,
                                        kotakWarna: alat.kotak6,
                                        pemisahGarisLuarUkuran: 10,
                                        pemisahGarisLuarWarna: alat.outline6,
                                        garisLuarUkuran: 10,
                                        garisLuarWarna: alat.garisLuarHoverAbu,
                                        warnaGambarColor: alat.kotakPutih,
                                        tepiRadiusGambar: 10,
                                        gambarWidget: Center(
                                          child: CardStatis(
                                            isiTengah: true,
                                            kotak: true,
                                            tepiRadius: 10,
                                            kotakWarna: alat.kotakPutih,
                                            gambarWidget: bukanGambar ? FittedBox(
                                              child: alat.bangunTeksGradien(
                                                teks: susunan[i].split("_").last.toUpperCase(), 
                                                warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                                              )
                                            ) : null,
                                            gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(susunan[i])],
                                            susunGambarTeksBaris: bukanGambar ? Axis.horizontal : Axis.vertical,
                                            tanpaProvider: true,
                                            bayanganKotak: alat.boxShadow,
                                          )
                                        ),
                                        pakaiHover: true,
                                        padaHoverAnimasi: padaHoverAnimasi1,
                                        padaHoverGarisLuarGradient: alat.terpilih,
                                        tanpaProvider: true,
                                        bayanganGarisLuar: alat.boxShadowHover,
                                      ),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: CardStatis(
                                    isiTengah: true,
                                    lebar: maxWidth,
                                    tinggi: tinggi,
                                    padding: 10,
                                    tepiRadius: 10,
                                    kotakWarna: alat.kotak6,
                                    pemisahGarisLuarUkuran: 10,
                                    pemisahGarisLuarWarna: alat.outline6,
                                    garisLuarUkuran: 10,
                                    warnaGambarColor: alat.kotakPutih,
                                    tepiRadiusGambar: 10,
                                    gambarWidget: Center(
                                      child: CardStatis(
                                        isiTengah: true,
                                        kotak: true,
                                        tepiRadius: 10,
                                        kotakWarna: alat.kotakPutih,
                                        gambarWidget: bukanGambar ? FittedBox(
                                          child: alat.bangunTeksGradien(
                                            teks: susunan[i].split("_").last.toUpperCase(), 
                                            warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                                          )
                                        ) : null,
                                        gambar: bukanGambar ? null : [susunan[i]],
                                        susunGambarTeksBaris: bukanGambar ? Axis.horizontal : Axis.vertical,
                                        bayanganKotak: alat.boxShadow,
                                      ) 
                                    ),
                                    bayanganPemisahGarisLuar: alat.boxShadow,
                                    susunGambarTeksBaris: Axis.vertical,
                                  ),
                                ),
                                child: CardStatis(
                                  lebar: maxWidth,
                                  tinggi: tinggi,
                                  isiTengah: true,
                                  padding: 10,
                                  tepiRadius: 10,
                                  kotakWarna: alat.kotak6,
                                  pemisahGarisLuarWarna: alat.outline6,
                                  pemisahGarisLuarUkuran: 10,
                                  garisLuarUkuran: 10,
                                  warnaGambarColor: alat.kotakPutih,
                                  tepiRadiusGambar: 10,
                                  gambarWidget: Center(
                                    child: CardStatis(
                                      isiTengah: true,
                                      kotak: true,
                                      tepiRadius: 10,
                                      kotakWarna: alat.kotakPutih,
                                      gambarWidget:  bukanGambar ? FittedBox(
                                        child: alat.bangunTeksGradien(
                                          teks: susunan[i].split("_").last.toUpperCase(), 
                                          warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                                        )
                                      ) : null,
                                      gambar: bukanGambar ? null : [susunan[i]],
                                      susunGambarTeksBaris: bukanGambar ? Axis.horizontal : Axis.vertical,
                                      bayanganKotak: alat.boxShadow,
                                    )
                                  ),
                                  pakaiHover: true,
                                  padaHoverAnimasi: padaHoverAnimasi1,
                                  padaHoverGarisLuarGradient: alat.terpilih,
                                  padaHoverBayanganGarisLuar: alat.boxShadowHover,
                                  bayanganPemisahGarisLuar: alat.boxShadow,
                                  susunGambarTeksBaris: Axis.vertical,
                                ),
                              )
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ]
        )
      );
    }

    return Column(
      children: [
        alat.bangunMenuAtasSoal([], widget.penjelas, widget.selesai, widget.benar),
        const SizedBox(height: 10),

        Expanded(
          flex: widget.selesai ? 15 :24,
          child: Row(
            children: [
              bangunSusunan(susunan: susunanSemua[0], indexSusunan: 0),
              SizedBox(width: 30),
              bangunPemisah(),
              SizedBox(width: 10),
              bangunSusunan(susunan: susunanSemua[1], indexSusunan: 1)
            ],
          )
        ),
      ],
    );
  }
}


// soal model 4
class SoalModel4 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> susunanAwal;
  final List<dynamic> susunanAtas;
  final List<dynamic> opsi;
  final bool benar;
  
  final Function(List<List<dynamic>> atas)? padaSelesaiSusun;
  final bool selesai;
  

  const SoalModel4({
    super.key,
    required this.penjelas,
    required this.susunanAwal,
    required this.susunanAtas,
    required this.opsi,
    this.padaSelesaiSusun,this.selesai = false,this.benar = false
  });

  @override
  State<SoalModel4> createState() => _SoalModel4State();
}

class _SoalModel4State extends State<SoalModel4> with TickerProviderStateMixin {
  List<bool> susunanAwal = [];
  late List<String?> susunanAtas;
  late List<String> susunanBawah;
  late AnimationController wiggleController;
  late Animation<double> wiggle;
  bool dragging = false;
  bool hovering = false;

  @override
  void initState() {
    super.initState();
    susunanAwal = widget.susunanAwal.map((e) => e != null).toList();

    // FIX: pastikan susunanAtas benar-benar list<String?>
    susunanAtas = widget.susunanAtas.map((e) => e?.toString()).toList();

    // Ambil opsi sebagai List<String>
    final opsi = widget.opsi.map((e) => e.toString()).toList();

    // FIX: ambil hanya yang memang terisi di susunanAtas
    final dipakai = susunanAtas.where((e) => e != null).toList();

    // FIX: susunanBawah = semua opsi selain yang dipakai
    susunanBawah = opsi.where((e) => !dipakai.contains(e)).toList();

    wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    wiggle = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: wiggleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alat = context.read<AlatApp>();
    final kDatabase = context.read<KontrolDatabase>();
    
    Widget bangunListGambar({
      required bool adalahSusunanAtas,
      List<bool>? indexFixed,
      required String listName,
      required Function(String fromList, int fromIndex, String value, int hereIndex)
        onAcceptFromOther
    }) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final parentWidth = constraints.maxWidth;
          final parentHeight = constraints.maxHeight;
          final side = min(parentWidth, parentHeight);

          return Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: List.generate(
                adalahSusunanAtas ? susunanAtas.length : susunanBawah.length,
                (i) {
                  final item = adalahSusunanAtas ? susunanAtas[i] : susunanBawah[i];
                  final fixed = adalahSusunanAtas && indexFixed != null ? indexFixed[i] : false;
                  final bukanGambar = item != null && (item.startsWith("an") || item.startsWith("hu"));

                  if (item == null) {
                    return DragTarget<Map<String, dynamic>>(
                      onWillAcceptWithDetails: (details) => true,
                      onAcceptWithDetails: (details) {
                        final from = details.data["from"];
                        final index = details.data["index"];
                        final value = details.data["value"];
                        onAcceptFromOther(from, index, value, i);
                        if (widget.padaSelesaiSusun != null) {
                          widget.padaSelesaiSusun!([susunanAtas, susunanBawah]);
                        }
                      },
                      builder: (context, c, r) => CardStatis(
                        lebar: side,
                        tinggi: side,
                        tepiRadius: 10,
                        kotakWarna: alat.kotakHitam,
                        gambarWidget: Container(
                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: alat.kotakHitam,
                            ),
                            padding: EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: alat.kotakPutih,
                                boxShadow: alat.boxLightOut,
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                        pemisahGarisLuarUkuran: 2,
                        pemisahGarisLuarWarna: alat.kotakHitam,
                        garisLuarUkuran: 10,
                        garisLuarWarna: alat.outline6,
                        bayanganPemisahGarisLuar: alat.boxShadowHover,
                        bayanganGarisLuar: [alat.pendukungBoxShadow],
                      )
                    );
                  }

                  if (fixed) {
                    return CardStatis(
                      lebar: side,
                      tinggi: side,
                      padding: 10,
                      tepiRadius: 10,
                      kotakWarna: alat.kotak6,
                      pemisahGarisLuarUkuran: 10,
                      pemisahGarisLuarWarna: alat.outline6,
                      garisLuarUkuran: 10,
                      warnaGambarColor: alat.kotakPutih,
                      tepiRadiusGambar: 10,
                      gambarWidget: bukanGambar ?  CardStatis(
                        kotak: true,
                        tepiRadius: 10,
                        kotakWarna: alat.kotakPutih,
                        gambarWidget: FittedBox(
                          child: alat.bangunTeksGradien(
                            teks: item.split("_").last.toUpperCase(), 
                            warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                          )
                        ),
                        tanpaProvider: true,
                        bayanganKotak: alat.boxShadow,
                      ) : null,
                      gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(item)],
                      tanpaProvider: true,
                      bayanganPemisahGarisLuar: alat.boxShadow,
                      susunGambarTeksBaris: Axis.vertical,
                    );
                  }
                  
                  return MouseRegion(
                    cursor: dragging
                        ? SystemMouseCursors.move
                        : hovering
                            ? SystemMouseCursors.move
                            : SystemMouseCursors.basic,

                    onEnter: (_) => setState(() => hovering = true),
                    onExit: (_) => setState(() => hovering = false),
                      
                    child: Draggable<Map<String, dynamic>>(
                      onDragStarted: () => setState(() => dragging = true),
                      onDragEnd: (_) => setState(() => dragging = false),
                      onDraggableCanceled: (_, _) => setState(() => dragging = false),
                      onDragCompleted: () => setState(() => dragging = false),
                      data: {"from": listName, "index": i, "value": item},
                      feedback: AnimatedBuilder(
                        animation: wiggle,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.1, // membesarkan 10%
                            child: Transform.rotate(
                              angle: wiggle.value * 0.02, // kecil saja biar lembut
                              child: child,
                            )
                          );
                        },
                        child: Material(
                          type: MaterialType.transparency,
                          child: Opacity(
                            opacity: 0.7,
                            child: CardStatis(
                              lebar: side,
                              tinggi: side,
                              padding: 10,
                              tepiRadius: 10,
                              kotakWarna: alat.kotak6,
                              pemisahGarisLuarUkuran: 10,
                              pemisahGarisLuarWarna: alat.outline6,
                              garisLuarUkuran: 10,
                              garisLuarWarna: alat.garisLuarHoverAbu,
                              warnaGambarColor: alat.kotakPutih,
                              tepiRadiusGambar: 10,
                              gambarWidget: bukanGambar ?  CardStatis(
                                kotak: true,
                                tepiRadius: 10,
                                kotakWarna: alat.kotakPutih,
                                gambarWidget: FittedBox(
                                  child: alat.bangunTeksGradien(
                                    teks: item.split("_").last, 
                                    warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                                  )
                                ),
                                tanpaProvider: true,
                                bayanganKotak: alat.boxShadow,
                              ) : null,
                              gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(item)],
                              pakaiHover: true,
                              padaHoverAnimasi: padaHoverAnimasi1,
                              padaHoverGarisLuarGradient: alat.terpilih,
                              tanpaProvider: true,
                              bayanganGarisLuar: alat.boxShadowHover,
                              susunGambarTeksBaris: Axis.vertical,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: CardStatis(
                          lebar: side,
                          tinggi: side,
                          padding: 10,
                          tepiRadius: 10,
                          kotakWarna: alat.kotak6,
                          pemisahGarisLuarUkuran: 10,
                          pemisahGarisLuarWarna: alat.outline6,
                          garisLuarUkuran: 10,
                          warnaGambarColor: alat.kotakPutih,
                          tepiRadiusGambar: 10,
                          gambarWidget: bukanGambar ?  CardStatis(
                            kotak: true,
                            tepiRadius: 10,
                            kotakWarna: alat.kotakPutih,
                            gambarWidget: FittedBox(
                              child: alat.bangunTeksGradien(
                                teks: item.split("_").last.toUpperCase(), 
                                warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                              )
                            ),
                            tanpaProvider: true,
                            bayanganKotak: alat.boxShadow,
                          )  : null,
                          gambar: bukanGambar ? null : [item],
                          bayanganPemisahGarisLuar: alat.boxShadow,
                          susunGambarTeksBaris: Axis.vertical,
                        ),
                      ),
                      child: DragTarget<Map<String, dynamic>>(
                        onWillAcceptWithDetails: (details) {
                          if (adalahSusunanAtas && indexFixed != null) {
                            if (!indexFixed[i]) {
                              return true;
                            } else {
                              return false;
                            }
                          }
                          if (!adalahSusunanAtas) {
                            return true;  // selalu boleh reorder di bawah
                          }
                          return true; 
                        },
                        onAcceptWithDetails: (details) {
                          final fromList = details.data["from"];
                          final fromIndex = details.data["index"];
                          final value = details.data["value"];

                          if (adalahSusunanAtas && indexFixed != null) {
                            if (susunanAtas[i] != null && !indexFixed[i]) {
                              if (fromList == listName) {
                                if (fromIndex != i) {
                                  setState(() {
                                    final temp = susunanAtas[fromIndex];
                                    susunanAtas[fromIndex] = susunanAtas[i];
                                    susunanAtas[i] = temp;
                                  });
                                }
                              } else {
                                onAcceptFromOther(fromList, fromIndex, value, i);
                              }
                            }
                          } else {
                            if (fromList == listName) {
                              if (fromIndex != i) {
                                setState(() {
                                  final temp = susunanBawah[fromIndex];
                                  susunanBawah[fromIndex] = susunanBawah[i];
                                  susunanBawah[i] = temp;
                                });
                              }
                            } else {
                              onAcceptFromOther(fromList, fromIndex, value, i);
                            }
                          }
                          if (widget.padaSelesaiSusun != null) {
                            widget.padaSelesaiSusun!([susunanAtas, susunanBawah]);
                          }
                        },
                        builder: (context, candidate, rejected) => CardStatis(
                          lebar: side,
                          tinggi: side,
                          padding: 10,
                          tepiRadius: 10,
                          kotakWarna: alat.kotak6,
                          pemisahGarisLuarWarna: alat.outline6,
                          pemisahGarisLuarUkuran: 10,
                          garisLuarUkuran: 10,
                          warnaGambarColor: alat.kotakPutih,
                          tepiRadiusGambar: 10,
                          gambarWidget: bukanGambar ?  CardStatis(
                            kotak: true,
                            tepiRadius: 10,
                            kotakWarna: alat.kotakPutih,
                            gambarWidget: FittedBox(
                              child: alat.bangunTeksGradien(
                                teks: item.split("_").last.toUpperCase(), 
                                warna: alat.terpilih, font: alat.judul, ukuranFont: 10, beratFont: FontWeight.bold
                              )
                            ),
                            tanpaProvider: true,
                            bayanganKotak: alat.boxShadow,
                          ) : null,
                          gambar: bukanGambar ? null : [item],
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                          padaHoverGarisLuarGradient: alat.terpilih,
                          padaHoverBayanganGarisLuar: alat.boxShadowHover,
                          bayanganPemisahGarisLuar: alat.boxShadow,
                          susunGambarTeksBaris: Axis.vertical,
                        ),
                      ),
                    )
                  );
                },
              ),
            ),
          );
        },
      );
    }

    Widget bangunPelapis({required Widget child}) {
      final tanda = widget.selesai ? Lingkaran(
        besar: 40, 
        besarGarisLuar: 7, 
        warnaGarisLuar: alat.kotakPutih, 
        benarSalahNetral: widget.benar ? 1 : 2, 
        warnaLingkaran: widget.benar ? alat.benar : alat.salah, 
        warnaSimbolAngka: alat.teksPutihSedang,
      ):null;

      if (widget.selesai) {
        return CardStatis(
          tepiRadius: 30,
          isiTengah: true,
          gambarWidget: child,
          bayanganKotak: alat.boxShadow,
          bayanganJudul: alat.judulShadow,
          tanda: tanda,
          pemisahGarisLuarUkuran: widget.selesai ? 4 : 0,
          pemisahGarisLuarWarna: widget.selesai ? alat.kotakPutih : null,
          garisLuarUkuran: widget.selesai ? 5 : 0,
          garisLuarWarna: widget.selesai ? (widget.benar ? alat.benar : alat.salah) : null,
        );
      }

      return child;
    }

    return Column(
      children: [
        /// PENJELAS
        Expanded(
          flex: 8,
          child: bangunPelapis(
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                gradient: alat.warnaHeader,
                borderRadius: BorderRadius.circular(30),
                boxShadow: alat.boxShadow
              ),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: bangunListGambar(
                      adalahSusunanAtas: true, 
                      indexFixed: susunanAwal,
                      listName: "atas",
                      onAcceptFromOther: (fromList, fromIndex, value, hereIndex) {
                        if (fromList == "atas") {
                          if (susunanAtas[hereIndex] == null) {
                            susunanAtas[hereIndex] = value;
                            susunanAtas[fromIndex] = null;
                          } else {
                            final temp = susunanAtas[hereIndex];
                            susunanAtas[hereIndex] = value;
                            susunanAtas[fromIndex] = temp;
                          }
                        }

                        if (fromList == "bawah") {
                          final realIndex = susunanBawah.indexOf(value);
                          if (realIndex != -1) {
                              final temp = susunanBawah.removeAt(realIndex);
                              if (susunanAtas[hereIndex] != null) {
                                susunanBawah.add(susunanAtas[hereIndex]!);
                                susunanAtas[hereIndex] = temp;
                              } else {
                                susunanAtas[hereIndex] = temp;
                              }
                          }
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.penjelas,
                        style: TextStyle(
                          color: alat.teksPutihSedang,
                          fontFamily: alat.judul,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          shadows: alat.judulShadow
                        ),
                      ),
                    ),
                  ),
                ],
              )
            )
          ),
        ),

        const SizedBox(height: 10),

        Expanded(
          flex: 6,
          child: bangunListGambar(
            adalahSusunanAtas: false,
            listName: "bawah",
            onAcceptFromOther: (fromList, fromIndex, value, hereIndex) {
              susunanBawah.insert(hereIndex, value);
              if (fromList == "atas") {susunanAtas[fromIndex] = null;}
            },
          ),
        ),
      ],
    );
  }
}
class SoalModel5 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final bool benar;
  
  final int panjangRangkaian;
  final Function(List<String?> susunan)? padaRangkai;
  final List<String?> rangkaian;
  final bool selesai;
  

  const SoalModel5({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.panjangRangkaian,
    this.padaRangkai,
    required this.rangkaian,this.selesai = false,this.benar = false
  });

  @override
  State<SoalModel5> createState() => _SoalModel5State();
}

class _SoalModel5State extends State<SoalModel5> {
  late AlatApp alat;
  late final List<TextEditingController> _ctrl;
  late final List<FocusNode> _focus;
  List<String> gambarSoal = [];
  int pilihan = 0;
  
  void gantiKata(int index, String isi, bool hapus) {
    if (hapus) {
      if (widget.padaRangkai != null) {
        List<String?> rangkaian = widget.rangkaian;
        rangkaian[index] = null;
        widget.padaRangkai!(rangkaian);
      }
    } else {
      if (widget.padaRangkai != null) {
        List<String?> rangkaian = widget.rangkaian;
        rangkaian[index] = isi;
        widget.padaRangkai!(rangkaian);
      }
    }
  }

  void onCursorChange(int index, bool aktif) {
    if (aktif) {
      pilihan = index + 1;
      setState(() {});
      // Jalankan fungsi ketika fokus
    } else {
      pilihan = 0;
      setState(() {});
      // Jalankan fungsi ketika unfocus
    }
  }

  @override
  void initState() {
    super.initState();
    alat = context.read<AlatApp>();
    _ctrl = List.generate(widget.panjangRangkaian, (i) => TextEditingController(text: widget.rangkaian[i]));
    _focus = List.generate(widget.panjangRangkaian, (i) {
      final f = FocusNode();
        f.addListener(() {
          // true = mendapat fokus (kursor muncul). false = kehilangan fokus

          // Jalankan fungsi setiap focus berubah
          onCursorChange(i, f.hasFocus);
        });
      return f;
    });

    for (var isi in widget.gambarSoal) {
      gambarSoal.add(isi);
    }
  }

  @override
  void dispose() {
    for (var c in _ctrl) {c.dispose();}
    for (var f in _focus) {f.dispose();}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        alat.bangunMenuAtasSoal(gambarSoal, widget.penjelas, widget.selesai, widget.benar),
        const SizedBox(height: 30),

        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final parentHeight = constraints.maxHeight;
              final side = min(parentWidth, parentHeight);

              return Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,     // <= PENTING: agar ditengah
                  children: List.generate(
                    widget.panjangRangkaian,
                    (i) {
                      return CardStatis(
                          lebar: side,
                          tinggi: side,
                          padding: 10,
                          tepiRadius: 10,
                          kotakWarna: alat.kotak6,
                          pemisahGarisLuarUkuran: 10,
                          pemisahGarisLuarWarna: alat.outline6,
                          garisLuarUkuran: 10,
                          gambarWidget: Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: alat.kotakPutih,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: alat.boxShadow
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center (
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return alat.terpilih.createShader(bounds);
                                      },
                                      blendMode: BlendMode.srcIn,
                                      child: TextField(
                                        controller: _ctrl[i],
                                        focusNode: _focus[i],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: alat.teksHitam,
                                          fontFamily: alat.judul,
                                          fontSize: 50,
                                          fontWeight: FontWeight.w900
                                        ),
                                        maxLength: 1,
                                        // hanya huruf/angka
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                          LengthLimitingTextInputFormatter(1),
                                          TextInputFormatter.withFunction(
                                            (oldValue, newValue) {
                                              return newValue.copyWith(
                                                text: newValue.text.toUpperCase(),
                                              );
                                            },
                                          ),
                                        ],
                                        decoration: const InputDecoration(
                                          isCollapsed: true,
                                          counterText: '', // sembunyikan counter
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (isi) {
                                          if (isi.isEmpty) {
                                            gantiKata(i, isi, true);
                                          } else {
                                            gantiKata(i, isi, false);
                                          }
                                        },
                                      ),
                                    )
                                  ),
                                ),
                                SizedBox(height: 4,),
                                Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: alat.teksHitam,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                            ]
                            )
                          ),
                          pakaiKlik: true,
                          padaKlik: () {
                            _focus[i].requestFocus();
                          },
                          dipilih: pilihan == i+1,
                          padaDipilihAnimasi: padaPilihAnimasi1,
                          padaDipilihGradientGarisLuar: alat.terpilih,
                          bayanganGarisLuar: pilihan == i+1 ? alat.boxShadowHover : null,
                          bayanganPemisahGarisLuar: pilihan == i+1 ? null : alat.boxShadow,
                        );
                    },
                  ),
                ),
              );
            },
          ),
        ),
    ]
    );
  }
}

//flutter run -d windows -t lib/main.dart --verbose