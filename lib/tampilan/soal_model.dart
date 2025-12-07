import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/susun.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SoalModel2 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarOpsi;
  final int Function(int index)? padaKlik;
  final int pilihan;

  const SoalModel2({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarOpsi,
    this.padaKlik,
    this.pilihan = 0,
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
        Expanded(
          flex: 8,
          child: CardStatis(
            padding: 10,
            tepiRadius: 10,
            isiTengah: true,
            kotakWarna: alat.kotakUtama,
            gambar: gambarSoal,
            besarGambar: null,
            paddingGambar: 10,
            tepiRadiusGambar: 10,
            warnaGambarColor: alat.kotakPutih,
            jarakGambarPemisah: 10,
            pemisahGambar: Icon(
              Icons.double_arrow_rounded,
              size: 10,
            ),
            besarPemisahGambar: 10,
            judul: widget.penjelas,
            fontJudul: alat.judul,
            judulUkuran: 17,
            judulWarna: alat.teksPutihSedang,
            susunGambarTeksBaris: Axis.vertical,
          ),
        ),

        const SizedBox(height: 10),

        // ============================
        // Card Jawaban Dinamis
        // ============================
        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final parentHeight = constraints.maxHeight - alat.ukuranFooter;
              final side = min(parentWidth, parentHeight);

              return Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,     // <= PENTING: agar ditengah
                  children: List.generate(
                    widget.gambarOpsi.length,
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
                          gambar: [widget.gambarOpsi[i].toString()],
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

// soal model 2
class SoalModel1 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarOpsi;
  final Function(List<String> susunan)? padaSusun;
  final List<String> susunan;

  const SoalModel1({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarOpsi,
    this.padaSusun,
    required this.susunan
  });

  @override
  State<SoalModel1> createState() => _SoalModel1State();
}

class _SoalModel1State extends State<SoalModel1> {
  late KontrolDatabase kDatabase;
  late AlatApp alat;
  List<String> gambarSoal = [];
  late List<String> gambarJawaban;
  int? objekDrag;
  int? objekDiganti;

  @override
  void initState() {
    super.initState();
    alat = context.read<AlatApp>();
    kDatabase = context.read<KontrolDatabase>();
    
    for (var gambar in widget.gambarSoal) {
      gambarSoal.add(gambar.toString());
    }
    gambarJawaban = widget.susunan;
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
        Expanded(
          flex: 8,
          child: CardStatis(
            padding: 10,
            tepiRadius: 10,
            isiTengah: true,
            kotakWarna: alat.kotakUtama,
            gambar: gambarSoal,
            paddingGambar: 10,
            tepiRadiusGambar: 10,
            warnaGambarColor: alat.kotakPutih,
            jarakGambarPemisah: 10,
            pemisahGambar: Icon(
              Icons.double_arrow_rounded,
              size: 10,
            ),
            besarPemisahGambar: 10,
            judul: widget.penjelas,
            fontJudul: alat.judul,
            judulUkuran: 17,
            judulWarna: alat.teksPutihSedang,
            susunGambarTeksBaris: Axis.vertical,
          ),
        ),
        const SizedBox(height: 30),

        // ============================
        // Card Jawaban Dinamis
        // ============================
        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final parentHeight = constraints.maxHeight - alat.ukuranFooter;
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
                          /*final from = details.data;
                          final to = i;
                          objekDrag = from;
                          objekDiganti = to;
                          tukar(from, to);*/
                          return true;
                        },
                        onLeave: (details) {
                          /*final from = objekDiganti;
                          final to = objekDrag;

                          // Cegah crash
                          if (from == null || to == null) {
                            objekDrag = objekDiganti = null;
                            return;
                          }

                          objekDrag = objekDiganti = null;
                          tukar(from, to);*/
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
                          return Draggable<int>(
                            data: i,
                            feedback: Material(
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
                                  gambarWidget: bukanGambar ? FittedBox(
                                    child: alat.bangunTeksGradien(
                                      teks: gambarJawaban[i].split("_").last, 
                                      warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                                    )
                                   ) : null,
                                  gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(gambarJawaban[i])],
                                  pakaiHover: true,
                                  padaHoverAnimasi: padaHoverAnimasi1,
                                  padaHoverGarisLuarGradient: alat.terpilih,
                                  tanpaProvider: true,
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
                                gambarWidget: bukanGambar ? FittedBox(
                                  child: alat.bangunTeksGradien(
                                    teks: gambarJawaban[i].split("_").last, 
                                    warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                                  )
                                  ) : null,
                                gambar: bukanGambar ? null : [gambarJawaban[i]],
                              ),
                            ),
                            child: CardStatis(
                              lebar: side,
                              tinggi: side,
                              padding: 10,
                              tepiRadius: 10,
                              kotakWarna: alat.kotak6,
                              pemisahGarisLuarWarna: alat.outline6,
                              pemisahGarisLuarUkuran: 10,
                              garisLuarUkuran: 10,
                              gambarWidget: bukanGambar ? FittedBox(
                                child: alat.bangunTeksGradien(
                                  teks: gambarJawaban[i].split("_").last, 
                                  warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                                )
                              ) : null,
                              gambar: bukanGambar ? null : [gambarJawaban[i]],
                              pakaiHover: true,
                              padaHoverAnimasi: padaHoverAnimasi1,
                              padaHoverGarisLuarGradient: alat.terpilih,
                            ),
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

  const SoalModel3({
    super.key,
    required this.penjelas,
    required this.padaSusun,
    required this.susunanSemua
  });

  @override
  State<SoalModel3> createState() => _SoalModel3State();
}

class _SoalModel3State extends State<SoalModel3> {
  late KontrolDatabase kDatabase;
  late AlatApp alat;
  late List<List<String>> susunanSemua;
  int? objekDrag;
  int? objekDiganti;

  @override
  void initState() {
    super.initState();
    alat = context.read<AlatApp>();
    kDatabase = context.read<KontrolDatabase>();
    
    susunanSemua = widget.susunanSemua;
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
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: alat.ukuranFooter),
              child:LayoutBuilder(
                builder: (context, constraints) {
                  final maxHeight = constraints.maxHeight - alat.ukuranFooter;
                  final maxHeightFinal = maxHeight - (spacing * susunanSemua[0].length);
                  final tinggi = maxHeightFinal / susunanSemua[0].length;

                  return Center(
                    child: Wrap(
                      spacing: 0,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                      susunanSemua[0].length,
                      (i) {
                        return Text(
                          "=", 
                          style: TextStyle(
                            color: alat.teksHitam,
                            fontSize: tinggi,
                          ),
                        );
                      }),
                    )
                  );
                })
              ),
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
        flex: susunan.length > 1 ? 6 : 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: alat.ukuranFooter),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight - alat.ukuranFooter;
                  final tinggi = (maxHeight - (spacing * susunan.length)) / susunan.length;

                  return Center(
                    child: Wrap(
                        spacing: spacing,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                        susunan.length,
                        (i) {
                          return DragTarget<Map<String, int>>(
                            onWillAcceptWithDetails: (details) {
                              /*final from = details.data;
                              final to = i;
                              objekDrag = from;
                              objekDiganti = to;
                              tukar(from, to);*/
                              final data = details.data;
                              return data["group"] == indexSusunan; // hanya terima dari kolom yg sama
                            },
                            onLeave: (details) {
                              /*final from = objekDiganti;
                              final to = objekDrag;

                              // Cegah crash
                              if (from == null || to == null) {
                                objekDrag = objekDiganti = null;
                                return;
                              }

                              objekDrag = objekDiganti = null;
                              tukar(from, to);*/
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
                              return Draggable<Map<String, int>>(
                                data: {"group": indexSusunan, "index": i},
                                feedback: Material(
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
                                      gambarWidget: bukanGambar ? FittedBox(
                                        child: alat.bangunTeksGradien(
                                          teks: susunan[i].split("_").last, 
                                          warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                                        )
                                        ) : null,
                                      gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(susunan[i])],
                                      pakaiHover: true,
                                      padaHoverAnimasi: padaHoverAnimasi1,
                                      padaHoverGarisLuarGradient: alat.terpilih,
                                      tanpaProvider: true,
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
                                    gambarWidget: bukanGambar ? FittedBox(
                                      child: alat.bangunTeksGradien(
                                        teks: susunan[i].split("_").last, 
                                        warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                                      )
                                      ) : null,
                                    gambar: bukanGambar ? null : [susunan[i]],
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
                                  gambarWidget: bukanGambar ? FittedBox(
                                    child: alat.bangunTeksGradien(
                                      teks: susunan[i].split("_").last, 
                                      warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                                    )
                                  ) : null,
                                  gambar: bukanGambar ? null : [susunan[i]],
                                  pakaiHover: true,
                                  padaHoverAnimasi: padaHoverAnimasi1,
                                  padaHoverGarisLuarGradient: alat.terpilih,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ),
        ])
      );
    }

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: CardStatis(
            padding: 10,
            tepiRadius: 10,
            isiTengah: true,
            kotakWarna: alat.kotakUtama,
            judul: widget.penjelas,
            fontJudul: alat.judul,
            judulUkuran: 17,
            judulWarna: alat.teksPutihSedang,
            susunGambarTeksBaris: Axis.vertical,
          ),
        ),
        const SizedBox(height: 10),

        Expanded(
          flex: 7,
          child: Row(
            children: [
              bangunSusunan(susunan: susunanSemua[0], indexSusunan: 0),
              SizedBox(width: 10),
              bangunPemisah(),
              SizedBox(width: 10),
              bangunSusunan(susunan: susunanSemua[1], indexSusunan: 1)
            ],
          )
        )
        // ============================
        // Card Jawaban Dinamis
        // ============================

      ],
    );
  }
}


