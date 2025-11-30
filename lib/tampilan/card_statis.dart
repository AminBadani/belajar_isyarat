import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/kontrol/kontrol_database.dart'; // untuk ambilGambar()

class CardStatis extends StatefulWidget {
  final double? lebar;
  final double? tinggi;
  final double? padding;

  final String? teks;
  final String? judul;
  final double? teksUkuran;
  final double? judulUkuran;
  final String fontJudul;
  final String fontTeks;
  final bool garisBawahJudul;

  final List<String>? gambar;
  final double? besarGambar;
  final double paddingGambar; // padding tiap gambar
  final double tepiRadiusGambar;
  final Color? warnaGambarColor;
  final LinearGradient? warnaGambarGradient;

  final Widget? pemisahGambar; // Bisa Image atau Icon
  final double besarPemisahGambar;
  final double jarakGambarPemisah;

  final double? jarakKontenUkuran;

  final Color teksWarna;
  final Color judulWarna;

  final double tepiRadius;
  final Axis susunGambarTeksBaris;

  final Color kotakWarna;
  final Color? padaHoverkotakWarna;

  final double garisLuarUkuran;
  final Color? garisLuarWarna;
  final LinearGradient? garisLuarGradient;
  final Color? padaHoverGarisLuarWarna;
  final LinearGradient? padaHoverGarisLuarGradient;

  final double pemisahGarisLuarUkuran;
  final Color? pemisahGarisLuarWarna;
  final LinearGradient? pemisahGarisLuarGradient;
  final Color? padaHoverPemisahGarisLuarWarna;
  final LinearGradient? padaHoverPemisahGarisLuarGradient;

  final bool padaHoverPakaiBayangan;

  final Widget? tanda;

  final bool pakaiHover;
  //final bool pakaiDrag;
  final bool pakaiKlik;

  final VoidCallback? padaKlik;

  final bool teksTengah;
  final bool isiTengah;

  final bool soalBenar;
  final bool soalSalah;
  final Function(AnimationController)? soalAnimasiBenarSalah;

  /*final Offset Function(double t)? padaDragAnimasi;
  final Function(AnimationController)? padaDragAwal;
  final Function(AnimationController)? padaDragAkhir;
  final VoidCallback? padaDragAkhirPanggil;*/

  final Function(AnimationController)? padaKlikAnimasi;
  final Function(AnimationController)? padaHoverAnimasi;
  final Function(AnimationController)? padaMasukAnimasi;

  final bool dipilih;
  final Function(AnimationController)? padaDipilihAnimasi;
  final Color? padaDipilihWarnaGarisLuar;
  final LinearGradient? padaDipilihGradientGarisLuar;
  final Color? padaDipilihWarnaPemisahGarisLuar;
  final LinearGradient? padaDipilihGradientPemisahGarisLuar;

  const CardStatis({
    super.key,
    this.lebar,
    this.tinggi,
    this.padding,

    this.teks,
    this.judul,
    this.teksUkuran,
    this.judulUkuran,
    this.fontJudul = "Fredoka",
    this.fontTeks = "Mulish",
    this.garisBawahJudul = false,

    this.gambar,
    this.besarGambar,
    this.paddingGambar = 0.0,
    this.tepiRadiusGambar = 0.0,
    this.warnaGambarColor,
    this.warnaGambarGradient,

    this.pemisahGambar,
    this.besarPemisahGambar = 0.0,
    this.jarakGambarPemisah = 0.0,

    this.jarakKontenUkuran,

    this.teksWarna = Colors.black,
    this.judulWarna = Colors.black,

    this.tepiRadius = 0.0,
    this.susunGambarTeksBaris = Axis.horizontal,

    this.kotakWarna = Colors.white,
    this.garisLuarWarna,
    this.garisLuarUkuran = 0.0,
    this.garisLuarGradient,
    this.padaHoverGarisLuarWarna,
    this.padaHoverGarisLuarGradient,

    this.pemisahGarisLuarUkuran = 0.0,
    this.pemisahGarisLuarWarna,
    this.pemisahGarisLuarGradient,
    this.padaHoverPemisahGarisLuarWarna,
    this.padaHoverPemisahGarisLuarGradient,

    this.tanda,

    this.padaHoverkotakWarna,
    this.padaHoverPakaiBayangan = false,

    this.pakaiHover = false,
    //this.pakaiDrag = false,
    this.pakaiKlik = false,

    this.padaKlik,

    this.teksTengah = false,
    this.isiTengah = false,

    this.soalBenar = false, //deprecated
    this.soalSalah = false, //deprecated
    this.soalAnimasiBenarSalah,

    /*this.padaDragAnimasi,
    this.padaDragAwal,
    this.padaDragAkhir,
    this.padaDragAkhirPanggil,*/

    this.padaKlikAnimasi,
    this.padaHoverAnimasi,
    this.padaMasukAnimasi,

    this.dipilih = false,
    this.padaDipilihAnimasi,
    this.padaDipilihWarnaGarisLuar,
    this.padaDipilihGradientGarisLuar,
    this.padaDipilihWarnaPemisahGarisLuar,
    this.padaDipilihGradientPemisahGarisLuar
  });

