import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poke_app_arc/core/functions/get_colors.dart';
import 'package:poke_app_arc/models/pokemon.dart';
import 'package:poke_app_arc/screens/pokemon_view.dart';
import 'package:poke_app_arc/widgets/poke_view_widgets/evolutions_card_pokemon.dart';
import 'package:poke_app_arc/widgets/poke_view_widgets/small_chip_pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isEvolutionCard;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.isEvolutionCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = pokemon.types.isNotEmpty
        ? getTypeColor(pokemon.types.first)
        : Colors.grey.shade400;

    final double cardWidth = isEvolutionCard ? 100 : 150;
    final double cardHeight = isEvolutionCard ? 140 : 180;
    final double imageSize = isEvolutionCard ? 60 : 90;
    final double nameFontSize = isEvolutionCard ? 10 : 16;
    final double idFontSize = isEvolutionCard ? 8 : 12;
    final double chipFontSize = isEvolutionCard ? 8 : 10;
    final EdgeInsets padding = isEvolutionCard
        ? const EdgeInsets.all(8)
        : const EdgeInsets.all(12);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PokemonView(pokemon: pokemon)),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: cardColor.withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [cardColor.withAlpha(230), cardColor.withAlpha(180)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.withAlpha(130),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isEvolutionCard)
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          if (pokemon.isLegendary)
                            SmallChipPokemon(
                              label: 'LEND.',
                              color: Colors.amber.shade700,
                            ),
                          if (pokemon.isMythical)
                            SmallChipPokemon(
                              label: 'MÍTICO',
                              color: Colors.deepPurple.shade700,
                            ),
                          if (pokemon.isUltraBeast)
                            SmallChipPokemon(
                              label: 'UB',
                              color: Colors.teal.shade700,
                            ),
                          if (pokemon.hasMegaEvolution)
                            SmallChipPokemon(
                              label: 'MEGA',
                              color: Colors.red.shade900,
                            ),
                          if (pokemon.hasGigantamax)
                            SmallChipPokemon(
                              label: 'G-MAX',
                              color: Colors.blueGrey.shade900,
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      '#${pokemon.idPokemon.toString().padLeft(3, '0')}',
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontWeight: FontWeight.w600,
                        fontSize: idFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isEvolutionCard ? 4 : 8),
            Hero(
              tag: 'pokemon-${pokemon.idPokemon}-card',
              child: CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error_outline, color: Colors.white),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: isEvolutionCard ? 4 : 8),
            Text(
              pokemon.name.toUpperCase(),
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isEvolutionCard ? 4 : 8),
            if (!isEvolutionCard)
              EvolutionsCardPokemon(
                pokemon: pokemon,
                chipFontSize: chipFontSize,
              ),
          ],
        ),
      ),
    );
  }
}
