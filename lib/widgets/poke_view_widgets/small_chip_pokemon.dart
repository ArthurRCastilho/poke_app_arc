import 'package:flutter/material.dart';

class SmallChipPokemon extends StatelessWidget {
  const SmallChipPokemon({
    super.key,
    required this.label,
    required this.color,
  });
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
