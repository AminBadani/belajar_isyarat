import 'package:belajar_isyarat/tampilan/card_statis.dart';
import 'package:belajar_isyarat/tampilan/header_footer.dart';
import 'package:belajar_isyarat/alat/alat_app.dart';
import 'package:belajar_isyarat/tampilan/menu_tentang_body.dart';
import 'package:belajar_isyarat/tampilan/percobaan.dart';
import 'package:belajar_isyarat/tampilan/soal_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../kontrol/kontrol_menu.dart';
import 'menu_utama_body.dart';
import 'menu_belajar_body.dart';
import 'menu_tes_body.dart';
import 'menu_kuis_body.dart';
import 'menu_progress_body.dart';

class MenuRoot extends StatefulWidget {
  const MenuRoot({super.key});

  @override
  State<MenuRoot> createState() => _MenuRootState();
}

class _MenuRootState extends State<MenuRoot> {
  // halaman yang harus lazy-load
  Widget? _belajarMenu;
  Widget? _belajarMateri;
  Widget? _tesMenu;
  Widget? _tesSoal;
  Widget? _kuisSoal;

  @override
  Widget build(BuildContext context) {
    final kontrolMenu = context.watch<KontrolMenu>();
    final alatApp = context.read<AlatApp>();

    // Lazy init
    switch (kontrolMenu.halaman) {
      case 1:
        _belajarMenu ??= const MenuBelajarMenuBody();
        break;
      case 2:  
        _belajarMateri ??= const MenuBelajarMateriBody();
        break;
      case 3:  
        _tesMenu ??= const MenuTesMenuBody();
        break;
      case 4:
        _tesSoal ??= const MenuTesSoalBody();
        break;
      case 6:
        _kuisSoal ??= const MenuKuisSoalBody();
        break;
    }

    return Scaffold(
      backgroundColor: alatApp.latarBelakang,
      appBar: const Header(),

      body: SafeArea(
  bottom: true,
  child: Padding(
        padding: EdgeInsets.all(20),
        child: IndexedStack(
          index: kontrolMenu.halaman,
          children: [
            const MenuUtamaBody(),        // 0 (static)
            _belajarMenu ?? SizedBox.shrink(),  // 1 (lazy)
            _belajarMateri ?? SizedBox.shrink(), // 2 (lazy)
            _tesMenu  ?? SizedBox.shrink(),      // 3 (lazy)
            _tesSoal ?? SizedBox.shrink(), // 4 (lazy)
            const MenuKuisMenuBody(),     // 5 (static)
            _kuisSoal ?? SizedBox.shrink(), // 6 (lazy)
            const MenuProgressBody(),     // 7 (static)
            const MenuTentangBody(),      // 8 (static)
            const Percobaan()
          ],
        ),
      ),),

      bottomNavigationBar: Builder(
        builder: (_) {
          switch (kontrolMenu.halaman) {
            case 2:
              return const FooterModel2(belajar: true);
            case 4:
              return const FooterModel2(belajar: false);
            case 6:
              return const FooterModel1();
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}