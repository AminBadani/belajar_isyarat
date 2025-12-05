import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tampilan/pembukaan_aplikasi.dart';
import 'kontrol/inisialisasi_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<InisialisasiApp>(create: (_) => InisialisasiApp()),
      ],
      child: AplikasiIsyarat(),
    ),
  );
}

class AplikasiIsyarat extends StatelessWidget {
  const AplikasiIsyarat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PembukaanAplikasi(),
    );
  }
}