  @override
  State<CardStatis> createState() => _CardStatisState();
}

class _CardStatisState extends State<CardStatis> with TickerProviderStateMixin {
  late AnimationController _hoverSmooth;
  late Animation<double> _hoverValue;
  late AnimationController _hoverController;
  late AnimationController _klikController;
  late AnimationController _masukController;
  late AnimationController _dipilihController;

  bool _hover = false;
  //bool _drag = false;
  bool _klik = false;

  @override
  void initState() {
    super.initState();
      _hoverSmooth = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _hoverValue = CurvedAnimation(
      parent: _hoverSmooth,
      curve: Curves.easeOut,
    );


    // Semua controller dapat duration default agar tidak error
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _klikController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    /* Tidak pakai unbounded lagi
    _dragController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 200),
    );*/

    _masukController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _dipilihController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Jika tidak ada animasi masuk yang disediakan, set nilai masuk controller ke 1
    // sehingga card tidak memulai dari skala 0.7 (terlalu kecil).
    if (widget.padaMasukAnimasi != null) {
      widget.padaMasukAnimasi!(_masukController);
    } else {
      _masukController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _klikController.dispose();
    _masukController.dispose();
    _dipilihController.dispose();
    super.dispose();
  }

  Widget _bangunPemisahGarisLuar(Widget child) {
    final pemisahGarisLuarColor = widget.dipilih 
        ? widget.padaDipilihWarnaPemisahGarisLuar
        : _hover && widget.pakaiHover
        ? (widget.padaHoverPemisahGarisLuarWarna ?? widget.pemisahGarisLuarWarna)
        : widget.pemisahGarisLuarWarna;
    final pemisahGarisLuarGradient = widget.dipilih 
        ? widget.padaDipilihGradientPemisahGarisLuar
        : _hover && widget.pakaiHover
        ? (widget.padaHoverPemisahGarisLuarGradient ?? widget.pemisahGarisLuarGradient)
        : widget.pemisahGarisLuarGradient;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.all(widget.pemisahGarisLuarUkuran),
      decoration: BoxDecoration(
        color: pemisahGarisLuarColor,
        gradient: pemisahGarisLuarGradient,
        borderRadius: BorderRadius.circular(widget.tepiRadius + widget.pemisahGarisLuarUkuran/2)
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _bangunGarisLuar(Widget child) {
    final garisLuarColor = widget.dipilih 
        ? widget.padaDipilihWarnaGarisLuar
        : _hover && widget.pakaiHover
        ? (widget.padaHoverGarisLuarWarna ?? widget.garisLuarWarna)
        : widget.garisLuarWarna;
    final garisLuarGradient = widget.dipilih 
        ? widget.padaDipilihGradientGarisLuar
        : _hover && widget.pakaiHover
        ? (widget.padaHoverGarisLuarGradient ?? widget.garisLuarGradient)
        : widget.garisLuarGradient;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.all(widget.garisLuarUkuran),
      decoration: BoxDecoration(
        color: garisLuarColor,
        gradient: garisLuarGradient,
        borderRadius: BorderRadius.circular(
          widget.tepiRadius 
          + widget.pemisahGarisLuarUkuran/2
          + widget.garisLuarUkuran/2
        )
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _bangunContainerUtama(BuildContext context, Color color, double blurRadius, double width, double height) {
    final kontrolDatabase = context.watch<KontrolDatabase>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      height: height,
      padding: widget.padding == null ? null : EdgeInsets.all(widget.padding!),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(widget.tepiRadius),
      ),
      child: _isiKonten(kontrolDatabase),
    );
  } 
    @override
  Widget build(BuildContext context) {
    final boxColor = _hover && widget.pakaiHover
        ? (widget.padaHoverkotakWarna ?? widget.kotakWarna)
        : widget.kotakWarna;

    final bayangan = (_hover && widget.pakaiHover && widget.padaHoverPakaiBayangan)
        ? 10.0
        : 2.0;

    /*Offset dragOffset = Offset.zero;
    if (_drag && widget.pakaiDrag && widget.padaDragAnimasi != null) {
      // Batasi input ke padaDragAnimasi supaya selalu di [0,1]
      final t = _dragController.value.clamp(0.0, 1.0);
      final rawOffset = widget.padaDragAnimasi!(t);

      // Batasi offset agar tidak melontarkan widget keluar layar
      const maxDx = 24.0;
      const maxDy = 24.0;
      final dx = rawOffset.dx.clamp(-maxDx, maxDx);
      final dy = rawOffset.dy.clamp(-maxDy, maxDy);
      dragOffset = Offset(dx, dy);
    }*/

    // klik scale (tetap aman)
    final scaleKlik = 1.0 - (_klikController.value * 0.08); // kurangi dampak klik sedikit

    // masuk scale dan rotate (kurangi nilai rotasi & buat masukScale lebih aman)
    final masukScale = 0.9 + (0.1 * _masukController.value); // range 0.9..1.0
    final masukRotate = (-8 + (8 * _masukController.value)) * (pi / 180); // -8..0 deg

    // Helper clamp
    double clampDouble(double x, double min, double max) {
      if (x.isNaN) return min;
      if (x < min) return min;
      if (x > max) return max;
      return x;
    }

    return MouseRegion(
      onEnter: (_) {
        if (widget.pakaiHover) {
          setState(() => _hover = true);
          widget.padaHoverAnimasi?.call(_hoverController);
          _hoverSmooth.forward();
        }
      },
      onExit: (_) {
        if (widget.pakaiHover) {
          setState(() => _hover = false);
          _hoverController.reverse();
          _hoverSmooth.reverse();
        }
      },
      child: GestureDetector(
        onTapDown: widget.pakaiKlik ? (_) {
          setState(() => _klik = true);
          widget.padaKlikAnimasi?.call(_klikController);
        } : null,

        onTapUp: widget.pakaiKlik ? (_) {
          setState(() => _klik = false);
          if (widget.padaKlik != null) {widget.padaKlik!();}
        } : null,

        onTapCancel: widget.pakaiKlik ? () => setState(() => _klik = false) : null,

        /*onPanStart: widget.pakaiDrag ? (_) {
          setState(() => _drag = true);
          widget.padaDragAwal?.call(_dragController);
        } : null,

        onPanEnd: widget.pakaiDrag ? (_) {
          setState(() => _drag = false);
          widget.padaDragAkhir?.call(_dragController);
          widget.padaDragAkhirPanggil?.call();
        } : null,*/

        child: AnimatedBuilder(
          animation: _hoverSmooth,
          builder: (context, child) {
            final hoverValue = _hoverValue.value;
            final hoverScale = 1 + (0.04 * hoverValue); // sedikit lebih kecil effect
            final hoverRotate = 0.01 * hoverValue;

            // gabungkan scale (hover * klik * masuk)
            final rawFinalScale = hoverScale * scaleKlik * masukScale;

            // CLAMP agar tidak menjadi sangat kecil / sangat besar
            final finalScale = clampDouble(rawFinalScale, 0.85, 1.12);

            // gabungkan rotasi (hover + masuk)
            final finalRotate = hoverRotate + masukRotate;

            // debug prints (comment kalau sudah ok)
            // debugPrint('finalScale=$finalScale hoverVal=$hoverValue dx=${dragOffset.dx}'); sips

            return /*Transform.translate(
              offset: dragOffset,
              child: */Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(finalScale)
                  ..rotateZ(finalRotate),
                child: child,
              );
          },
          child: LayoutBuilder(
            builder: (context, c) {
              final lebar = widget.lebar ?? c.maxWidth;
              final tinggi = widget.tinggi ?? c.maxHeight;

              Widget inner = _bangunContainerUtama(context, boxColor, bayangan, lebar, tinggi);

              if (widget.pemisahGarisLuarUkuran > 0) {
                inner = _bangunPemisahGarisLuar(inner);
              }

              if (widget.garisLuarUkuran > 0) {
                inner = _bangunGarisLuar(inner);
              }

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  inner,
                  if (widget.tanda != null)
                    Positioned(
                      top: -20, // naik ke atas
                      right: -20, 
                      child: widget.tanda!,
                    ),
                ],
              );
            },
          )
        ),
      ),
    );
  }

