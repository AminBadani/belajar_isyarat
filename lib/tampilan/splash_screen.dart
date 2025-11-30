import 'dart:async';

import 'package:belajar_isyarat/kontrol/inisialisasi_app.dart';
import 'package:belajar_isyarat/tampilan/menu_root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool pindah = false;
  bool initInisialiasi = false;

  @override
  void initState() {
    super.initState();

    // mulai init
    Future.microtask(_initApp);
  }

  Future<void> _initApp() async {
    print("Masuk splash");
    final init = context.read<InisialisasiApp>();
    await init.inis();

    if (init.langkah < init.total) return;
    if (pindah) return;
    pindah = true;

    print("Masuk splash PUSHHH");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            Provider.value(value: init.kontrolDatabase),
            Provider.value(value: init.kontrolProgress),
            Provider.value(value: init.alatApp),
            ChangeNotifierProvider.value(value: init.kontrolBelajar),
            ChangeNotifierProvider.value(value: init.kontrolMenu),
            ChangeNotifierProvider.value(value: init.kontrolTes),
            ChangeNotifierProvider.value(value: init.kontrolKuis),
          ],
        child: MenuRoot(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final init = context.watch<InisialisasiApp>();
    print("Masuk splash ##");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Belajar Isyarat",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // STATUS PROGRES
            Text(
              init.status,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "${init.langkah}/${init.total}",
              style: const TextStyle(fontSize: 14),
            ),

            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