// soal model 4
class DragContent {
  final String? text;
  final String? image;

  DragContent({this.text, this.image});

  bool get isText => text != null;
}

class SoalModel4 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> susunanAwal;
  final List<dynamic> susunanAtas;
  final List<dynamic> opsi;
  final Function(List<List<dynamic>> atas)? padaSelesaiSusun;

  const SoalModel4({
    super.key,
    required this.penjelas,
    required this.susunanAwal,
    required this.susunanAtas,
    required this.opsi,
    this.padaSelesaiSusun,
  });

  @override
  State<SoalModel4> createState() => _SoalModel4State();
}

class _SoalModel4State extends State<SoalModel4> {
  List<bool> susunanAwal = [];
  late List<String?> susunanAtas;
  late List<String> susunanBawah;

  @override
  void initState() {
    super.initState();
    susunanAwal = widget.susunanAwal.map((e) => e != null).toList();

    // FIX: pastikan susunanAtas benar-benar list<String?>
    susunanAtas = widget.susunanAtas.map((e) => e != null ? e.toString() : null).toList();

    // Ambil opsi sebagai List<String>
    final opsi = widget.opsi.map((e) => e.toString()).toList();

    // FIX: ambil hanya yang memang terisi di susunanAtas
    final dipakai = susunanAtas.where((e) => e != null).toList();

    // FIX: susunanBawah = semua opsi selain yang dipakai
    susunanBawah = opsi.where((e) => !dipakai.contains(e)).toList();
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
                      builder: (context, c, r) => SizedBox(
                        width: side,
                        height: side - 10, // tambah ruang untuk garis bawah
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // KOTAK UTAMA
                            Container(
                              width: side,
                              height: side,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,          // warna abu background (opsional)
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            // GARIS BIRU DI BAWAH KOTAK
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: side * 0.1,
                                width: side,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  }

                  if (fixed) {
                    return IgnorePointer(
                      child: CardStatis(
                        lebar: side,
                        tinggi: side,
                        padding: 10,
                        tepiRadius: 10,
                        kotakWarna: alat.kotak6,
                        pemisahGarisLuarUkuran: 10,
                        pemisahGarisLuarWarna: alat.outline6,
                        garisLuarUkuran: 10,
                        gambarWidget: bukanGambar ? FittedBox(
                          child: alat.bangunTeksGradien(
                            teks: item.split("_").last, 
                            warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                          )
                        ) : null,
                        gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(item)],
                        tanpaProvider: true,
                      ),
                    );
                  }
                  
                  return Draggable<Map<String, dynamic>>(
                    data: {"from": listName, "index": i, "value": item},
                    feedback: Material(
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
                          gambarWidget: bukanGambar ? FittedBox(
                            child: alat.bangunTeksGradien(
                              teks: item.split("_").last, 
                              warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                            )
                          ) : null,
                          gambarImage: bukanGambar ? null : [kDatabase.ambilGambar(item)],
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                          padaHoverGarisLuarGradient: alat.terpilih,
                          tanpaProvider: true,
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
                        gambarWidget: bukanGambar ? FittedBox(
                          child: alat.bangunTeksGradien(
                            teks: item.split("_").last, 
                            warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                          )
                          ) : null,
                        gambar: bukanGambar ? null : [item],
                      ),
                    ),
                    child: DragTarget<Map<String, dynamic>>(
                      onWillAcceptWithDetails: (details) {
                        /*final from = details.data;
                        final to = i;
                        objekDrag = from;
                        objekDiganti = to;
                        tukar(from, to);*/
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
                      onLeave: (details) {
                        /*final from = objekDiganti;
                        final to = objekDrag;

                        // Cegah crash
                        if (from == null || to == null) {
                          objekDrag = objekDiganti = null;
                          return;
                        }

                        objekDrag = objekDiganti = null;
                        tukar(from, to);*/
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
                        gambarWidget: bukanGambar ? FittedBox(
                          child: alat.bangunTeksGradien(
                            teks: item.split("_").last, 
                            warna: alat.terpilih, font: alat.judul, ukuranFont: 10
                          )
                        ) : null,
                        gambar: bukanGambar ? null : [item],
                        pakaiHover: true,
                        padaHoverAnimasi: padaHoverAnimasi1,
                        padaHoverGarisLuarGradient: alat.terpilih,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    return Column(
      children: [
        /// PENJELAS
        Expanded(
          flex: 8,
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: alat.kotakUtama,
              borderRadius: BorderRadius.circular(10),
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
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ],
            )
          )
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
  final int panjangRangkaian;
  final Function(List<String?> susunan)? padaRangkai;
  final List<String?> rangkaian;

  const SoalModel5({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.panjangRangkaian,
    this.padaRangkai,
    required this.rangkaian
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
          // true = mendapat fokus (kursor muncul)
          // false = kehilangan fokus

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
        Expanded(
          flex: 8,
          child: CardStatis(
            padding: 10,
            tepiRadius: 10,
            isiTengah: true,
            kotakWarna: alat.kotakUtama,
            gambar: gambarSoal,
            paddingGambar: 10,
            tepiRadiusGambar: 10,
            warnaGambarColor: alat.kotakPutih,
            jarakGambarPemisah: 10,
            pemisahGambar: Icon(
              Icons.double_arrow_rounded,
              size: 10,
            ),
            besarPemisahGambar: 10,
            judul: widget.penjelas,
            fontJudul: alat.judul,
            judulUkuran: 17,
            judulWarna: alat.teksPutihSedang,
            susunGambarTeksBaris: Axis.vertical,
          ),
        ),
        const SizedBox(height: 30),

        Expanded(
          flex: 6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final parentHeight = constraints.maxHeight - alat.ukuranFooter;
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
                          gambarWidget: SizedBox.expand(
                            child: TextField(
                              controller: _ctrl[i],
                              focusNode: _focus[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: alat.teksHitam,
                                fontFamily: alat.judul,
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                              ),
                              maxLength: 1,
                              // hanya huruf/angka
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                LengthLimitingTextInputFormatter(1),
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
                          ),
                          pakaiKlik: true,
                          padaKlik: () {
                            _focus[i].requestFocus();
                          },
                          dipilih: pilihan == i+1,
                          padaDipilihAnimasi: padaPilihAnimasi1,
                          padaDipilihGradientPemisahGarisLuar: alat.terpilih,
                        );
                    },
                  ),
                ),
              );
            },
          ),
        )
    ]
    );
  }
}

