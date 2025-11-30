import 'package:flutter/material.dart';

class OverlayService {
  static OverlayEntry? _currentEntry;

  static void show(OverlayEntry entry, BuildContext context) {
    close(); // tutup overlay sebelumnya jika ada
    _currentEntry = entry;
    Overlay.of(context).insert(entry);
  }

  static void close() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class HoverScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const HoverScale({required this.child, required this.onTap, super.key});

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => scale = 1.1),
      onExit: (_) => setState(() => scale = 1.0),
      child: GestureDetector(
        onTapDown: (_) => setState(() => scale = 0.9),
        onTapUp: (_) => setState(() => scale = 1.0),
        onTapCancel: () => setState(() => scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}

class OverlayModel1 {
  static void show(
    BuildContext context, {
    required String judul,
    required String penjelas,
  }) {
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Material(
        color: Colors.black45, // redup
        child: Center(
          child: _AnimatedOverlayContainer(
            child: _Model1Content(
              judul: judul,
              penjelas: penjelas,
              onClose: () => OverlayService.close(),
            ),
          ),
        ),
      ),
    );

    OverlayService.show(entry, context);
  }
}

class _Model1Content extends StatelessWidget {
  final String judul;
  final String penjelas;
  final VoidCallback onClose;

  const _Model1Content({
    required this.judul,
    required this.penjelas,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // tombol X kanan atas
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              HoverScale(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text("X"),
                ),
              ),
            ],
          ),

          Text(judul, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(penjelas),

          const SizedBox(height: 20),

          HoverScale(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.5),
              ),
              child: const Text("Tutup"),
            ),
          ),
        ],
      ),
    );
  }
}

class OverlayModel2 {
  static void show(
    BuildContext context, {
    required String judul,
    required String penjelas,
  }) {
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Material(
        color: Colors.black38,
        child: Center(
          child: _AnimatedOverlayContainer(
            child: _Model2Content(
              judul: judul,
              penjelas: penjelas,
            ),
          ),
        ),
      ),
    );

    OverlayService.show(entry, context);
  }

  static void close() => OverlayService.close();
}

class _Model2Content extends StatelessWidget {
  final String judul;
  final String penjelas;

  const _Model2Content({
    required this.judul,
    required this.penjelas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(judul, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(penjelas),

          const SizedBox(height: 30),

          // animasi loading
          SizedBox(
            height: 48,
            width: 48,
            child: _AnimatedLoading(),
          ),
        ],
      ),
    );
  }
}

class _AnimatedLoading extends StatefulWidget {
  @override
  State<_AnimatedLoading> createState() => _AnimatedLoadingState();
}

class _AnimatedLoadingState extends State<_AnimatedLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<String> frames = [
    'assets/loading1.png',
    'assets/loading2.png',
    'assets/loading3.png',
    'assets/loading4.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        int index = (_controller.value * frames.length).floor();
        return Image.asset(frames[index % frames.length]);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AnimatedOverlayContainer extends StatefulWidget {
  final Widget child;

  const _AnimatedOverlayContainer({required this.child});

  @override
  State<_AnimatedOverlayContainer> createState() =>
      _AnimatedOverlayContainerState();
}

class _AnimatedOverlayContainerState extends State<_AnimatedOverlayContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..forward();

    _scale = Tween(begin: 0.85, end: 1.0).animate(_controller);
    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}