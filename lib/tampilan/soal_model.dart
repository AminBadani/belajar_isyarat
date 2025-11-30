import 'package:belajar_isyarat/kontrol/kontrol_database.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SoalModel1 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarJawaban;
  final bool tes;

  const SoalModel1({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarJawaban,
    required this.tes,
  });

  @override
  State<SoalModel1> createState() => _SoalModel1State();
}

class _SoalModel1State extends State<SoalModel1> {
  @override
  Widget build(BuildContext context) {
    final kDatabase = context.read<KontrolDatabase>();
    final kTes = context.read<KontrolTes>();
    final kKuis = context.read<KontrolKuis>();
    late int pilihanJawaban;
    
    if (widget.tes) {
      pilihanJawaban = context.select<KontrolTes, int>(
        (k) => k.pilihanKotak
      );
    } else {
      pilihanJawaban = context.select<KontrolKuis, int>(
        (k) => k.pilihanKotak
      );
    }
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Kotak gambar
              widget.gambarSoal.isEmpty 
                ? SizedBox.shrink()
                : SizedBox(
                  width: 120,
                  height: 120,
                  child: Row(
                    children: [
                      for (var gambar in widget.gambarSoal) kDatabase.ambilGambar(gambar.toString())
                    ],
                  ),
                ),
              const SizedBox(width: 16),

              // Kotak penjelas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.penjelas,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
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
              final side = min(parentWidth, parentHeight);

              return Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,     // <= PENTING: agar ditengah
                  children: List.generate(
                    widget.gambarJawaban.length,
                    (i) {
                      return SizedBox(
                        width: side,
                        height: side,
                        child: CardStatis(
                          lebar: side,
                          tinggi: side,
                          padding: 10,
                          tepiRadius: 10,
                          garisLuarUkuran: 10,
                          gambar: [widget.gambarJawaban[i].toString()],
                          pakaiKlik: true,
                          pakaiHover: true,
                          padaHoverAnimasi: padaHoverAnimasi1,
                          padaHoverPakaiBayangan: true,
                          padaHoverGarisLuarWarna: Colors.white,
                          padaKlikAnimasi: padaKlikAnimasi1,
                          padaKlik: widget.tes
                              ? () => kTes.aturPilihanKotak(i + 1)
                              : () => kKuis.aturPilihanKotak(i + 1),
                          dipilih: pilihanJawaban == i + 1,
                        ),
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
class SoalModel2 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarJawaban;
  final bool tes;

  const SoalModel2({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarJawaban,
    required this.tes,
  });

  @override
  State<SoalModel2> createState() => _SoalModel2State();
}

class _SoalModel2State extends State<SoalModel2> {
  late List<String> items;
  int? draggingIndex;
  
  @override
  void initState() {
    super.initState();

    if (widget.tes) {
      items = List.from(context.read<KontrolTes>().susunanJawabanListString);
    } else {
      items = List.from(context.read<KontrolKuis>().susunanJawabanListString);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kDatabase = context.read<KontrolDatabase>();
    final kTes = context.read<KontrolTes>();
    final kKuis = context.read<KontrolKuis>();
    List<String> susunanOpsi = [];
    late List<String> susunanJawaban;

    for (var opsi in widget.gambarJawaban) {
      susunanOpsi.add(opsi.toString());
    }
    
    if (widget.tes) {
      susunanJawaban = context.select<KontrolTes, List<String>>(
        (k) => k.susunanJawabanListString
      );
    } else {
      susunanJawaban = context.select<KontrolKuis, List<String>>(
        (k) => k.susunanJawabanListString
      );
    }
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // Kotak gambar
              widget.gambarSoal.isEmpty 
                ? SizedBox.shrink()
                : SizedBox(
                  width: 120,
                  height: 120,
                  child: Row(
                    children: [
                      for (var gambar in widget.gambarSoal) kDatabase.ambilGambar(gambar.toString())
                    ],
                  ),
                ),
              const SizedBox(width: 16),

              // Kotak penjelas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.penjelas,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
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

// soal model 3
class SoalModel3 extends StatefulWidget {
  final String penjelas;
  final List<dynamic> gambarSoal;
  final List<dynamic> gambarJawaban;
  final bool tes;

  const SoalModel3({
    super.key,
    required this.penjelas,
    required this.gambarSoal,
    required this.gambarJawaban,
    required this.tes,
  });

  @override
  State<SoalModel3> createState() => _SoalModel3State();
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
}
class TesBodyBawah extends StatelessWidget {
  final List<Widget> leftItems;
  final List<Widget> rightItems;
  final bool tes;

  final void Function(int oldIndex, int newIndex) onReorderLeft;
  final void Function(int oldIndex, int newIndex) onReorderRight;

  const TesBodyBawah({
    super.key,
    required this.leftItems,
    required this.rightItems,
    required this.onReorderLeft,
    required this.onReorderRight,
    required this.tes,
  });

  @override
  Widget build(BuildContext context) {
    int jumlah = leftItems.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // KIRI
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(jumlah, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TesItemDraggable(
                  child: leftItems[i],
                  index: i,
                  onReorder: onReorderLeft,
                ),
              );
            }),
          ),
        ),

        // TENGAH "="
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(jumlah, (i) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Text(
                "=",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),

        // KANAN
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(jumlah, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TesItemDraggable(
                  child: rightItems[i],
                  index: i,
                  onReorder: onReorderRight,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class TesItemDraggable extends StatefulWidget {
  final Widget child;
  final int index;
  final void Function(int from, int to) onReorder;

  const TesItemDraggable({
    super.key,
    required this.child,
    required this.index,
    required this.onReorder,
  });

  @override
  State<TesItemDraggable> createState() => _TesItemDraggableState();
}

class _TesItemDraggableState extends State<TesItemDraggable>
    with SingleTickerProviderStateMixin {
  bool hovering = false;
  bool dragging = false;

  late AnimationController shakeCtrl;
  late Animation<double> shakeAnim;

  @override
  void initState() {
    super.initState();

    shakeCtrl = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    shakeAnim = Tween<double>(begin: -2, end: 2)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(shakeCtrl);
  }

  @override
  void dispose() {
    shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<int>(
      data: widget.index,
      onDragStarted: () {
        dragging = true;
        shakeCtrl.repeat(reverse: true);
        setState(() {});
      },
      onDragEnd: (_) {
        dragging = false;
        shakeCtrl.stop();
        setState(() {});
      },
      feedback: Transform.scale(
        scale: 1.13,
        child: Material(color: Colors.transparent, child: widget.child),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: widget.child,
      ),
      child: DragTarget<int>(
        onAccept: (oldIndex) {
          widget.onReorder(oldIndex, widget.index);
        },
        builder: (context, candidate, rejected) {
          return MouseRegion(
            onEnter: (_) => setState(() => hovering = true),
            onExit: (_) => setState(() => hovering = false),
            child: AnimatedScale(
              scale: hovering ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: AnimatedBuilder(
                animation: shakeCtrl,
                builder: (_, child) {
                  return Transform.translate(
                    offset: dragging
                        ? Offset(shakeAnim.value, 0)
                        : Offset.zero,
                    child: child!,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1),
                    color: Colors.white,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
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

class BodyDragFill extends StatefulWidget {
  final List<DragContent?> slotAtas; // nilai awal (string/null)
  final List<DragContent> kontenBawah;

  const BodyDragFill({
    super.key,
    required this.slotAtas,
    required this.kontenBawah,
  });

  @override
  State<BodyDragFill> createState() => _BodyDragFillState();
}

class _BodyDragFillState extends State<BodyDragFill> {
  late List<DragContent?> atas;
  late List<DragContent> bawah;

  @override
  void initState() {
    super.initState();
    atas = List.from(widget.slotAtas);
    bawah = List.from(widget.kontenBawah);
  }

  void pindahKeAtas(int slotIndex, DragContent konten) {
    setState(() {
      atas[slotIndex] = konten;
      bawah.remove(konten);
    });
  }

  void pindahKeBawah(int slotIndex) {
    final konten = atas[slotIndex];
    if (konten != null) {
      setState(() {
        bawah.add(konten);
        atas[slotIndex] = null;
      });
    }
  }

  void reorderBawah(int from, int to) {
    setState(() {
      final item = bawah.removeAt(from);
      bawah.insert(to, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //----------------------------
        // BAGIAN KOTAK ATAS
        //----------------------------
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(atas.length, (i) {
              final slotVal = atas[i];

              // Jika bukan null DAN bukan konten dari bawah → slot fix
              if (slotVal != null &&
                  !widget.kontenBawah.contains(slotVal)) {
                return _buildKotakFix(slotVal);
              }

              // Jika slot kosong → area drop
              if (slotVal == null) {
                return DragTarget<DragContent>(
                  onWillAccept: (data) => true,
                  onAccept: (data) => pindahKeAtas(i, data),
                  builder: (_, __, ___) {
                    return Container(
                      width: 100,
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.grey.shade100,
                      ),
                      child: const Text("_",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    );
                  },
                );
              }

              // Jika berisi konten dari bawah → konten drag-able
              return TesDragItem(
                konten: slotVal,
                onDroppedOutside: () => pindahKeBawah(i),
              );
            }),
          ),
        ),

        const SizedBox(height: 30),

        //----------------------------
        // BAGIAN KOTAK BAWAH
        //----------------------------
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: List.generate(bawah.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TesDragItem(
                  konten: bawah[i],
                  index: i,
                  reorderCallback: reorderBawah,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildKotakFix(DragContent c) {
    return Container(
      width: 100,
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.grey.shade200,
      ),
      child: c.isText
          ? Text(c.text!)
          : Image.asset(c.image!, height: 40),
    );
  }
}

class TesDragItem extends StatefulWidget {
  final DragContent konten;
  final int? index;
  final void Function(int from, int to)? reorderCallback;
  final VoidCallback? onDroppedOutside;

  const TesDragItem({
    super.key,
    required this.konten,
    this.index,
    this.reorderCallback,
    this.onDroppedOutside,
  });

  @override
  State<TesDragItem> createState() => _TesDragItemState();
}

class _TesDragItemState extends State<TesDragItem>
    with SingleTickerProviderStateMixin {
  bool hovering = false;
  bool dragging = false;

  late AnimationController shakeCtrl;
  late Animation<double> shakeAnim;

  @override
  void initState() {
    super.initState();
    shakeCtrl = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    shakeAnim = Tween(begin: -3.0, end: 3.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(shakeCtrl);
  }

  @override
  void dispose() {
    shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<DragContent>(
      data: widget.konten,
      onDragStarted: () {
        dragging = true;
        shakeCtrl.repeat(reverse: true);
        setState(() {});
      },
      onDragEnd: (details) {
        dragging = false;
        shakeCtrl.stop();

        // Jika bukan drop ke tempat yang valid
        if (!details.wasAccepted) {
          if (widget.onDroppedOutside != null) {
            widget.onDroppedOutside!();
          }
        }

        setState(() {});
      },
      feedback: Transform.scale(
        scale: 1.12,
        child: Material(
          color: Colors.transparent,
          child: _contentBox(),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: _contentBox(),
      ),
      child: DragTarget<DragContent>(
        onWillAccept: (data) => widget.reorderCallback != null,
        onAccept: (incoming) {
          if (widget.index != null &&
              widget.reorderCallback != null) {
            widget.reorderCallback!(
              incomingIndex(incoming),
              widget.index!,
            );
          }
        },
        builder: (_, __, ___) {
          return MouseRegion(
            onEnter: (_) => setState(() => hovering = true),
            onExit: (_) => setState(() => hovering = false),
            child: AnimatedScale(
              scale: hovering ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 140),
              child: AnimatedBuilder(
                animation: shakeCtrl,
                builder: (_, child) {
                  return Transform.translate(
                    offset: dragging
                        ? Offset(shakeAnim.value, 0)
                        : Offset.zero,
                    child: child!,
                  );
                },
                child: _contentBox(),
              ),
            ),
          );
        },
      ),
    );
  }

  int incomingIndex(DragContent c) =>
      widget.index ?? 0;

  Widget _contentBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 110,
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: widget.konten.isText
          ? Center(child: Text(widget.konten.text!))
          : Image.asset(widget.konten.image!, height: 40),
    );
  }
}

// soal model 5
class SoalModel5 extends StatefulWidget {
  final List<String> gambarList; // contoh: ["g1","g2","g3"]
  final String penjelas;
  final int jumlahKotak; // jumlah kotak huruf

  const SoalModel5({
    super.key,
    required this.gambarList,
    required this.penjelas,
    required this.jumlahKotak,
  });

  @override
  State<SoalModel5> createState() => _SoalModel5State();
}

class _SoalModel5State extends State<SoalModel5> {
  late List<String?> jawaban;
  late List<FocusNode> fokus;

  @override
  void initState() {
    super.initState();
    jawaban = List<String?>.filled(widget.jumlahKotak, null);
    fokus = List.generate(widget.jumlahKotak, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var f in fokus) {
      f.dispose();
    }
    super.dispose();
  }

  Widget _buildKotakHuruf(int index) {
    bool isFocus = fokus[index].hasFocus;
    String isi = jawaban[index] ?? "";

    return Focus(
      focusNode: fokus[index],
      onFocusChange: (_) => setState(() {}),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: isFocus ? 55 : 45,
        height: isFocus ? 55 : 45,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: KeyboardListener(
          focusNode: fokus[index],
          onKeyEvent: (event) {
            if (event is! KeyDownEvent) return;

            String key = event.character ?? "";

            // hanya huruf A-Z a-z dan angka 0-9
            final regex = RegExp(r"[A-Za-z0-9]");

            if (regex.hasMatch(key)) {
              setState(() {
                jawaban[index] = key.characters.last.toUpperCase();
              });
            }

            // backspace → hapus
            if (event.logicalKey.keyLabel == "Backspace") {
              setState(() => jawaban[index] = null);
            }
          },
          child: Text(
            isi,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildGambar(String label) {
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // =================== BAGIAN ATAS ===================
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 2),
          ),
          child: Column(
            children: [
              // list gambar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.gambarList
                    .map((g) => _buildGambar("gambar"))
                    .toList(),
              ),
              const SizedBox(height: 12),
              // teks penjelas
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                ),
                child: Text(widget.penjelas),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // =================== BAGIAN BAWAH ===================
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.jumlahKotak,
              (i) => _buildKotakHuruf(i),
            ),
          ),
        )
      ],
    );
  }
}