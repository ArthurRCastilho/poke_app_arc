import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poke_app_arc/models/pokemon.dart';

class AppBarPokemon extends StatelessWidget {
  const AppBarPokemon({
    super.key,
    required this.pokemon,
    required this.textTheme,
  });

  final Pokemon pokemon;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 280,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.symmetric(vertical: 16.0),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#${pokemon.idPokemon} - ${pokemon.name.toUpperCase()}',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black.withAlpha(100),
                      offset: const Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              if (pokemon.isLegendary)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    label: const Text(
                      'LENDÁRIO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.amber.shade700,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              if (pokemon.isMythical)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    label: const Text(
                      'MÍTICO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.deepPurple.shade700,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              if (pokemon.isUltraBeast)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    label: const Text(
                      'UB',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.teal.shade700,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              if (pokemon.hasMegaEvolution)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    label: const Text(
                      'MEGA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.red.shade900,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              if (pokemon.hasGigantamax)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    label: const Text(
                      'G-MAX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blueGrey.shade900,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ),
        background: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                ),
              ),
            ),
            Hero(
              tag: 'pokemon-${pokemon.idPokemon}',
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
