import 'package:flutter/material.dart';

class KotakUmum extends StatelessWidget {
  final double radiusBatas; // Border radius utama (kotak luar)
  final Color? warnaGarisLuarColor;
  final LinearGradient? warnaGarisLuarGradient;
  final double lebar;
  final double tinggi;

  final double padding; // Padding antara isi & kotak
  final double garisLuar; // Ketebalan outline luar

  final List<BoxShadow>? bayangan; // Bayangan outline luar

  final Color? warna; // Warna dalam
  final LinearGradient? warnaGradient;

  final Text? teks;

  final List<String>? gambar; // ← List gambar (kamu proses sendiri)
  final double besarGambar; // ukuran kotak gambar (selalu kotak)
  final double radiusBatasGambar;

  final Color? warnaGambarColor;
  final LinearGradient? warnaGambarGradient;

  final Widget? pemisahGambar; // Bisa Image atau Icon
  final int paddingGambar; // padding tiap gambar
  final double jarakGambarPemisah;

  final Axis susunTeksGambar; // row atau column

  final List<VoidCallback>? padaKlik;

  const KotakUmum({
    super.key,
    required this.radiusBatas,
    this.warnaGarisLuarColor,
    this.warnaGarisLuarGradient,
    required this.lebar,
    required this.tinggi,
    required this.padding,
    required this.garisLuar,
    this.bayangan,
    this.warna,
    this.warnaGradient,
    this.teks,
    this.gambar,
    this.besarGambar = 0,
    this.radiusBatasGambar = 0,
    this.warnaGambarColor,
    this.warnaGambarGradient,
    this.pemisahGambar,
    this.paddingGambar = 0,
    this.jarakGambarPemisah = 0,
    this.susunTeksGambar = Axis.horizontal,
    this.padaKlik,
  });

  @override
  Widget build(BuildContext context) {
    // --------------------------------------------------
    // Bagian: kotak gambar-gambar
    // --------------------------------------------------

    final gambarWidgets = <Widget>[];

    if (gambar != null && gambar!.isNotEmpty) {
      for (int i = 0; i < gambar!.length; i++) {
        gambarWidgets.add(
          Container(
            width: besarGambar,
            height: besarGambar,
            decoration: BoxDecoration(
              color: warnaGambarColor,
              gradient: warnaGambarGradient,
              borderRadius: BorderRadius.circular(radiusBatasGambar),
            ),
            // KOMENTAR: ambil gambar dari List<String> nantinya
            child: Center(
              child: Text(
                "Gambar ${i + 1}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        );

        // tambahkan pemisah
        if (i != gambar!.length - 1 && pemisahGambar != null) {
          gambarWidgets.add(SizedBox(width: jarakGambarPemisah, height: jarakGambarPemisah));
          gambarWidgets.add(pemisahGambar!);
        }
      }
    }

    // --------------------------------------------------
    // Bagian: Layout gambar + teks
    // Gambar max mengambil 50% ruang
    // --------------------------------------------------

    Widget isi = Flex(
      direction: susunTeksGambar,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (gambarWidgets.isNotEmpty)
          Flexible(
            flex: 5, // 50%
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: jarakGambarPemisah,
                runSpacing: jarakGambarPemisah,
                children: gambarWidgets,
              ),
            ),
          ),
        if (gambarWidgets.isNotEmpty && teks != null)
          SizedBox(
            width: susunTeksGambar == Axis.horizontal ? jarakGambarPemisah : 0,
            height: susunTeksGambar == Axis.vertical ? jarakGambarPemisah : 0,
          ),
        if (teks != null)
          Flexible(
            flex: 5,
            child: Center(child: teks),
          ),
      ],
    );

    // --------------------------------------------------
    // Bagian: Kotak lengkap
    // --------------------------------------------------

    return GestureDetector(
      onTap: () => padaKlik?.forEach((f) => f()),
      child: Container(
        width: lebar,
        height: tinggi,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusBatas),
          color: warnaGarisLuarColor,
          gradient: warnaGarisLuarGradient,
          boxShadow: bayangan,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radiusBatas - garisLuar),
            color: warna,
            gradient: warnaGradient,
          ),
          child: isi,
        ),
      )
    );
  }
}