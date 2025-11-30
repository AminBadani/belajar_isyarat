import 'package:flutter/foundation.dart';

// -- page --
//menuUtama = 0

//menuBelajarMenu = 1
//menuBelajarMateri = 2

//menuTesMenu = 3
//menuTesSoal = 4

//menuKuisMenu = 5
//menuKuisSoal = 6

//menuProgress = 7
//menuTentang = 8
//menuPengaturan = 9
class KontrolMenu extends ChangeNotifier {
  int _halaman = 0;

  // getter
  int get halaman => _halaman;

  // alat
  void bukaMenu(int indeks) {
    _halaman = indeks;
    notifyListeners();
  }
}