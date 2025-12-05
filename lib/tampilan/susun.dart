import 'dart:math';
import 'package:flutter/material.dart';

/// Data yang dikirim saat drag
class _DragData {
  final int row; // 0 or 1
  final int index;
  final String name; // namaIndeks[row][index]
  _DragData(this.row, this.index, this.name);
}

class Susun extends StatefulWidget {
  final bool duaSusun; // false = single row, true = two rows
  final int jumlahAnak; // (unused strictly) bisa dipakai validasi
  final double jarakAnak; // jarak antar anak
  final Widget pemisah; // Icon or Image
  final double besarPemisah; // ukuran pemisah
  final double jarakPemisah; // jarak kiri/kanan antara pemisah dan anak
  final Widget placeholder;
  final List<List<Widget>> anak; // anak[0], anak[1] (if duaSusun true)
  final int animasiDrag; // 0 = none, 1 = goyang
  final List<List<String>> namaIndeks; // nama per indeks per row

  const Susun({
    super.key,
    this.duaSusun = false,
    required this.jumlahAnak,
    required this.jarakAnak,
    required this.pemisah,
    required this.besarPemisah,
    required this.jarakPemisah,
    required this.placeholder,
    required this.anak,
    required this.animasiDrag,
    required this.namaIndeks,
  });

  @override
  State<Susun> createState() => _SusunState();
}

class _SusunState extends State<Susun> with TickerProviderStateMixin {
  // internal mutable lists (parent-controlled original copied here)
  late List<Widget> _row1;
  late List<Widget> _row2;

  late List<String> _names1;
  late List<String> _names2;

  // dragging state
  bool _isDragging = false;
  _DragData? _dragging; // sumber drag
  _DragData? _target; // tempat sementara (row,index) placeholder

  // controller untuk animasi "goyang" saat drag feedback
  late AnimationController _dragAnimController;