/// Kotak input kecil dengan garis tetap di bawahnya.
/// - hanya menerima huruf (A-Z, a-z) dan angka (0-9)
/// - default maxChars = 1 (ubah jika mau lebih)
class BoxWithUnderline extends StatefulWidget {
  final double width;
  final double height;
  final int maxChars;
  final String? initialText;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;
  final Color boxColor;
  final Color underlineColor;
  final double underlineHeight;
  final BorderRadius borderRadius;

  const BoxWithUnderline({
    super.key,
    this.width = 80,
    this.height = 80,
    this.maxChars = 1,
    this.initialText,
    this.onChanged,
    this.textStyle,
    this.boxColor = const Color(0xFFE8E8E8),
    this.underlineColor = Colors.blue,
    this.underlineHeight = 6.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  State<BoxWithUnderline> createState() => _BoxWithUnderlineState();
}

class _BoxWithUnderlineState extends State<BoxWithUnderline> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialText ?? "");
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ??
        TextStyle(
          fontSize: widget.height * 0.35,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );

    return SizedBox(
      width: widget.width,
      // total height includes box + underline spacing; at minimum use height + underlineHeight + small gap
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // kotak input
          GestureDetector(
            onTap: () => _focus.requestFocus(),
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.boxColor,
                borderRadius: widget.borderRadius,
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _ctrl,
                focusNode: _focus,
                textAlign: TextAlign.center,
                style: textStyle,
                maxLength: widget.maxChars,
                // hanya huruf/angka
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  LengthLimitingTextInputFormatter(widget.maxChars),
                ],
                decoration: const InputDecoration(
                  isCollapsed: true,
                  counterText: '', // sembunyikan counter
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // garis fixed di bawah kotak
          Container(
            width: widget.width * 0.7, // lebar garis bisa disesuaikan
            height: widget.underlineHeight,
            decoration: BoxDecoration(
              color: widget.underlineColor,
              borderRadius: BorderRadius.circular(widget.underlineHeight / 2),
            ),
          ),
        ],
      ),
    );
  }
}



