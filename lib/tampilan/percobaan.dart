import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/reorder_demo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Percobaan extends StatefulWidget {
  const Percobaan({super.key});

  @override
  State<Percobaan> createState() => _PercobaanState();
}

class _PercobaanState extends State<Percobaan> {
  @override
  Widget build(BuildContext context) {
    final alat = context.read<AlatApp>();
    return PowerPointPageSwitcher();
  }
}

/*CardStatis(
      padding: 20,
        kotakWarna: alat.kotakUtama,
        gambar: ["a", "b_"],
        pemisahGambar: Icon(Icons.arrow_back, size: 40, color: alat.teksHitam,),
        besarPemisahGambar: 150,
        judul: "jis",
        susunGambarTeksBaris: Axis.vertical,
    );*/