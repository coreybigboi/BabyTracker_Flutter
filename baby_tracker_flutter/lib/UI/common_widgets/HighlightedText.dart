import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({super.key, required this.label, required this.colour});

  final String label;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: colour
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(label, style: const TextStyle(
              color: Colors.white,
              fontSize: 16
            ),
          ),
        ),
    );
  }
}
