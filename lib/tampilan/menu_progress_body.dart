import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/entitas/profil/e_log_detail.dart';
import 'package:belajar_isyarat/kontrol/kontrol_belajar.dart';
import 'package:belajar_isyarat/kontrol/kontrol_kuis.dart';
import 'package:belajar_isyarat/kontrol/kontrol_progress.dart';
import 'package:belajar_isyarat/kontrol/kontrol_tes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../kontrol/kontrol_log.dart';
import 'package:fl_chart/fl_chart.dart';

class MenuProgressBody extends StatefulWidget {
  const MenuProgressBody({super.key});

  @override
  State<MenuProgressBody> createState() => _MenuProgressBodyState();
}

class _MenuProgressBodyState extends State<MenuProgressBody> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _logScrollController = ScrollController();
  late KontrolProgress kProgress;
  late KontrolBelajar kBelajar;
  late KontrolTes kTes;
  late AlatApp alat;

  @override
  void initState() {
    super.initState();
    kProgress = context.read<KontrolProgress>();
    kBelajar = context.read<KontrolBelajar>();
    kTes = context.read<KontrolTes>();
    alat = context.read<AlatApp>();
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMateri1 = context.select<KontrolBelajar, int>(
      (k) => k.semuaMateriSelesai(1, kProgress)
    );
    final totalMateri2 = context.select<KontrolBelajar, int>(
      (k) => k.semuaMateriSelesai(2, kProgress)
    );
    final totalMateri3 = context.select<KontrolBelajar, int>(
      (k) => k.semuaMateriSelesai(3, kProgress)
    );
    final totalMateri = context.select<KontrolBelajar, int>(
      (k) => k.totalSemuaMateriSelesai(kProgress)
    );
    final totalTes = context.select<KontrolTes, List<int>>(
      (k) => k.semuaNilaiTes(kProgress)
    );
    final totalSkor = context.select<KontrolKuis, int>(
      (k) => k.skorKuis(kProgress)
    );

    int totalTesSelesai = 0;
    for (var isi in totalTes) {
      if (isi > 75) {
        totalTesSelesai++;
      }
    }

    return ScrollFade(
      controller: _scrollController,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ============================================================
              //                     BAGIAN STATISTIK
              // ============================================================
              Row(
                children: [
                  Expanded(child: _statCard(Icons.book, totalMateri, alat.teksProgresMateri(kProgress), total: kBelajar.totalSemuaMateri())),
                  const SizedBox(width: 10),
                  Expanded(child: _statCard(
                    Icons.check_circle, 
                    totalTesSelesai, 
                    alat.teksProgresTes(kProgress),
                    total: kTes.semuaNilaiTes(kProgress).length
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _statCard(Icons.star, totalSkor, alat.teksProgresSkor(kProgress))),
                ],
              ),

              const SizedBox(height: 20),

              // ============================================================
              //      BAGIAN CHART: TES (BAR) DAN KUIS (LINE)
              // ============================================================
              Row(
                children: [
                  Expanded(child: _chartBarTes()),
                  const SizedBox(width: 10),
                  Expanded(child: _chartLineKuis()),
                ],
              ),

              const SizedBox(height: 20),

              // ============================================================
              //                         LIST LOG
              // ============================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _logListFixed(360)),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        _ModuleCard("${alat.teksProgresModul(kProgress)} 1", totalMateri1 / kBelajar.totalMateri(1)),
                        SizedBox(height: 8),
                        _ModuleCard("${alat.teksProgresModul(kProgress)} 2", totalMateri2 / kBelajar.totalMateri(2)),
                        SizedBox(height: 8),
                        _ModuleCard("${alat.teksProgresModul(kProgress)} 3", totalMateri3 / kBelajar.totalMateri(3)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      )
    );
  }

  // ============================================================
  //                       STAT CARD
  // ============================================================
  Widget _statCard(IconData icon, int value, String label, {int? total}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10,),
          Icon(icon, size: 50, color: Colors.blue),
          Expanded(
           child: Column(
            children: [
              Text("${value.toString()}${total != null ? " / $total" : ""}",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    fontFamily: alat.judul,
                    color: alat.teksHitam,
                    shadows: alat.teksShadow
                    )
                  ),
              Text(label, textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: alat.teks,
                  color: alat.teksHitam,
                  shadows: alat.teksShadow
                ),
              ),
            ],
          ),)
        ]
      )
    );
  }

  // ============================================================
  //                         LOG LIST
  // ============================================================
  Widget _logListFixed(double height) {
    final kProgress = context.read<KontrolProgress>();
    final logs = context.select<KontrolLog, List<String>>(
      (k) => k.ambil50TerakhirBerformat(kProgress),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _chartDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alat.teksProgresLogAktivitas(kProgress),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: alat.judul, shadows: alat.teksShadow),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: height,
            child: logs.isEmpty
                ? Center(child: Text(alat.teksProgresBelumLog(kProgress)))
                : ScrollFade(
                    controller: _logScrollController,
                      child: Scrollbar(
                      controller: _logScrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _logScrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: logs.length,
                        separatorBuilder: (_, __) => const Divider(height: 8),
                        itemBuilder: (_, i) => Text(
                          logs[i],
                          style: TextStyle(fontSize: 13, fontFamily: alat.teks, shadows: alat.teksShadow),
                        ),
                      ),
                    ),
                )
          ),
        ],
      ),
    );
  }

  // ============================================================
  //                    CHART UTILITIES
  // ============================================================
  Widget _chartBarTes() {
    final totalTes = context.select<KontrolTes, List<int>>(
      (k) => k.semuaNilaiTes(kProgress)
    );

    if (totalTes.isEmpty) return _chartEmpty(alat.teksProgresBelumTes(kProgress));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          child: Text(
          "Statistik Skor Kuis",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            fontFamily: alat.judul,
            color: alat.teksHitam,
          ),
        ),
        ),
        const SizedBox(height: 8),
      Container(
      height: 260,
      padding: const EdgeInsets.all(12),
      decoration: _chartDeco(),
      child: BarChart(
        BarChartData(
          maxY: 100,
          barGroups: List.generate(totalTes.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(toY: totalTes[i].toDouble(), width: 16)],
            );
          }),
        ),
      ),
    )]);
  }

  Widget _chartLineKuis() {
    final logs = context.select<KontrolLog, List<ELogDetail>>(
      (k) => k.ambilListLogSync(),
    );

    final data = _hitungSkorHarian(logs);

    if (data.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              child:Text(
              "Statistik Nilai Tes",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                fontFamily: alat.judul,
                color: alat.teksHitam,
              ),
            ), 
          ),
          
          const SizedBox(height: 8),
          _chartEmpty(alat.teksProgresBelumKuis(kProgress))
        ]
      );
    }


    final spots = List.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i].value.toDouble()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
            child:Text(
            "Statistik Nilai Tes",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: alat.judul,
              color: alat.teksHitam,
            ),
          ), 
        ),
        
        const SizedBox(height: 8),
        Container(
          height: 260,
          padding: const EdgeInsets.all(12),
          decoration: _chartDeco(),
          child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: hitungMaxY(data),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    )
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= data.length) return const SizedBox();
                          return Text(
                            data[idx].label.split("-").sublist(1).join("-"), // MM-DD
                            style: const TextStyle(fontSize: 10, letterSpacing: 0),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
        )]);
  }

  List<ChartPoint> _hitungSkorHarian(List<ELogDetail> semua) {
    final Map<String, int> mapHari = {};

    for (var e in semua) {
      if (e.tipe != "kuis") continue;

      final tgl = "${e.waktu.year}-${e.waktu.month}-${e.waktu.day}";
      mapHari[tgl] = (mapHari[tgl] ?? 0) + (e.skor ?? 0);
    }

    final sortedKeys = mapHari.keys.toList()..sort();

    return sortedKeys.map((k) {
      return ChartPoint(k, mapHari[k] ?? 0);
    }).toList();
  }

  double hitungMaxY(List<ChartPoint> data, {double base = 500}) {
    if (data.isEmpty) return base;

    double maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();

    double limit = base;
    while (maxValue > limit) {
      limit *= 2; // setiap lewat batas → kali 2
    }

    return limit;
  }

  BoxDecoration _chartDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      );

  Widget _chartEmpty(String msg) => Container(
        height: 260,
        decoration: _chartDeco(),
        child: Center(child: Text(msg)),
      );
}

// ============================================================
//                 MODEL UNTUK LINE CHART
// ============================================================
class ChartPoint {
  final String label;
  final int value;
  ChartPoint(this.label, this.value);
}


// ============================================================
//                 CARD PROGRESS MODUL
// ============================================================
class _ModuleCard extends StatelessWidget {
  final String title;
  final double progress;

  const _ModuleCard(this.title, this.progress);

  @override
  Widget build(BuildContext context) {
    final alat = context.read<AlatApp>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: alat.teksHitam, fontSize: 24, fontFamily: alat.judul, shadows: alat.teksShadow)),
          const SizedBox(height: 8),
          alat.bangunProgressBar(context: context, progresss: progress, tinggi: 12, garisLuar: 3.5),
          const SizedBox(height: 6),
          Text("${(progress * 100).toStringAsFixed(0)}%", style: TextStyle(fontWeight: FontWeight.bold, color: alat.teksKuning, fontSize: 20, fontFamily: alat.judul, shadows: alat.teksShadow)),
        ],
      ),
    );
  }
}