import 'package:bai_test_intern/models/commentModel.dart';
import 'package:flutter/material.dart';

class Commentitem extends StatefulWidget {
  const Commentitem({super.key, required this.index, required this.list});
  final List<commentModel> list;
  final int index;

  @override
  State<Commentitem> createState() => _CommentState();
}

class _CommentState extends State<Commentitem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 206, 205, 205),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.list[widget.index].name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  child: Text(
                    widget.list[widget.index].content,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
