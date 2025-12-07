import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:flutter/material.dart';

class AlatApp {
  // warna utama
  //-teksTerangKuning
  //-teksHitam
  Color get kotakUtama => Color(0xFFf1b537);
  Color get kotakUtamaLain => Color(0xFFf89a1c);
  Color get kotakPutih => Color(0xFFf8f9fb);
  Color get kotakHitam => Color(0xFF333333);

  Color get latarBelakang => Color(0xFFf2f2f2);
  Color get latarBelakangPutih => Color(0xFFeaeefb);
  Color get latarBelakangUngu => Color(0xFFd6c5e8);

  Color get garisLuarHoverAbu => Color(0xFFcccccc);

  Color get warnaKembaliBiru => Color(0xFF9db8e7);
  Color get warnaKembaliUngu => Color(0xFFb3a2e8);

  Color get hiasanKotak => Color(0xFFf2f2f2);
  double get ukuranFooter => 60;

  // warna kotak
  Color get kotak1 => Color(0xFFF9D260);
  Color get outline1 => Color(0xFFFFF4C7);

  Color get kotak2 => Color(0xFFF5B73A);
  Color get outline2 => Color(0xFFFEEAB0);

  Color get kotak3 => Color(0xFFF6BE55);
  Color get outline3 => Color(0xFFFFF1BE);

  Color get kotak4 => Color(0xFFEFB748);
  Color get outline4 => Color(0xFFFBE8B2);

  Color get kotak5 => Color(0xFFE6A93F);
  Color get outline5 => Color(0xFFF8E3A8);

  Color get kotak6 => Color(0xFFF7C44B);
  Color get outline6 => Color(0xFFFFEFB0);

  // Warna header aplikasi
  Color get awalHeader => Color(0xFFffc94d);
  Color get tengahHeader => Color(0xFFffb732);
  Color get akhirHeader => Color(0xFFe39f22);

  Color get latarBelakangProgressAbu => Color(0xFFe5e5e5);

  // Warna biru
  Color get biruTerang => Color(0xFF55d4f5);
  Color get unguTerang => Color(0xFF8c6ff7);
  Color get biruGelap => Color(0xFF47b5d1);
  Color get unguGelap => Color(0xFF7844d1);

  // Warna teks
  Color get teksHitam => Color(0xFF333333);
  Color get teksPutihTerang => Color(0xFFfafafa);
  Color get teksPutihSedang => Color(0xFFf8f9fb);
  Color get teksTerangKuning => Color(0xFFfff9e5);
  Color get teksKuning => Color(0xFFf1b537);
  Color get teksProgressBelum => Color(0xFF6f6f6f);

  // Warna outline benar / salah
  Color get benar => Color(0xFF4caf50); // hijau
  Color get salah => Color(0xFFe53935); // merah
  Color get tidakAktif => Color.fromARGB(255, 66, 81, 129);

