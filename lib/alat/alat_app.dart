import 'dart:math';

import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/lingkaran.dart';
import 'package:flutter/material.dart';

class AlatApp {
  // warna utama
  //-teksTerangKuning
  //-teksHitam
  Color get kotakUtama => const Color(0xFFf1b537);
  Color get kotakUtamaLain => const Color(0xFFf89a1c);
  Color get kotakPutih => const Color(0xFFf8f9fb);
  Color get kotakHitam => const Color(0xFF333333);

  Color get latarBelakang => const Color(0xFFf2f2f2);
  Color get latarBelakangPutih => const Color(0xFFeaeefb);
  Color get latarBelakangUngu => const Color(0xFFd6c5e8);

  Color get garisLuarHoverAbu => const Color(0xFFcccccc);

  Color get warnaKembaliBiru => const Color(0xFF9db8e7);
  Color get warnaKembaliUngu => const Color(0xFFb3a2e8);

  Color get hiasanKotak => const Color(0xFFf2f2f2);
  double get ukuranFooter => 75;

  // warna kotak
  Color get kotak1 => const Color(0xFFF9D260);
  Color get outline1 => const Color(0xFFFFF4C7);

  Color get kotak2 => const Color(0xFFF5B73A);
  Color get outline2 => const Color(0xFFFEEAB0);

  Color get kotak3 => const Color(0xFFF6BE55);
  Color get outline3 => const Color(0xFFFFF1BE);

  Color get kotak4 => const Color(0xFFEFB748);
  Color get outline4 => const Color(0xFFFBE8B2);

  Color get kotak5 => const Color(0xFFE6A93F);
  Color get outline5 => const Color(0xFFF8E3A8);

  Color get kotak6 => const Color(0xFFF7C44B);
  Color get outline6 => const Color(0xFFFFEFB0);

  // Warna header aplikasi
  Color get awalHeader => const Color(0xFFffc94d);
  Color get tengahHeader => const Color(0xFFffb732);
  Color get akhirHeader => const Color(0xFFe39f22);

  Color get latarBelakangProgressAbu => const Color(0xFFe5e5e5);

  // Warna biru
  Color get biruTerang => const Color(0xFF55d4f5);
  Color get unguTerang => const Color(0xFF8c6ff7);
  Color get biruGelap => const Color(0xFF47b5d1);
  Color get unguGelap => const Color(0xFF7844d1);

  // Warna teks
  Color get teksHitam => const Color(0xFF333333);
  Color get teksPutihTerang => const Color(0xFFfafafa);
  Color get teksPutihSedang => const Color(0xFFf8f9fb);
  Color get teksTerangKuning => const Color(0xFFfff9e5);
  Color get teksKuning => const Color(0xFFf1b537);
  Color get teksProgressBelum => const Color(0xFF6f6f6f);

  // Warna outline benar / salah
  Color get benar => const Color(0xFF4caf50); // hijau
  Color get salah => const Color(0xFFe53935); // merah
  Color get tidakAktif => const Color.fromARGB(255, 202, 214, 255);
  Color get netral => const Color(0xFF1E88E5);

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

  // list warna kotak
  List<Color> get warnaWarnaKotak => [
    kotak1,
    kotak3,
    kotak4,
    kotak3,
    kotak1
  ];

  List<Color> get warnaWarnaOutline => [
    outline1,
    outline2,
    outline3,
    outline4,
    outline5
  ];

  // Font
  final String judul = "Fredoka";
  final String teks = "Mulish";
  final String namaAplikasi = "Quicksand";

