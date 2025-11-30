import 'package:flutter/material.dart';

class GarisLuar extends StatelessWidget {
  final double besarGaris;
  final double jarakPemisah;
  final Color warnaGaris;
  final Color warnaPemisah;
  final Widget anak;

  final Widget? tanda;
  final double jarakPemisahTanda; // jarak putih khusus tanda

  const GarisLuar({
    super.key,
    required this.besarGaris,
    required this.jarakPemisah,
    required this.warnaGaris,
    required this.warnaPemisah,
    required this.anak,
    this.tanda,
    this.jarakPemisahTanda = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // --- OUTLINE + PEMISAH + ANAK ---
        Container(
          padding: EdgeInsets.all(besarGaris), // garis luar
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: warnaGaris,
              width: besarGaris,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(jarakPemisah), // pemisah
            decoration: BoxDecoration(
              color: warnaPemisah,
              borderRadius: BorderRadius.circular(20),
            ),
            child: anak,
          ),
        ),

        // --- TANDA OPSIONAL ---
        if (tanda != null)
          Positioned(
            top: -(jarakPemisahTanda + 20), // naik ke atas
            right: -(jarakPemisahTanda + 20), // geser ke samping
            child: Container(
              padding: EdgeInsets.all(jarakPemisahTanda),
              decoration: BoxDecoration(
                color: warnaPemisah,
                shape: BoxShape.circle,
              ),
              child: tanda,
            ),
          ),
      ],
    );
  }
}
