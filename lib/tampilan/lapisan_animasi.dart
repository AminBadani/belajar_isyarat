import 'dart:math';
import 'package:flutter/material.dart';

class LapisanAnimasi extends StatefulWidget {
  final Widget anak;

  final int nomorHover;
  final int nomorKlik;
  final int masuk;
  final int animasiDipilih;
  final bool dipilih;

  const LapisanAnimasi({
    super.key,
    required this.anak,
    this.nomorHover = 0,
    this.nomorKlik = 0,
    this.masuk = 0,
    this.animasiDipilih = 0,
    this.dipilih = false,
  });

  @override
  State<LapisanAnimasi> createState() => _LapisanAnimasiState();
}

class _LapisanAnimasiState extends State<LapisanAnimasi>
    with SingleTickerProviderStateMixin {

  late AnimationController _dragController;

  @override
  void initState() {
    super.initState();

    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    if (widget.masuk != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --------------------------------------------------
    // NILAI AWAL NORMAL (identitas)
    // --------------------------------------------------
    double scaleMasuk = 1;
    double rotMasuk = 0;

    double scaleHover = 1;
    double rotHover = 0;
    Offset originHover = Offset.zero;

    double scaleKlik = 1;
    double rotKlik = 0;

    double scalePilih = 1;
    double rotPilih = 0;

    double rotDrag = 0;

    // --------------------------------------------------
    // ANIMASI MASUK
    // --------------------------------------------------
    if (widget.masuk != 0) {
      final t = 1.0; // selalu 1 karena masuk hanya dimainkan sekali

      switch (widget.masuk) {
        case 1:
          scaleMasuk = t;
          break;

        case 2:
          scaleMasuk = (t < 0.7)
              ? (t / 0.7) * 1.3
              : 1.3 - ((t - 0.7) / 0.3) * 0.3;
          break;

        case 3:
          rotMasuk = (t < 0.7)
              ? (t / 0.7) * (30 * pi / 180)
              : (30 - ((t - 0.7) / 0.3) * 60) * pi / 180;

          scaleMasuk = (t < 0.7)
              ? (t / 0.7) * 1.3
              : 1.3 - ((t - 0.7) / 0.3) * 0.3;
          break;

        case 4:
          rotMasuk = (-90 + t * 120) * pi / 180;
          scaleMasuk = (t < 0.7)
              ? (t / 0.7) * 1.3
              : 1.3 - ((t - 0.7) / 0.3) * 0.3;
          break;
      }
    }

    // --------------------------------------------------
    // ANIMASI DIPILIH
    // --------------------------------------------------
    if (widget.dipilih && widget.animasiDipilih != 0) {
      switch (widget.animasiDipilih) {
        case 1:
          scalePilih = 1.1;
          break;

        case 2:
          scalePilih = 1.2;
          break;
      }
    }

    // --------------------------------------------------
    // ANIMASI HOVER
    // --------------------------------------------------
    switch (widget.nomorHover) {
      case 1:
        scaleHover = 1.1;
        break;

      case 2:
        scaleHover = 1.1;
        rotHover = 10 * pi / 180;
        break;

      case 3:
        scaleHover = 1.1;
        rotHover = 10 * pi / 180;
        originHover = const Offset(-20, -20);
        break;
    }

    // --------------------------------------------------
    // ANIMASI KLIK
    // --------------------------------------------------
    if (widget.nomorKlik != 0) {
      scaleKlik = 0.9;
    }

    // --------------------------------------------------
    // GABUNGKAN SEMUA ANIMASI
    // --------------------------------------------------

    final double scaleFinal =
        scaleMasuk * scaleHover * scaleKlik * scalePilih;

    final double rotFinal =
        rotMasuk + rotHover + rotKlik + rotPilih + rotDrag;

    final Offset originFinal = originHover;

    // --------------------------------------------------
    // RETURN SINGLE TRANSFORM
    // --------------------------------------------------
    return Transform(
      alignment: Alignment.center,
      origin: originFinal,
      transform: Matrix4.identity()
        ..scale(scaleFinal)
        ..rotateZ(rotFinal),
      child: widget.anak,
    );
  }
}
