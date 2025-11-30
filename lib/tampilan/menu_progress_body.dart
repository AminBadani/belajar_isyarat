import 'package:flutter/material.dart';
import '../kontrol/kontrol_progress.dart';
import 'package:provider/provider.dart';

class MenuProgressBody extends StatelessWidget {
  const MenuProgressBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC0C0C0),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              color: const Color(0xFFFFD54F),
              height: 40,
              child: const Center(
                child: Text('Progress Belajar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            // BODY
            Expanded(
              child: Center(
                child: Consumer<KontrolProgress>(
                  builder: (context, ctrl, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Skor: ${ctrl.progressKuis}', style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          ctrl.naikkanProgressKuis(10, true);
                        },
                        child: const Text('Tambah Skor'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
