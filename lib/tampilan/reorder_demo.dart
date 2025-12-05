import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ReorderDemo extends StatefulWidget {
  const ReorderDemo({super.key});

  @override
  State<ReorderDemo> createState() => _ReorderDemoState();
}

class _ReorderDemoState extends State<ReorderDemo> {
  List<Color> items = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  int? dragFrom;

  void swap(int from, int to) {
    if (from == to) return;
    final item = items.removeAt(from);
    items.insert(to, item);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: List.generate(items.length, (index) {
          return DragTarget<int>(
            onWillAccept: (from) {
              if (from == null) return false;

              setState(() {
                swap(from, index);
              });

              return true;
            },
            onAccept: (_) {},
            builder: (context, candidate, rejected) {
              return Draggable<int>(
                data: index,
                feedback: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    width: 80,
                    height: 80,
                    color: items[index].withOpacity(0.7),
                  ),
                ),
                childWhenDragging: Container(
                  width: 80,
                  height: 80,
                  color: items[index].withOpacity(0.3),
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  color: items[index],
                ),

                // INI PENTING UNTUK WEB



              );
            },
          );
        }),
      ),
    );
  }
}