  Widget _isiKonten(KontrolDatabase kontrolDatabase) {
    final gambarWidgets = widget.gambar?.map((e) => 
      AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.besarGambar,
        height: widget.besarGambar,
        decoration: BoxDecoration(
          color:widget.warnaGambarColor,
          borderRadius: BorderRadius.circular(widget.tepiRadiusGambar),
          gradient: widget.warnaGambarGradient,
        ),
        padding: EdgeInsets.all(widget.paddingGambar),
        child: kontrolDatabase.ambilGambar(e)
      )
    ).toList();

    List<Widget> gambarFinal = [];
    if (gambarWidgets != null && gambarWidgets.length > 1 && widget.pemisahGambar != null) {
      final gambarPemisah = AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: widget.besarPemisahGambar,
        height: widget.besarPemisahGambar,
        color: Colors.transparent,
        child: widget.pemisahGambar,
      );
      for (var i = 0; i < gambarWidgets.length - 2; i++) {
        gambarFinal.add(gambarWidgets[i]);
        gambarFinal.add(SizedBox(width: widget.jarakGambarPemisah));
        gambarFinal.add(gambarPemisah);
        gambarFinal.add(SizedBox(width: widget.jarakGambarPemisah));
      }
      gambarFinal.add(gambarWidgets.last);
    }

    final teksWidget = widget.teks != null
        ? Text(
            widget.teks!,
            textAlign: widget.teksTengah ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              fontFamily: widget.fontTeks,
              fontSize: widget.teksUkuran ?? 17, 
              color: widget.teksWarna
            ),
          )
        : null;

    final judulWidget = widget.judul != null
        ? Text(
            widget.judul!,
            style: TextStyle(
              fontFamily: widget.fontJudul,
              fontSize: widget.judulUkuran ?? 32,
              fontWeight: FontWeight.bold,
              color: widget.judulWarna,
              decoration: widget.garisBawahJudul ? TextDecoration.underline : null,
              decorationColor: widget.judulWarna,
            ),
            textAlign: widget.teksTengah ? TextAlign.center : TextAlign.left,
          )
        : null;

    final kotakJarakKonten = widget.jarakKontenUkuran != null 
      ? SizedBox(height: widget.jarakKontenUkuran, width: widget.jarakKontenUkuran)
      : null;

    final List<Widget> kolom = [
      if (gambarFinal.isNotEmpty)
        LayoutBuilder(builder: (context, c) {
          final maxWidth = widget.susunGambarTeksBaris == Axis.horizontal ? c.maxWidth * 0.5 : c.maxWidth;
          final maxHeight = widget.susunGambarTeksBaris == Axis.vertical ? c.maxHeight * 0.8 : c.maxHeight;

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: maxWidth,
            ),
            child: Align(
              alignment: widget.isiTengah ? Alignment.center : Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Stack(
                  children: [
                    ...gambarFinal
                  ],
                ),
              ),
            ),
          );
        }),
      if (gambarFinal.isEmpty && gambarWidgets != null) ...gambarWidgets,
      if (kotakJarakKonten != null) kotakJarakKonten,
      if (judulWidget != null)
        Expanded(
          child: Align(
            alignment: widget.isiTengah ? Alignment.center : Alignment.centerLeft,
            child: judulWidget,
          ),
        ),
      if (kotakJarakKonten != null) kotakJarakKonten,
      if (teksWidget != null)
        Expanded(
          child: Align(
            alignment: widget.isiTengah ? Alignment.center : Alignment.centerLeft,
            child: teksWidget
          )
        ),
    ];

    return widget.susunGambarTeksBaris == Axis.horizontal
        ? Row(
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: kolom,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: kolom,
          );
  }
}