// lama
/*
class SoalModel2null extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarOpsi;
  final Function(List<String> susunan)? padaSusun;

  const SoalModel2null({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarOpsi,
    this.padaSusun,
  });

  @override
  State<SoalModel2null> createState() => _SoalModel2State();
}

class _SoalModel2nState extends State<SoalModel2> {
  List<String> soal = [];
  List<String> items = [];
  int? draggingIndex;
  late AlatApp alat;
  
  @override
  void initState() {
    super.initState();

    for (var gambar in widget.gambarSoal) {
      soal.add(gambar.toString());
    }
    for (var gambar in widget.gambarOpsi) {
      items.add(gambar.toString());
    }
    alat = context.read<AlatApp>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: CardStatis(
            padding: 10,
            tepiRadius: 10,
            isiTengah: true,
            kotakWarna: alat.kotakUtama,
            gambar: soal,
            besarGambar: null,
            paddingGambar: 10,
            tepiRadiusGambar: 10,
            warnaGambarColor: alat.kotakPutih,
            jarakGambarPemisah: 10,
            pemisahGambar: Icon(
              Icons.double_arrow_rounded,
              size: 10,
            ),
            besarPemisahGambar: 10,
            judul: widget.penjelas,
            fontJudul: alat.judul,
            judulUkuran: 17,
            judulWarna: alat.teksPutihSedang,
            susunGambarTeksBaris: Axis.vertical,
          ),
        ),
        const SizedBox(height: 30),

        // ============================
        // Card Jawaban Dinamis
        // ============================
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              final parentHeight = constraints.maxHeight;

              final side = min(parentWidth / 4 - 20, parentHeight / 4 - 20);

              return Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: List.generate(items.length, (i) {
                    final isDragging = draggingIndex == i;

                    return DragTarget<int>(
                      onWillAccept: (from) {
                        // geser item saat hover
                        if (from != i) {
                          final moved = items.removeAt(from!);
                          items.insert(i, moved);
                          draggingIndex = i;
                        }
                        return true;
                      },
                      onAccept: (_) {
                        draggingIndex = null;
                        if (widget.tes) {
                          kTes.aturSusunanJawabanListString(items);
                        } else {
                          kKuis.aturSusunanJawabanListString(items);
                        }
                        draggingIndex = null;
                      },

                      builder: (context, candidate, reject) {
                        if (isDragging) {
                          return Opacity(
                            opacity: 0.2,
                            child: Container(
                              width: side,
                              height: side,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }

                        return Draggable<int>(
                          data: i,
                          onDragStarted: () {
                            setState(() => draggingIndex = i);
                          },
                          onDragEnd: (_) {
                            setState(() => draggingIndex = null);
                          },
                          feedback: SizedBox(
                            width: side,
                            height: side,
                            child: CardStatis(
                              lebar: side,
                              tinggi: side,
                              gambar: [susunanJawaban[i]],
                              padding: 10,
                              tepiRadius: 10,
                              garisLuarUkuran: 10,
                              pakaiHover: true,
                              padaHoverAnimasi: padaHoverAnimasi1,
                              padaHoverPakaiBayangan: true,
                              padaHoverGarisLuarWarna: Colors.blue,
                            ),
                          ),
                          childWhenDragging: SizedBox(
                            width: side,
                            height: side,
                            child: Opacity(
                              opacity: 0.0,
                            ),
                          ),
                          child: SizedBox(
                            width: side,
                            height: side,
                            child: CardStatis(
                              lebar: side,
                              tinggi: side,
                              gambar: [susunanJawaban[i]],
                              padding: 10,
                              tepiRadius: 10,
                              garisLuarUkuran: 10,
                              pakaiHover: true,
                              padaHoverAnimasi: padaHoverAnimasi1,
                              padaHoverPakaiBayangan: true,
                              padaHoverGarisLuarWarna: Colors.blue,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SoalModel3null extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarJawaban;
  final bool tes;

  const SoalModel3null({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarJawaban,
    required this.tes,
  });

  @override
  State<SoalModel3null> createState() => _SoalModel3State();
}

class _SoalModel3State extends State<SoalModel3> {
  

  @override
  Widget build(BuildContext context) {
    final kDatabase = context.read<KontrolDatabase>();
    final kTes = context.read<KontrolTes>();
    final kKuis = context.read<KontrolKuis>();
    List<List<String>> susunanOpsiKiriKanan = [[], []];
    List<List<String>> barang = [[], []];
    int? draggingIndex; // index card yang sedang didrag
    late List<List<String>> susunanJawaban;

    for (var soal in widget.gambarJawaban) { //kanan
      susunanOpsiKiriKanan[1].add(soal.toString());
    }
    for (var opsi in widget.gambarJawaban) { //kiri
      susunanOpsiKiriKanan[0].add(opsi.toString());
    }
    
    if (widget.tes) {
      susunanJawaban = context.select<KontrolTes, List<List<String>>>(
        (k) => k.susunanJawabanListListString
      );
      kTes.aturSusunanJawabanListListString(susunanOpsiKiriKanan);
      barang = susunanJawaban;
    } else {
      susunanJawaban = context.select<KontrolKuis, List<List<String>>>(
        (k) => k.susunanJawabanListListString
      );
      kKuis.aturSusunanJawabanListListString(susunanOpsiKiriKanan);
      barang = susunanJawaban;
    }

    Expanded buatDraggable(List<String> items, List<String> susunanOpsi){
      return Expanded(
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final parentWidth = constraints.maxWidth;
                final parentHeight = constraints.maxHeight;

                final side = min(parentWidth / 4 - 20, parentHeight / 4 - 20);

                return Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: List.generate(items.length, (i) {
                      final isDragging = draggingIndex == i;

                      return DragTarget<int>(
                        onWillAccept: (from) {
                          // geser item saat hover
                          if (from != i) {
                            final moved = items.removeAt(from!);
                            items.insert(i, moved);
                            draggingIndex = i;
                          }
                          return true;
                        },
                        onAccept: (_) {
                          if (widget.tes) {
                            kTes.aturSusunanJawabanListString(items);
                          } else {
                            kKuis.aturSusunanJawabanListString(items);
                          }
                          draggingIndex = null;
                          setState(() {});
                        },

                        builder: (context, candidate, reject) {
                          if (isDragging) {
                            return Opacity(
                              opacity: 0.2,
                              child: Container(
                                width: side,
                                height: side,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }

                          return Draggable<int>(
                            data: i,
                            onDragStarted: () {
                              draggingIndex = i;
                              setState(() {});
                            },
                            onDragEnd: (_) {
                              draggingIndex = null;
                              setState(() {});
                            },
                            feedback: SizedBox(
                              width: side,
                              height: side,
                              child: CardStatis(
                                lebar: side,
                                tinggi: side,
                                gambar: [susunanOpsi[i]],
                                padding: 10,
                                tepiRadius: 10,
                                garisLuarUkuran: 10,
                                pakaiHover: true,
                                padaHoverAnimasi: padaHoverAnimasi1,
                                padaHoverPakaiBayangan: true,
                                padaHoverGarisLuarWarna: Colors.blue,
                              ),
                            ),
                            childWhenDragging: SizedBox(
                              width: side,
                              height: side,
                              child: Opacity(
                                opacity: 0.0,
                                child: CardStatis(
                                  lebar: side,
                                  tinggi: side,
                                  gambar: [susunanOpsi[i]],
                                  padding: 10,
                                  tepiRadius: 10,
                                  garisLuarUkuran: 10,
                                  pakaiHover: true,
                                  padaHoverAnimasi: padaHoverAnimasi1,
                                  padaHoverPakaiBayangan: true,
                                  padaHoverGarisLuarWarna: Colors.blue,
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width: side,
                              height: side,
                              child: CardStatis(
                                lebar: side,
                                tinggi: side,
                                gambar: [susunanOpsi[i]],
                                padding: 10,
                                tepiRadius: 10,
                                garisLuarUkuran: 10,
                                pakaiHover: true,
                                padaHoverAnimasi: padaHoverAnimasi1,
                                padaHoverPakaiBayangan: true,
                                padaHoverGarisLuarWarna: Colors.blue,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                );
              },
            ),
          ]
        )
      );
    }
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buatDraggable(susunanJawaban[0], barang[0]),
          
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(susunanJawaban[0].length, (i) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 22),
                  child: Text(
                    "=",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ),
          ),

          buatDraggable(susunanJawaban[1], barang[1]),
        ],
      )
    );
  }
}*/