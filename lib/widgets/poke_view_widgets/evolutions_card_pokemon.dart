import 'package:flutter/material.dart';
import 'package:poke_app_arc/core/functions/get_colors.dart';
import 'package:poke_app_arc/models/pokemon.dart';

class EvolutionsCardPokemon extends StatelessWidget {
  const EvolutionsCardPokemon({
    super.key,
    required this.pokemon,
    required this.chipFontSize,
  });

  final Pokemon pokemon;
  final double chipFontSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: pokemon.types.map((type) {
        final typeColor = getTypeColor(type);
        return Chip(
          backgroundColor: typeColor.withAlpha(220),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.white.withAlpha(70),
              width: 0.5,
            ),
          ),
          label: Text(
            type.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: chipFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}