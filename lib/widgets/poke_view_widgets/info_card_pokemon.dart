import 'package:flutter/material.dart';

class InfoCardPokemon extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color cardBackgroundColor;

  const InfoCardPokemon({
    super.key,
    required this.title,
    required this.children,
    required this.cardBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white.withAlpha(240),
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
