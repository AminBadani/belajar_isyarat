import 'dart:math';
import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/kontrol/kontrol_database.dart'; // untuk ambilGambar()

class CardStatis extends StatefulWidget {
  final double? lebar;
  final double? tinggi;
  final bool kotak;
  final double? padding;

  final String? teks;
  final String? judul;
  final double? teksUkuran;
  final double? judulUkuran;
  final String fontJudul;
  final String fontTeks;
  final bool garisBawahJudul;

  final List<String>? gambar;
  final List<Image>? gambarImage;
  final Widget? gambarWidget;
  final double? besarGambar;
  final double paddingGambar; // padding tiap gambar
  final double tepiRadiusGambar;
  final Color? warnaGambarColor;
  final LinearGradient? warnaGambarGradient;

  final Widget? pemisahGambar; // Bisa Image atau Icon
  final double besarPemisahGambar;
  final double jarakGambarPemisah;

  final double? jarakKontenUkuran;

  final Widget? teksWidget;
  final Color teksWarna;
  final LinearGradient? teksGradient;
  final Widget? judulWidget;
  final Color judulWarna;
  final LinearGradient? judulGradient;

  final double tepiRadius;
  final Axis susunGambarTeksBaris;

  final Color? kotakWarna;
  final LinearGradient? kotakGradient;
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

  final bool dipilih;
  final Function(AnimationController)? padaDipilihAnimasi;
  final Color? padaDipilihWarnaGarisLuar;
  final LinearGradient? padaDipilihGradientGarisLuar;
  final Color? padaDipilihWarnaPemisahGarisLuar;
  final LinearGradient? padaDipilihGradientPemisahGarisLuar;

  final bool tanpaProvider;

  const CardStatis({
    super.key,
    this.lebar,
    this.tinggi,
    this.kotak = false,
    this.padding,

    this.teks,
    this.judul,
    this.teksUkuran,
    this.judulUkuran,
    this.fontJudul = "Fredoka",
    this.fontTeks = "Mulish",
    this.garisBawahJudul = false,

    this.gambar,
    this.gambarImage,
    this.gambarWidget,
    this.besarGambar,
    this.paddingGambar = 0.0,
    this.tepiRadiusGambar = 0.0,
    this.warnaGambarColor,
    this.warnaGambarGradient,

    this.pemisahGambar,
    this.besarPemisahGambar = 0.0,
    this.jarakGambarPemisah = 0.0,

    this.jarakKontenUkuran,

    this.teksWidget,
    this.teksWarna = Colors.black,
    this.teksGradient,
    this.judulWidget,
    this.judulWarna = Colors.black,
    this.judulGradient,

    this.tepiRadius = 0.0,
    this.susunGambarTeksBaris = Axis.horizontal,

    this.kotakWarna,
    this.kotakGradient,
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

    this.dipilih = false,
    this.padaDipilihAnimasi,
    this.padaDipilihWarnaGarisLuar,
    this.padaDipilihGradientGarisLuar,
    this.padaDipilihWarnaPemisahGarisLuar,
    this.padaDipilihGradientPemisahGarisLuar,

    this.tanpaProvider = false,
  });

  @override
  State<CardStatis> createState() => _CardStatisState();
}

class _CardStatisState extends State<CardStatis> with TickerProviderStateMixin {
  late AnimationController _hoverSmooth;
  late Animation<double> _hoverValue;
  late AnimationController _hoverController;
  late AnimationController _klikController;
  late AnimationController _dipilihController;
  late AlatApp alat;

  bool _hover = false;
  //bool _drag = false;
  bool _klik = false;

