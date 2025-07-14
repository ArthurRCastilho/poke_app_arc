import 'package:flutter/material.dart';

class StatsBarPokemon extends StatelessWidget {
  const StatsBarPokemon({
    super.key,
    required this.label,
    required this.value,
    required this.progressColor,
  });
  final String label;
  final int value;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white.withAlpha(200),
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value / 200,
                backgroundColor: Colors.white.withAlpha(70),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor.withAlpha(180),
                ),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white.withAlpha(230),
            ),
          ),
        ],
      ),
    );
  }
}
