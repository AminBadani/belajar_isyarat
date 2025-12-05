import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuTentangBody extends StatefulWidget {
  const MenuTentangBody({super.key});

  @override
  State<MenuTentangBody> createState() => _MenuTentangBodyState();
}

class _MenuTentangBodyState extends State<MenuTentangBody> {
  int nomorHalaman = 1;

  @override
  Widget build(BuildContext context) {
    final alatApp = context.read<AlatApp>();

    Widget bangunHalaman(nomorHalaman) {
      if (nomorHalaman == 2) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: alatApp.kotakPutih,
            borderRadius: BorderRadius.circular(10),
            border: BoxBorder.all(
              color: alatApp.kotakUtama,
              width: 5,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              alatApp.bangunTeksGradien(
                teks: "Tentang Aplikasi", 
                warna: alatApp.teksBiru, 
                font: alatApp.judul, 
                beratFont: FontWeight.bold, 
                ukuranFont: 32
              ),        
              SizedBox(height: 10),

              Text(
                "Aplikasi Belajar Isyarat ini dibuat untuk membantu pengguna mempelajari bahasa isyarat\n dengan cara yang interaktif dan menyenangkan.\n "
                "Dengan berbagai modul pembelajaran, kuis, dan fitur pelacakan progres, \npengguna dapat belajar sesuai kecepatan mereka sendiri.",
                style: TextStyle(
                  fontSize: 17,
                  color: alatApp.teksHitam,
                  fontFamily: alatApp.teks,
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              alatApp.bangunTeksGradien(
                teks: "Pengembang Aplikasi:", 
                warna: alatApp.teksBiru, 
                font: alatApp.judul, 
                beratFont: FontWeight.bold, 
                ukuranFont: 32),
              SizedBox(height: 10),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1. Satriya Justisia\n2. Vallentino\n3. Jona",
                    style: TextStyle(
                      fontSize: 17,
                      color: alatApp.teksHitam,
                      fontFamily: alatApp.teks,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "4. Nevan\n5. Ahmad\n6. Rio Devasya",
                    style: TextStyle(
                      fontSize: 17,
                      color: alatApp.teksHitam,
                      fontFamily: alatApp.teks,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.left,
                  )
                ]
              ),

              SizedBox(height: 20),
              alatApp.bangunTeksGradien(
                teks: "Versi Aplikasi: 1.0.0", 
                warna: alatApp.teksBiru, 
                font: alatApp.judul, 
                beratFont: FontWeight.bold, 
                ukuranFont: 32
              ),
            ],
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: alatApp.kotakPutih,
            borderRadius: BorderRadius.circular(10),
            border: BoxBorder.all(
              color: alatApp.kotakUtama,
              width: 5,
            ),
          ),
          child: Center(
            child: Text(
              "anda menang"
            )
          )
        );
      }
    }
    
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardStatis(
                  lebar: 90,
                  tinggi: 40,
                  tepiRadius: 5,
                  isiTengah: true,
                  judul: "Saran",
                  judulWarna: alatApp.teksTerangKuning,
                  judulUkuran: 17,
                  fontJudul: alatApp.judul,
                  kotakWarna: alatApp.kotakUtama,
                  pemisahGarisLuarUkuran: 5,
                  pemisahGarisLuarGradient: nomorHalaman == 1 ? alatApp.terpilih : null,
                  padaKlik: () {
                      nomorHalaman = 1;
                      setState(() {});
                  },
                  pakaiHover: true,
                  pakaiKlik: true,
                  padaHoverAnimasi: padaHoverAnimasi1,
                  padaKlikAnimasi: padaKlikAnimasi1,
                ),
                SizedBox(width: 10),
                CardStatis(
                  lebar: 90,
                  tinggi: 40,
                  tepiRadius: 5,
                  isiTengah: true,
                  judul: "Tentang",
                  judulWarna: alatApp.teksTerangKuning,
                  judulUkuran: 17,
                  fontJudul: alatApp.judul,
                  kotakWarna: alatApp.kotakUtama,
                  pemisahGarisLuarUkuran: 5,
                  pemisahGarisLuarGradient: nomorHalaman == 2 ? alatApp.terpilih : null,
                  padaKlik: () {
                      nomorHalaman = 2;
                      setState(() {});
                  },
                  pakaiHover: true,
                  pakaiKlik: true,
                  padaHoverAnimasi: padaHoverAnimasi1,
                  padaKlikAnimasi: padaKlikAnimasi1,
                ),
              ]
            ),
          ),
          Expanded(
            flex: 12,
            child: bangunHalaman(nomorHalaman)
          ),
        ]
      ),
    );
  }
}