  // teks
  String teksAplikasi(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Sign Language" : "Belajar Isyarat";
  String teksHeaderBelajar(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Learn" : "Belajar";
  String teksHeaderKuis(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Quizez" : "Kuis";
  String teksHeaderProgres(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Progress" : "Progres";
  String teksHeaderPengaturan(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Setting" : "Pengaturan";

  String teksFooterKeluar(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Exit" : "Keluar";
  String teksFooterSelanjutnya(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Next" : "Selanjutnya";
  String teksFooterSebelumnya(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Before" : "Sebelumnya";
  String teksFooterKumpul(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Submit Test" : "Kumpul Tes";
  String teksFooterJawab(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Answer" : "Jawab";
  String teksFooterSkor(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Your Score" : "Skor Anda";

  String teksUtamaProgress(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Your Quiz Progress" : "Progress Kuis Anda";
  String teksUtamaNama(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Name" : "Nama";
  String teksUtamaSekolah(KontrolProgress kProgress) => kProgress.bahasaInggris ? "School" : "Sekolah";
  String teksUtamaJabatan(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Position" : "Jabatan";
  String teksUtamaProgressBar(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Your Total Learning Progress" : "Total Progres Belajar Anda";
  
  String teksBelajarProgress(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Your Progress in This Module" : "Progress Anda Pada Modul Ini";
  String teksBelajarTes(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Material Test" : "Tes Materi";
  
  String teksKuisJudul(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Quizez Menu" : "Menu Kuis";
  String teksKuisPenjelasan(KontrolProgress kProgress) => kProgress.bahasaInggris 
    ? "This quiz is optional and will not affect your learning progress,\n"
      "but it will increase your quiz score. It's highly recommended to test your skills!"
    : "Kuis ini opsional dan tidak akan mempengaruhi progress belajar anda,\n "
      "tetapi akan menambah skor kuis anda. Sangat disarankan untuk menguji kemampuan!";

  String teksTesJudul(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Test Menu" : "Menu Tes";
  String teksTesPenjelasan(KontrolProgress kProgress) => kProgress.bahasaInggris 
    ? "The test is the final step in completing the material progress.\n"
      "Your abilities will be tested here; you can take the test multiple times." 
    : "Tes adalah langkah terakhir untuk menyelesaikan progress materi.\n"
      "Kemampuan anda akan diuji disini, anda dapat mengerjakan tes berulang-kali";
  String teksTesNilai(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Your Test Scores" : "Nilai Tes Anda";

  String teksTesSelesaiJudul(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Test Score Menu" : "Menu Nilai Tes";
  String teksTesSelesaiPenjelas1(KontrolProgress kProgress) => kProgress.bahasaInggris 
    ? "Thanks for trying! It's okay, this is a great opportunity to learn again. Let's try again, you can definitely do better!" 
    : "Terima kasih sudah berusaha! Tidak apa-apa, ini kesempatan bagus untuk belajar lagi. Ayo coba sekali lagi, kamu pasti bisa semakin hebat!";

  String teksTesSelesaiPenjelas2(KontrolProgress kProgress) => kProgress.bahasaInggris 
    ? "Good! You almost did it! Just a little bit more and you'll reach your goal." 
    : "Bagus! Kamu sudah hampir berhasil! Sedikit lagi kamu pasti bisa mencapai target.";
  
  String teksTesSelesaiPenjelas3(KontrolProgress kProgress) => kProgress.bahasaInggris 
    ? "Great! You surpassed your goal! Keep it up, you're getting better!"
    : "Hebat! Kamu berhasil melewati target! Pertahankan, kamu makin pintar!";
  
  String teksTesSelesaiPenjelas4(KontrolProgress kProgress) => kProgress.bahasaInggris 
    ? "Amazing! You did a great job! Keep up the good work!"
    : "Luar biasa! Kamu mengerjakannya dengan sangat baik! Teruskan prestasimu!";
  String teksTesSelesaiJawabanBenar(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Total Correct Answer to Questions" : "Jawaban Benar Pada Soal";

  String teksTombolMulai(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Start" : "Mulai";
  String teksTombolUlang(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Restart" : "Ulang";

  String teksProgresMateri(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Material Studied" : "Materi Dipelajari";
  String teksProgresTes(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Test Completed/Passed" : "Tes Selesai/Lulus";
  String teksProgresSkor(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Total Quizez Score" : "Total Skor Kuis";
  String teksProgresLogAktivitas(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Activity Log" : "Log Aktivitas";
  String teksProgresModul(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Module" : "Modul";
  String teksProgresBelumLog(KontrolProgress kProgress) => kProgress.bahasaInggris ? "There is no activity yet" : "Belum ada aktivitas";
  String teksProgresBelumKuis(KontrolProgress kProgress) => kProgress.bahasaInggris ? "There is no Quizez data yet" : "Belum ada data Kuis";
  String teksProgresBelumTes(KontrolProgress kProgress) => kProgress.bahasaInggris ? "There is no test data yet" : "Belum ada data Tes";

  String teksTentangJudul1(KontrolProgress kProgress) => kProgress.bahasaInggris ? "About Application" : "Tentang Aplikasi";
  String teksTentangJudul2(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Application Developer" : "Pengembang Aplikasi";
  String teksTentangJudul3(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Application Version" : "Versi Aplikasi";
  String teksTentangTombol1(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Suggestion" : "Saran";
  String teksTentangTombol2(KontrolProgress kProgress) => kProgress.bahasaInggris ? "About" : "Tentang";
  String teksTentangAplikasi(KontrolProgress kProgress) => kProgress.bahasaInggris 
    ? "This Sign Language Learning app was created to help users learn sign language in an interactive and fun way.\n "
      "With various learning modules, quizzes, and progress tracking features, users can learn at their own pace." 
    : "Aplikasi Belajar Isyarat ini dibuat untuk membantu pengguna mempelajari bahasa isyarat\n dengan cara yang interaktif dan menyenangkan.\n "
      "Dengan berbagai modul pembelajaran, kuis, dan fitur pelacakan progres, \npengguna dapat belajar sesuai kecepatan mereka sendiri.";

  String teksAturanProfil(KontrolProgress kProgress) => kProgress.bahasaInggris ? "User Profile" : "Profil Pengguna";
  String teksAturanSimpanAnonim(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Save As Anonymous" : "Simpan Sebagai Anonim";
  String teksAturanSimpan(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Save Profile" : "Simpan Profil";
  String teksAturanOpsional(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Optional" : "Opsional";
  String teksAturanReset(KontrolProgress kProgress) => kProgress.bahasaInggris ? "Delete all learn, test, quizez progress for english language" : "Hapus semua kemajuan belajar, tes, dan kuis untuk bahasa indonesia";

  String teksSaranBelajar(KontrolProgress kProgress) => kProgress.bahasaInggris
    ? "Your learning of the material is not yet complete. It is recommended that you complete the learning before taking the test or quiz!"
    : "Pembelajaran materi anda masih belum selesai sepenuhnya. Direkomendasikan menyelesaikan pembelajaran sebelum melakukan tes ataupun kuis!";

  String teksSaranTes(KontrolProgress kProgress) => kProgress.bahasaInggris
    ? "You have completed the Lesson! but your Material Test is still incomplete. It is recommended that you complete the test before taking the quiz!"
    : "Anda telah menyelesaikan Pembelajaran! tetapi Tes Materi anda masih belum selesai sepenuhnya. Direkomendasikan menyelesaikan tes sebelum melakukan kuis!";

  String teksSaranKuis(KontrolProgress kProgress) => kProgress.bahasaInggris
    ? "You have completed the Learning and Material Test, you have passed, and that's great! Answering the Quiz is highly recommended to hone your skills, good luck!"
    : "Anda telah menyelesaikan Pembelajaran dan Tes Materi, anda telah lulus dan itu sangat bagus!. Menjawab Kuis sangat direkomendasikan untuk mengasah kemampuan ada, semoga sukses!";

  String teksSaranBelajarJudul(KontrolProgress kProgress) => kProgress.bahasaInggris
    ? "Learning Is Not Finished!"
    : "Belajar Belum Tuntas!";

  String teksSaranTesJudul(KontrolProgress kProgress) => kProgress.bahasaInggris
    ? "Perfect Your Test!"
    : "Sempurnakan Tes Anda!";

  String teksSaranKuisJudul(KontrolProgress kProgress) => kProgress.bahasaInggris
    ? "Sharpen Your Skills!"
    : "Asah Kemampuan!";

  List<Pelajaran> itemBelajar(KontrolProgress kProgress) => [
    Pelajaran(kProgress.bahasaInggris ? "Numbers" : "Angka", "numbers"),
    Pelajaran(kProgress.bahasaInggris ? "Letters" : "Huruf", "abc-block"),
    Pelajaran(kProgress.bahasaInggris ? "Words" : "Kata", "word-blocks"),
  ];

  List<BoxShadow> get boxShadowHover => [
      // 1) Intense & small — tajam, dekat (foreground shadow)
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1), // intensitas tinggi
        offset: const Offset(6, 6),             // kanan-bawah kecil
        blurRadius: 6,                          // blur kecil = tajam
        spreadRadius: 1,                        // sedikit melebar
      ),

      // 2) Low intensity & large — lembut, menyebar (ambient shadow)
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04), // intensitas rendah
        offset: const Offset(14, 14),          // kanan-bawah lebih jauh
        blurRadius: 28,                        // blur besar = lembut
        spreadRadius: 0,                       // atau sedikit negatif jika mau
      ),
    ];

  List<BoxShadow> get boxShadow => [
      // 1) Intense & small — tajam, dekat (foreground shadow)
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1), // intensitas tinggi
        offset: const Offset(1.5, 1.5),             // kanan-bawah kecil
        blurRadius: 3,                          // blur kecil = tajam
        spreadRadius: 0.5,                        // sedikit melebar
      ),

      // 2) Low intensity & large — lembut, menyebar (ambient shadow)
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04), // intensitas rendah
        offset: const Offset(5.5, 5.5),          // kanan-bawah lebih jauh
        blurRadius: 7,                        // blur besar = lembut
        spreadRadius: 0,                       // atau sedikit negatif jika mau
      ),
    ];
  
  BoxShadow get pendukungBoxShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.1), // intensitas tinggi
    offset: const Offset(1.5, 1.5),             // kanan-bawah kecil
    blurRadius: 4,                          // blur kecil = tajam
    spreadRadius: 0.5,                        // sedikit melebar
  );
  
  List<Shadow> get judulShadow => [
      // Bayangan tajam, kecil, intensitas tinggi
      Shadow(
        color: Colors.black.withValues(alpha: 0.15),
        offset: const Offset(2, 2),
        blurRadius: 4,
      ),
      // Bayangan lembut, besar, intensitas rendah
      Shadow(
        color: Colors.black.withValues(alpha: 0.04),
        offset: const Offset(5.5, 5.5),
        blurRadius: 7,
      ),
    ];
  
  List<Shadow> get teksShadow => [
    // Bayangan kecil & tajam
    Shadow(
      color: Colors.black.withValues(alpha: 0.10),
      offset: const Offset(1, 1),
      blurRadius: 2,
    ),

    // Bayangan lebih lembut & sangat halus
    Shadow(
      color: Colors.black.withValues(alpha: 0.03),
      offset: const Offset(2.2, 2.2),
      blurRadius: 3.5,
    ),
  ];

  List<BoxShadow> get boxLightOut => [
      // 1) Intense & small — tajam, dekat (foreground shadow)
      BoxShadow(
        color: kotakPutih,             // kanan-bawah kecil
        blurRadius: 10,                          // blur kecil = tajam
        spreadRadius: 10,                     // sedikit melebar
      ),

      // 2) Low intensity & large — lembut, menyebar (ambient shadow)
      BoxShadow(
        color: kotakPutih.withValues(alpha: 0.8),         // kanan-bawah lebih jauh
        blurRadius: 14,                        // blur besar = lembut
        spreadRadius: 25,                     // atau sedikit negatif jika mau
      ),
    ];

  List<BoxShadow> get boxLightTepiKiriAtas => [
            BoxShadow(
              color: kotakPutih,
              blurRadius: 14,
              spreadRadius: 2,
              offset: Offset(1.2, 1.2)
            ),
            BoxShadow(
              color: kotakPutih.withValues(alpha: 0.96),
              blurRadius: 5,
              spreadRadius: 7,
              offset: Offset(1.2, 1.2)
            ),
            BoxShadow(
              color: kotakPutih,
              blurRadius: 1,
              spreadRadius: 3,
              offset: Offset(3, 3)
            ),
          ];
  // ==== alat =====
  Widget bangunTombolKembali(VoidCallback fungsi) {
    return  CardStatis(
      lebar: 40,
      tinggi: null,
      isiTengah: true,
      padding: 4,
      tepiRadius: 25,
      kotakGradient: gradientKembali,
      pemisahGarisLuarUkuran: 4,
      judul: "<",
      judulWarna: teksPutihSedang,
      fontJudul: judul,
      pakaiKlik: true,
      pakaiHover: true,
      padaHoverAnimasi: padaHoverAnimasi1,
      padaHoverPemisahGarisLuarWarna: garisLuarHoverAbu,
      padaKlikAnimasi: padaKlikAnimasi1,
      padaKlik: fungsi,
      bayanganKotak: boxShadow,
      padaHoverBayanganPemisahGarisLuar: boxShadowHover,
    );
  }
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
    required double progresss,
    double? tinggi,
    double? garisLuar,
  }) {
    // warna dan shadow bisa disesuaikan

    return LayoutBuilder(builder: (context, c) {
      final width = c.maxWidth.isFinite ? c.maxWidth : 0.0;
      final height = tinggi ?? c.maxHeight;
      final progressFinal = progresss.clamp(0.0, 1.0);

      // --- 1) Lapisan terluar gelap (membentuk tepi cekung) ---
      Widget base =  ClipRRect(
    borderRadius: BorderRadius.circular(15),   // radius sama!
    child: Container(
        padding: EdgeInsets.all(garisLuar ?? 4),
        decoration: BoxDecoration(
          color: Colors.black, // TEPI DALAM GELAP
          borderRadius: BorderRadius.circular(15),
        ),

        // --- 2) Lapisan dalam terang dengan SHADOW putih keluar ---
        child: Container(
          decoration: BoxDecoration(
            color: latarBelakangProgressAbu,
            borderRadius: BorderRadius.circular(13),

            // Shadow putih keluar → tampak seperti inner shadow
            boxShadow: [
              BoxShadow(
                color: latarBelakangProgressAbu,
                blurRadius: 14,
                spreadRadius: 2,
                offset: Offset(1.2, 1.2)
              ),
              BoxShadow(
                color: latarBelakangProgressAbu.withValues(alpha: 0.96),
                blurRadius: 5,
                spreadRadius: 7,
                offset: Offset(1.2, 1.2)
              ),
              BoxShadow(
                color: latarBelakangProgressAbu,
                blurRadius: 1,
                spreadRadius: 3,
                offset: Offset(3, 3)
              ),
            ],
          ),

          // --- 3) ISI STACK PROGRESS BAR ---
          child: Stack(
            children: [
              // Background track
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: width * progressFinal,
                height: height,
                decoration: BoxDecoration(
                  gradient: progress,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 1,
                      spreadRadius: 0.2,
                      offset: Offset(2.5, 2)
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 7,
                      spreadRadius: 0,
                      offset: Offset(2.5, 2)
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      )
      );

      return base;
    });
  }

  Widget bangunMenuAtasSoal(List<String> gambarSoal, String penjelas, bool selesai, bool jawabanBenar) {
    final bukanGambar = gambarSoal.isNotEmpty ? gambarSoal.every((g) => g.startsWith("an") || g.startsWith("hu")) : false;
    final layout = gambarSoal.length > 1 ? Axis.vertical : Axis.horizontal;
    final soalBenar = selesai && jawabanBenar;
    final tanda = selesai ? Lingkaran(
      besar: 40, 
      besarGarisLuar: 7, 
      warnaGarisLuar: kotakPutih, 
      benarSalahNetral: soalBenar ? 1 : 2, 
      warnaLingkaran: soalBenar ? benar : salah, 
      warnaSimbolAngka: teksPutihSedang,
    ):null;

    return Expanded(
      flex: gambarSoal.length > 1 ? 8 : 3,
      child: CardStatis(
        padding: 10,
        tepiRadius: 30,
        isiTengah: true,
        kotakGradient: warnaHeader,
        gambar: bukanGambar ? null : gambarSoal,
        gambarWidget: bukanGambar ? LayoutBuilder(builder: (context, c) {
          final maxWidth = c.maxWidth;
          final maxHeight = c.maxHeight;
          final size = min(maxHeight, maxWidth);

          if (gambarSoal.length > 1) {
            return Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(
                  gambarSoal.length,
                  (i) {
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: kotakPutih,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: boxShadow,
                      ),
                      child: FittedBox(
                        child: bangunTeksGradien(
                          teks: gambarSoal[i].split("_").last, 
                          warna: terpilih, font: judul, ukuranFont: 10
                        )
                      )
                    );
                  }
                )
              )
            );
          }

          return CardStatis(
            kotak: true,
            tepiRadius: 10,
            kotakWarna: kotakPutih,
            gambarWidget: Expanded(
              child: FittedBox(
                child: bangunTeksGradien(
                  teks: gambarSoal[0].split("_").last, 
                  warna: terpilih, font: judul, ukuranFont: 10
                )
              ),
            ),
            bayanganKotak: boxShadow
          );
        }): null,
        paddingGambar: 10,
        tepiRadiusGambar: gambarSoal.length > 1 ? 90 : 10,
        warnaGambarColor: kotakPutih,
        jarakGambarPemisah: 10,
        pemisahGambar: Icon(
          Icons.double_arrow_rounded,
          color: teksHitam,
        ),
        besarPemisahGambar: 250,
        judul: penjelas,
        fontJudul: judul,
        judulUkuran: 27,
        judulWarna: teksPutihSedang,
        susunGambarTeksBaris: layout,
        bayanganKotak: boxShadow,
        bayanganJudul: judulShadow,

        tanda: tanda,
        pemisahGarisLuarUkuran: selesai ? 3 : 0,
        pemisahGarisLuarWarna: selesai ? kotakPutih : null,
        garisLuarUkuran: selesai ? 5 : 0,
        garisLuarWarna: selesai ? (soalBenar ? benar : salah) : null,
      ),
    );
  }

  Widget bangunAnimasi({required Widget child, required ValueKey key}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,      // masuk → lambat di akhir
      switchOutCurve: Curves.easeInOut,   // keluar → smooth awal-akhir
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, anim) {
        final opacityAnim = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(anim);


        return FadeTransition(
          opacity: opacityAnim,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: key,
        child: child
      )
    );
  }
}

class Pelajaran {
  final String name;
  final String iconPath;

  Pelajaran(this.name, this.iconPath);
}

class ScrollFade extends StatefulWidget {
  final Widget child;
  final double fadeSize;
  final ScrollController controller;

  const ScrollFade({
    super.key,
    required this.child,
    this.fadeSize = 32.0,
    required this.controller, // aktifkan fade berdasarkan scroll
  });

  @override
  State<ScrollFade> createState() => _ScrollFadeState();
}

class _ScrollFadeState extends State<ScrollFade> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);

    // initial value will be computed after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  void _onScroll() {
    final max = widget.controller.position.maxScrollExtent;
    final offset = widget.controller.offset;

    setState(() {
      showTop = offset > 0;
      showBottom = offset < max;
    });
  }

  bool showTop = false;
  bool showBottom = false;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {

        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent, // fade top
            Colors.white,
            Colors.white,
            Colors.transparent, // fade bottom
          ],
          stops: [
            0.0,
            showTop ? widget.fadeSize / rect.height : 0.0,          // top fade ends
            showBottom ?  1 - (widget.fadeSize / rect.height) : 1.0,    // bottom fade starts
            1.0,
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: widget.child,
    );
  }
}