/// ------------------------------
/// ANIMASI MASUK (padaMasukAnimasi1)
/// ------------------------------
void padaMasukAnimasi1(AnimationController controller) {
  controller.duration = const Duration(milliseconds: 800);
  controller.forward(from: 0.0);
}

/// ------------------------------
/// ANIMASI DRAG AWAL depracated
/// ------------------------------
void padaDragAwal1(AnimationController controller) {
  controller.duration = const Duration(milliseconds: 150);
  controller.forward(from: 0.0);
}

/// ------------------------------
/// ANIMASI DRAG AKHIR depracated
/// ------------------------------
void padaDragAkhir1(AnimationController controller) {
  controller.duration = const Duration(milliseconds: 180);
  controller.reverse();
}

/// ------------------------------
/// ANIMASI KLIK (padaKlikAnimasi1)
/// ------------------------------
void padaKlikAnimasi1(AnimationController controller) {
  controller.duration = const Duration(milliseconds: 100);
  controller.forward(from: 0.0).then((_) => controller.reverse());
}

/// ------------------------------
/// ANIMASI HOVER 1 (besar + rotasi)
/// ------------------------------
void padaHoverAnimasi1(AnimationController controller) {
  controller.duration = const Duration(milliseconds: 150);
  controller.forward();
}

/// ------------------------------
/// ANIMASI HOVER 2 (besar saja)
/// ------------------------------
void padaHoverAnimasi2(AnimationController controller) {
  controller.duration = const Duration(milliseconds: 150);
  controller.forward();
}

/// ------------------------------
/// ANIMASI PILIH (padaPilihAnimasi1)
/// ------------------------------
void padaPilihAnimasi1(AnimationController controller) {
  controller.duration = const Duration(milliseconds: 150);
  controller.forward();
}

/// ------------------------------
/// ANIMASI DRAG SHAKE
/// ------------------------------
Offset padaDragAnimasi1(double t) {
  return Offset(sin(t * 30) * 4, 0);
}