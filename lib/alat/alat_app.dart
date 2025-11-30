import 'package:flutter/material.dart';

class AlatApp {
  // warna utama
  //-teksTerangKuning
  //-teksHitam
  Color get kotakUtama => Color(0xFFf89a1c);
  Color get kotakPutih => Color(0xFFf8f9fb);
  Color get latarBelakang => Color(0xFFf2f2f2);

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
  Color get teksKuning => Color(0xFFf89a1c);

  // Warna outline benar / salah
  Color get benar => Color(0xFF4caf50); // hijau
  Color get salah => Color(0xFFe53935); // merah

  // Gradien
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
  Widget bangunProgressBar(BuildContext context, double progress, double tinggi) {
    return LayoutBuilder(builder: (context, c) {
      final width = c.maxWidth;

      // Convert ke double progress 0.0 - 1.0
      final progressFinal = progress.clamp(0.0, 1.0);

      return Stack(
        children: [
          // Background
          Container(
            height: tinggi,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Progress fill
          Container(
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
    });
  }
}