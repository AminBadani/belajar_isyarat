import 'dart:ui';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class PowerPointPageSwitcher extends StatefulWidget {
  const PowerPointPageSwitcher({super.key});

  @override
  State<PowerPointPageSwitcher> createState() => _PowerPointPageSwitcherState();
}

class _PowerPointPageSwitcherState extends State<PowerPointPageSwitcher>
    with TickerProviderStateMixin {
  int currentPage = 0;

  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _bounce;

  bool forward = true; // true = maju (+), false = mundur (-)

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Slide global (masuk/keluar)
    _slide = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Bounce effect setelah masuk
    _bounce = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// -------------------------------------------------------
  ///     TRIGGER NEXT / PREV PAGE
  /// -------------------------------------------------------
  void nextPage() {
    forward = true;
    _controller.forward(from: 0);
    setState(() => currentPage = 1);
  }

  void prevPage() {
    forward = false;
    _controller.forward(from: 0);
    setState(() => currentPage = 0);
  }

  /// -------------------------------------------------------
  ///     WIDGET KOTAK DENGAN ANIMASI
  /// -------------------------------------------------------
  Widget _buildAnimatedBox(int i) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        // OFFSET UTAMA
        double dx = 0;
        double dy = 0;

        if (forward) {
          // MAJU (+)
          dx = lerpDouble(0, -200, _slide.value)!; // keluar kiri

          if (_slide.value > 0.5) {
            // masuk dari kanan → bounce kiri → balik
            dx = lerpDouble(
              300, // start offscreen right
              0,  // final position
              _bounce.value,
            )!;
          }
        } else {
          // MUNDUR (-)
          dy = lerpDouble(0, -200, _slide.value)!; // keluar atas

          if (_slide.value > 0.5) {
            dy = lerpDouble(
              300, // start from bottom
              0,   // final position
              _bounce.value,
            )!;
          }
        }

        return Transform.translate(
          offset: Offset(dx, dy),
          child: child,
        );
      },
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          "Box ${i + 1}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------------------
  ///     HALAMAN DENGAN 4 KOTAK
  /// -------------------------------------------------------
  Widget _buildPage() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(4, (i) => _buildAnimatedBox(i)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PowerPoint Style Animation")),
      body: Center(child: _buildPage()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: prevPage,
              child: const Text("◀ Mundur"),
            ),
            ElevatedButton(
              onPressed: nextPage,
              child: const Text("Maju ▶"),
            ),
          ],
        ),
      ),
    );
  }
}


class SlideGridAnimated extends StatefulWidget {
  final int page;
  final bool maju; // true = maju (+), false = mundur (-)
  final List<Widget> boxes; // 8 kotak
  final Duration duration;

  const SlideGridAnimated({
    super.key,
    required this.page,
    required this.maju,
    required this.boxes,
    this.duration = const Duration(milliseconds: 1200), // lebih lambat & mulus
  });

  @override
  State<SlideGridAnimated> createState() => _SlideGridAnimatedState();
}

class _SlideGridAnimatedState extends State<SlideGridAnimated>
    with SingleTickerProviderStateMixin {

  late AnimationController _c;
  late Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _c.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant SlideGridAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// Fungsi animasi posisi tiap kotak (stagger)
  Offset getOffset(int index, double t, bool masuk) {
    final double delay = index * 0.06; // semakin kecil = semakin rapi
    final double tt = (t - delay).clamp(0, 1);

    final eased = Curves.easeOutBack.transform(tt); // bounce lembut

    if (masuk) {
      return Offset(
        lerpDouble(300, 0, eased)!,     // masuk dari kanan
        0,
      );
    } else {
      return Offset(
        lerpDouble(0, -300, eased)!,    // keluar ke kiri
        0,
      );
    }
  }

  /// Mundur: keluar ke atas & masuk dari bawah (mirip PowerPoint)
  Offset getOffsetReverse(int index, double t, bool masuk) {
    final double delay = index * 0.07;
    final double tt = (t - delay).clamp(0, 1);

    final eased = Curves.easeOutBack.transform(tt);

    if (masuk) {
      return Offset(
        0,
        lerpDouble(300, 0, eased)!,   // masuk dari bawah
      );
    } else {
      return Offset(
        0,
        lerpDouble(0, -250, eased)!,  // keluar ke atas
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(widget.boxes.length, (i) {
            final masuk = _t.value >= 0.5;

            Offset offset = widget.maju
                ? getOffset(i, _t.value, masuk)
                : getOffsetReverse(i, _t.value, masuk);

            return Transform.translate(
              offset: offset,
              child: Opacity(
                opacity: (_t.value * 1.3).clamp(0, 1),
                child: widget.boxes[i],
              ),
            );
          }),
        );
      },
    );
  }
}