  // Gradien Lain
  LinearGradient get teksBiru => LinearGradient(
    colors: [
      biruGelap,
      unguGelap
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  LinearGradient get progress => LinearGradient(
    colors: [
      biruTerang,
      unguTerang
    ]
  );
  LinearGradient get terpilih => LinearGradient(
    colors: [
      biruTerang,
      unguTerang
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  LinearGradient get gradientKembali => LinearGradient(
    colors: [
      warnaKembaliBiru,
      warnaKembaliUngu
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradien Latar dan Header
  LinearGradient get gradientLatarBelakang => LinearGradient(
    colors: [
      latarBelakangPutih,
      latarBelakangUngu
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  LinearGradient get warnaHeader => LinearGradient(
    colors: [
      awalHeader,
      tengahHeader,
      akhirHeader
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  LinearGradient get warnaFooter => LinearGradient(
    colors: [
      akhirHeader,
      tengahHeader,
      awalHeader,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Font
  String get judul => "Fredoka";
  String get teks => "Mulish";
  String get namaAplikasi => "Quicksand";

  // ==== alat =====
  Widget bangunTeksGradien({
    required String teks, 
    required LinearGradient warna, 
    required String font, 
    FontWeight? beratFont, 
    required double ukuranFont  
  }) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return warna.createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        teks,
        style: TextStyle(
          fontSize: ukuranFont,
          fontWeight: beratFont,
          fontFamily: font,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget bangunProgressBar({
    required BuildContext context, 
    required double progress, 
    double? tinggi, 
    double? garisLuar
  }) {
    Widget bangunLapisan(double ukuran, Widget child) {
      return Container(
        padding: EdgeInsets.all(ukuran),
        decoration: BoxDecoration(
          color: latarBelakangProgressAbu,
          borderRadius: BorderRadius.circular(10 + ukuran),
        ),
        child: child
      );
    }

    return LayoutBuilder(builder: (context, c) {
      final width = c.maxWidth.isFinite ? c.maxWidth : 0.0;
      final height = tinggi ?? c.maxHeight;

      // Convert ke double progress 0.0 - 1.0
      final progressFinal = progress.clamp(0.0, 1.0);

      Widget widgetFinal = Stack(
        children: [
          // Background
          Container(
            height: tinggi ?? height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Progress fill
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: width * progressFinal,
            height: tinggi,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.red,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      );
      if (garisLuar != null) {
        widgetFinal = bangunLapisan(garisLuar, widgetFinal);
      }
      return widgetFinal;
    });
  }

  Widget bangunKetupat({
    required double ukuran,
    required Widget? isi,
    double segiEnam = 0,
    double tepiRadius = 0,

    // kotak inti
    Color? warnaKotak,
    LinearGradient? gradientKotak,

    double ukuranGarisLuar1 = 0, // Layer 3 → 2 → 1
    Color? warnaGarisLuar1,
    LinearGradient? gradienGarisLuar1,

    double ukuranGarisLuar2 = 0,
    Color? warnaGarisLuar2,
    LinearGradient? gradienGarisLuar2,

    double ukuranGarisLuar3 = 0,
    Color? warnaGarisLuar3,
    LinearGradient? gradienGarisLuar3,
  }) {
    Widget buildLayer({
      required double padding,
      required Color? color,
      required LinearGradient? gradient,
      required Widget child,
      BorderRadius? borderRadius
    }) {
      if (padding == 0) return child;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          borderRadius: borderRadius
        ),
        child: child,
      );
    }

    Widget shapeWrapper(Widget child) {
      return ClipPath(
        clipper: segiEnam > 0 ? HexagonClipper() : DiamondClipper(),
        child: child,
      );
    }

    Widget innerBox = shapeWrapper(
      AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: ukuran,
        height: ukuran,
        decoration: BoxDecoration(
          color: gradientKotak == null ? warnaKotak : null,
          gradient: gradientKotak,
          borderRadius: BorderRadius.circular(tepiRadius)
        ),
        alignment: Alignment.center,
        child: isi,
      ),
    );

    Widget layer3 = buildLayer(
      padding: ukuranGarisLuar3,
      color: warnaGarisLuar3,
      gradient: gradienGarisLuar3,
      child: innerBox,
      borderRadius: BorderRadius.circular(tepiRadius + ukuranGarisLuar3 / 2)
    );

    Widget layer2 = buildLayer(
      padding: ukuranGarisLuar2,
      color: warnaGarisLuar2,
      gradient: gradienGarisLuar2,
      child: layer3,
      borderRadius: BorderRadius.circular(tepiRadius + ukuranGarisLuar3 / 2 + ukuranGarisLuar2/2)
    );

    Widget layer1 = buildLayer(
      padding: ukuranGarisLuar1,
      color: warnaGarisLuar1,
      gradient: gradienGarisLuar1,
      child: layer2,
      borderRadius: BorderRadius.circular(tepiRadius + ukuranGarisLuar3 / 2 + ukuranGarisLuar2/2 + ukuranGarisLuar1/2)
    );

    return layer1;
  }

  Widget bangunProgressBarPoin({
    required BuildContext context,
    double? lebar,
    double? tinggi,

    required int nomorSekarang,

    List<String>? isi,
    required List<bool> isiSelesai,
    TextStyle? styleIsi,
    double? jarakIsi,

    bool benarSalah = false,

    required double tinggiProgressBar,
    required double ukuranGarisLuarProgressBar,

    Function(int index)? padaKlik,
  }) {
    final total = isiSelesai.length;

    return LayoutBuilder(
      builder: (context, c) {
        final maxWidth = lebar ?? c.maxWidth;
        final maxHeight = tinggi ?? c.maxHeight;
        final ukuranKetupat = maxHeight;

        // Padding global untuk border ketupat
        const double g1 = 1;
        const double g2 = 2;
        const double g3 = 1;
        final totalGaris = g1 + g2 + g3;

        // Hitung ruang
        final totalLebarKetupat = (ukuranKetupat + totalGaris) * total;
        final ruangTersisa = maxWidth - totalLebarKetupat;

        final spacing = jarakIsi ?? (ruangTersisa / (total - 1)).clamp(0, 9999);

        // Hitung posisi progress bar:
        // Lebar progress harus berhenti di tengah ketupat nomorSekarang
        double lebarProgress = 0;

        // progress = semua ketupat sebelum + setengah ketupat saat ini
        if (nomorSekarang <= 1) {
          lebarProgress = (ukuranKetupat + totalGaris) / 2;
        } else {
          lebarProgress =
              (ukuranKetupat + totalGaris) * (nomorSekarang - 1) +
              spacing * (nomorSekarang - 1) +
              (ukuranKetupat + totalGaris) / 2;
        }

        // Ketupat builder
        final listKetupat = List.generate(total, (i) {
          final isNow = (i == nomorSekarang - 1);
          final isDone = isiSelesai[i];

          final warnaText = benarSalah
              ? teksPutihSedang
              : (isDone ? teksPutihSedang : teksProgressBelum);

          final kotak = benarSalah
              ? (isDone ? benar : salah)
              : (isDone ? null : kotakPutih);

          final gradientKotak = benarSalah
              ? null
              : (isDone ? progress : null);

          // Border logika
          final garis1 = latarBelakangProgressAbu;
          final garis2 = isNow
              ? (benarSalah
                  ? (isDone ? benar : salah)
                  : null)
              : null; // warna border 2 jika kotak sekarang
          final gradien2 = isNow ? (!benarSalah ? progress : null) : null;

          return GestureDetector(
            onTap: () => padaKlik?.call(i),
            child: bangunKetupat(
              ukuran: ukuranKetupat,
              isi: Text(
                isi != null ? isi[i] : (i + 1).toString(),
                style: styleIsi?.copyWith(color: warnaText) ??
                    TextStyle(
                      color: warnaText,
                      fontFamily: judul,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              tepiRadius: 4,
              warnaKotak: kotak,
              gradientKotak: gradientKotak,
              ukuranGarisLuar3: g3,
              warnaGarisLuar3: kotakPutih,
              ukuranGarisLuar2: g2,
              warnaGarisLuar2: garis2,
              gradienGarisLuar2: gradien2,
              ukuranGarisLuar1: g1,
              warnaGarisLuar1: garis1,
            )
          );
        });

        final arranged = <Widget>[];
        for (int i = 0; i < total; i++) {
          arranged.add(listKetupat[i]);
          if (i < total - 1) arranged.add(SizedBox(width: spacing));
        }

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Progress Bar di belakang
            Positioned(
              left: 0,
              child: bangunProgressBar(
                context: context,
                progress: lebarProgress,
                tinggi: tinggiProgressBar,
                garisLuar: ukuranGarisLuarProgressBar,
              ),
            ),

            // Ketupat di depan
            Positioned.fill(
              child: IgnorePointer(
                child: Row(children: arranged),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final w = s.width;
    final h = s.height;
    return Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w / 2, h)
      ..lineTo(0, h / 2)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final w = s.width;
    final h = s.height;
    return Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.5)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}