  @override
  void initState() {
    super.initState();
    if (!widget.tanpaProvider) {
      alat = context.read<AlatApp>();
    }
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

    _dipilihController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _klikController.dispose();
    _dipilihController.dispose();
    _hoverSmooth.dispose();
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
      child: child,
    );
  }

  Widget _bangunContainerUtama(BuildContext context, Color? color, double blurRadius, double width, double height) {
    final KontrolDatabase? kontrolDatabase = widget.tanpaProvider ? null : context.read<KontrolDatabase>();
    final ukuranPadding = widget.padding ?? 0;
    final padding = ukuranPadding == 0 ? null : EdgeInsets.all(ukuranPadding);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(widget.tepiRadius),
        gradient: widget.kotakGradient
      ),
      child: _isiKonten(kontrolDatabase)
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
            final rawFinalScale = hoverScale * scaleKlik;

            // CLAMP agar tidak menjadi sangat kecil / sangat besar
            final finalScale = clampDouble(rawFinalScale, 0.85, 1.12);

            // gabungkan rotasi (hover + masuk)
            final finalRotate = hoverRotate;

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
              double lebar = (widget.lebar ?? c.maxWidth) - widget.pemisahGarisLuarUkuran - widget.garisLuarUkuran;
              double tinggi = (widget.tinggi ?? c.maxHeight) - widget.pemisahGarisLuarUkuran - widget.garisLuarUkuran;
              
              if (widget.kotak) {
                final terendah = min(lebar, tinggi);
                lebar = tinggi = terendah;
              }

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

  Widget _isiKonten(KontrolDatabase? kontrolDatabase) {
    List<Widget>? bangunGambarWidgets({double? besarGambar}) {
      List<dynamic>? gambar = widget.tanpaProvider 
        ? widget.gambarImage     // List<Image>
        : widget.gambar;         // List<String>

      return gambar?.map((e) => 
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: besarGambar,
          height: besarGambar,
          decoration: BoxDecoration(
            color:widget.warnaGambarColor,
            borderRadius: BorderRadius.circular(widget.tepiRadiusGambar),
            gradient: widget.warnaGambarGradient,
          ),
          padding: EdgeInsets.all(widget.paddingGambar),
          child: widget.tanpaProvider 
            ? (e is Image ? e : SizedBox()) 
            : kontrolDatabase!.ambilGambar(e as String),
        )
      ).toList();
    }

    List<Widget> bangunGambarFinal(List<Widget>? gambarWidgets) {
      List<Widget> gambarFinal = [];
      if (gambarWidgets != null && gambarWidgets.length > 1) {
        if (widget.pemisahGambar != null) {
          final gambarPemisah = Container(
            width: widget.besarPemisahGambar,
            height: widget.besarPemisahGambar,
            color: Colors.transparent,
            child: FittedBox(
              fit: BoxFit.contain,
              child: widget.pemisahGambar
            ),
          );
          for (var i = 0; i < gambarWidgets.length; i++) {
            gambarFinal.add(gambarWidgets[i]);
            if (i != gambarWidgets.length - 1) {
              gambarFinal.add(SizedBox(width: widget.jarakGambarPemisah));
              gambarFinal.add(gambarPemisah);
              gambarFinal.add(SizedBox(width: widget.jarakGambarPemisah));
            }
          }
        } else {
          gambarFinal = gambarWidgets;
        }
      } 
      return gambarFinal;
    }

    final teksWidget = widget.teksWidget
        ?? (widget.teks != null
        ? (widget.teksGradient != null && !widget.tanpaProvider
            ? alat.bangunTeksGradien(
                teks: widget.teks!, 
                warna: widget.teksGradient!, 
                font: widget.fontTeks, 
                ukuranFont: widget.teksUkuran ?? 17
              )
            : Text(
                widget.teks!,
                textAlign: widget.teksTengah ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  fontFamily: widget.fontTeks,
                  fontSize: widget.teksUkuran ?? 17, 
                  color: widget.teksWarna
                ),
              )
            )
        : null);

    final judulWidget = widget.judulWidget 
        ?? (widget.judul != null
        ? (widget.judulGradient != null && !widget.tanpaProvider
            ? alat.bangunTeksGradien(
                teks: widget.judul!, 
                warna: widget.judulGradient!, 
                font: widget.fontJudul, 
                ukuranFont: widget.judulUkuran ?? 32
              )
            : Text(
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
          )
        : null);

    final kotakJarakKonten = widget.jarakKontenUkuran != null 
      ? SizedBox(height: widget.jarakKontenUkuran, width: widget.jarakKontenUkuran)
      : null;
    
    /*final maxWidthIsi = widget.susunGambarTeksBaris == Axis.horizontal ? maxWidth * 0.5 : maxWidth;
    final maxHeightIsi = widget.susunGambarTeksBaris == Axis.vertical ? maxHeight * 0.8 : maxHeight;

    final jumlahGambar = widget.gambar!.length;
    final maxWidthGambar = (maxWidthIsi - (widget.besarPemisahGambar * (jumlahGambar - 1) + widget.jarakGambarPemisah * (2 * (jumlahGambar - 1)))) / jumlahGambar;
    final ukuranGambar = maxWidthGambar.clamp(0, maxHeightIsi).toDouble();*/
    int jumlahGambar = widget.tanpaProvider
    ? (widget.gambarImage?.length ?? 0)
    : (widget.gambar?.length ?? 0);
    final pakaiBanyakGambar = jumlahGambar > 1;
    final pakaiSatuGambar = jumlahGambar == 1;


    List<Widget> bangunIsi() {
      return [
        if (widget.gambarWidget != null)
          Expanded(
            flex: widget.susunGambarTeksBaris == Axis.vertical ? 3 : 1,
            child: widget.gambarWidget!
          )
        else if (pakaiBanyakGambar)
          Expanded(
            flex: widget.susunGambarTeksBaris == Axis.vertical ? 3 : 1,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: widget.isiTengah ? Alignment.center : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: widget.isiTengah ? MainAxisAlignment.center : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...bangunGambarFinal(bangunGambarWidgets()),
                ],
              ),
            ),
          )
        else if (pakaiSatuGambar)
          widget.susunGambarTeksBaris == Axis.vertical 
            ? Expanded(
              flex: 3,
              child: Align(
                alignment: widget.isiTengah ? Alignment.center : Alignment.centerLeft,
                child:bangunGambarWidgets()!.first,
              )
            )
            : bangunGambarWidgets()!.first,
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
    }

    return widget.susunGambarTeksBaris == Axis.horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: bangunIsi(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bangunIsi(),
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