  @override
  void initState() {
    super.initState();
    _row1 = List<Widget>.from(widget.anak.isNotEmpty ? widget.anak[0] : []);
    _names1 = List<String>.from(widget.namaIndeks.isNotEmpty ? widget.namaIndeks[0] : []);

    if (widget.duaSusun) {
      _row2 = List<Widget>.from(widget.anak.length > 1 ? widget.anak[1] : []);
      _names2 = List<String>.from(widget.namaIndeks.length > 1 ? widget.namaIndeks[1] : []);
    } else {
      _row2 = [];
      _names2 = [];
    }

    _dragAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    ); // we'll start/stop when drag begins/ends
  }

  @override
  void dispose() {
    _dragAnimController.dispose();
    super.dispose();
  }

  // Utility: get display list for a row considering current drag/target
  List<Widget> _buildDisplayRow(int rowIndex) {
    final sourceRow = (rowIndex == 0) ? _row1 : _row2;
    final namesRow = (rowIndex == 0) ? _names1 : _names2;

    // if not dragging, display normal items interleaved with pemisah
    if (!_isDragging || _dragging == null) {
      return List.generate(sourceRow.length * 2 - 1, (i) {
        if (i.isEven) {
          final idx = i ~/ 2;
          return _wrapItem(rowIndex, idx, sourceRow[idx]);
        } else {
          return _buildBetweenPemisah();
        }
      });
    }

    // during dragging, we will remove the source item from its row and
    // insert a placeholder at target (if target row == this row)
    List<Widget> items = [];

    // create a shallow copy of widgets (not to mutate original)
    final tempWidgets = List<Widget>.from(sourceRow);
    final tempNames = List<String>.from(namesRow);

    // remove source if dragging from this row
    if (_dragging!.row == rowIndex) {
      // keep track of original removal index
      tempWidgets.removeAt(_dragging!.index);
      tempNames.removeAt(_dragging!.index);
    }

    // Determine insert position for placeholder
    int insertAt = -1;
    if (_target != null && _target!.row == rowIndex) {
      insertAt = _target!.index;
      // insert placeholder in tempWidgets view
    }

    // Build sequence with placeholder if any
    for (int i = 0; i <= tempWidgets.length; i++) {
      // if i matches insertAt, place placeholder first
      if (insertAt == i) {
        items.add(widget.placeholder);
        if (i != tempWidgets.length) items.add(SizedBox(width: widget.jarakAnak));
        if (i != tempWidgets.length) items.add(_buildBetweenPemisah());
      }

      if (i < tempWidgets.length) {
        items.add(_wrapItem(rowIndex, i, tempWidgets[i]));
        if (i != tempWidgets.length - 1) {
          items.add(SizedBox(width: widget.jarakAnak));
          items.add(_buildBetweenPemisah());
        }
      }
    }

    // Edge case: if no placeholder and not removed? if dragging from other row, insert nothing
    if (insertAt == -1 && !_isDragging) {
      // fallback to original
      return List.generate(sourceRow.length * 2 - 1, (i) {
        if (i.isEven) {
          final idx = i ~/ 2;
          return _wrapItem(rowIndex, idx, sourceRow[idx]);
        } else {
          return _buildBetweenPemisah();
        }
      });
    }

    return items;
  }

  
  // Build the actual item wrapped with Draggable & DragTarget slot
  Widget _wrapItem(int rowIndex, int index, Widget child) {
    final String name = (rowIndex == 0) ? _names1[index] : _names2[index];

    return LongPressDraggable<_DragData>(
      data: _DragData(rowIndex, index, name),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      maxSimultaneousDrags: 1,
      feedback: _buildDragFeedback(child),
      childWhenDragging: Opacity(opacity: 0.0, child: child), // keep layout but invisible
      onDragStarted: () {
        setState(() {
          _isDragging = true;
          _dragging = _DragData(rowIndex, index, name);
          _target = _dragging; // default target is original position initially
        });
        if (widget.animasiDrag == 1) {
          _dragAnimController.repeat(reverse: true);
        }
      },
      onDragEnd: (_) {
        // if drag ends without accept, reset
        setState(() {
          _isDragging = false;
          _dragging = null;
          _target = null;
        });
        _dragAnimController.stop();
      },
      child: DragTarget<_DragData>(
        onWillAcceptWithDetails: (details) {
          final data = details.data;
          // allow accept only if same row OR if single-row mode
          if (!widget.duaSusun) {
            // single row: allow anywhere
            // compute a tentative index based on pointer position -> handled by target slots
            return true;
          } else {
            // duaSusun true: only accept if same row
            return data.row == rowIndex;
          }
        },
        onLeave: (details) {

        },
        onAcceptWithDetails: (details) {
          final data = details.data;
          // We have to determine final target index = _target!.index (if same row)
          if (_target == null) return;

          if (data.row != _target!.row) {
            // cross-row accept should not happen (blocked in willAccept), ignore
            setState(() {
              _isDragging = false;
              _dragging = null;
              _target = null;
            });
            return;
          }

          final fromRow = data.row;
          final fromIndex = data.index;
          final toIndex = _target!.index;

          setState(() {
            if (fromRow == 0) {
              final movingWidget = _row1.removeAt(fromIndex);
              final movingName = _names1.removeAt(fromIndex);

              // adjust insertion index when source index is before target because removal shifts index
              int insertAt = toIndex;
              if (fromIndex < toIndex) insertAt = toIndex - 1;
              if (insertAt < 0) insertAt = 0;
              if (insertAt > _row1.length) insertAt = _row1.length;

              _row1.insert(insertAt, movingWidget);
              _names1.insert(insertAt, movingName);

              // HERE: panggil afterReorder / setelahSusun untuk namaIndeks
              // -- COMMENT: Panggil callback sesuai nama:
              //    setelahSusun[row][insertAt]();
              // Tempat pemanggilan sebenarnya diserahkan kepadamu. Beri komentar di sini.
            } else {
              final movingWidget = _row2.removeAt(fromIndex);
              final movingName = _names2.removeAt(fromIndex);

              int insertAt = toIndex;
              if (fromIndex < toIndex) insertAt = toIndex - 1;
              if (insertAt < 0) insertAt = 0;
              if (insertAt > _row2.length) insertAt = _row2.length;

              _row2.insert(insertAt, movingWidget);
              _names2.insert(insertAt, movingName);

              // COMMENT: Setelah reordering, panggil callback menggunakan _names2[insertAt]
            }

            // reset dragging state
            _isDragging = false;
            _dragging = null;
            _target = null;
          });

          _dragAnimController.stop();
        },
        builder: (context, candidateData, rejectedData) {
          // Build just the child (the Draggable's child). The placement / placeholder logic is handled globally when assembling display list.
          return child;
        },
      ),
    );
  }

  // Build the drag feedback widget with optional animation (goyang)
  Widget _buildDragFeedback(Widget child) {
    Widget feedbackChild = Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
        child: child,
      ),
    );

    if (widget.animasiDrag == 1) {
      // apply rotation animation to feedback
      return AnimatedBuilder(
        animation: _dragAnimController,
        builder: (context, ch) {
          final tilt = sin(_dragAnimController.value * 2 * pi) * (15 * pi / 180);
          return Transform.rotate(angle: tilt, child: ch);
        },
        child: feedbackChild,
      );
    }

    return feedbackChild;
  }


  // build pemisah widget with given size and padding
  Widget _buildBetweenPemisah() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.jarakPemisah),
      child: SizedBox(
        width: widget.besarPemisah,
        height: widget.besarPemisah,
        child: Center(child: widget.pemisah),
      ),
    );
  }

  // Build a DragTarget "slot" between items to accept insertBefore(index)
  // Actually we use continuous DragTarget by wrapping each item; here we provide global insertion logic:
  // For simplicity, we'll provide Drop zones by wrapping the whole row area: pointer position is not used to compute exact index
  // Instead, we'll compute index by which DragTarget (i.e. which child) we are over — implemented via per-child DragTarget above.

  // Build single row view (used for duaSusun == false)
  Widget _buildSingleRow() {
    // build list of items with pemisah between
    final display = _buildDisplayRow(0);

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: widget.jarakAnak,
        children: display,
      ),
    );
  }

  // build double row: left row (row0), big pemisah, right row (row1)
  Widget _buildDoubleRow() {
    final left = _buildDisplayRow(0);
    final right = _buildDisplayRow(1);

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: widget.jarakAnak,
            children: left,
          ),
          SizedBox(width: widget.jarakPemisah),
          SizedBox(
            width: widget.besarPemisah,
            height: widget.besarPemisah,
            child: Center(child: widget.pemisah),
          ),
          SizedBox(width: widget.jarakPemisah),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: widget.jarakAnak,
            children: right,
          ),
        ],
      ),
    );
  }

  // Function to update _target based on which drag target we hover.
  // This method should be invoked from DragTarget callbacks when we can determine an index.
  // However above we used per-item DragTarget, which does not provide per-gap index easily.
  // To approximate expected behavior, we also update _target when pointer enters a DragTarget by using the data passed.
  void _setTemporaryTarget(int row, int index) {
    setState(() {
      _target = _DragData(row, index, (row == 0 ? _names1 : _names2).asMap().containsKey(index) ? (row == 0 ? _names1[index] : _names2[index]) : '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      if (!widget.duaSusun) {
        return _buildSingleRow();
      } else {
        return _buildDoubleRow();
      }
    });
  }
}
