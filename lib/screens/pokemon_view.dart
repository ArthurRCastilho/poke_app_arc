import 'package:flutter/material.dart';
import 'package:poke_app_arc/core/functions/get_colors.dart';
import 'package:poke_app_arc/models/pokemon.dart';
import 'package:poke_app_arc/services/pokeapi_service.dart';
import 'package:poke_app_arc/widgets/poke_view_widgets/app_bar_pokemon.dart';
import 'package:poke_app_arc/widgets/poke_view_widgets/image_carrousel_pokemon.dart';
import 'package:poke_app_arc/widgets/poke_view_widgets/image_sections_pokemon.dart';
import 'package:poke_app_arc/widgets/poke_view_widgets/info_card_pokemon.dart';
import 'package:poke_app_arc/widgets/poke_view_widgets/stats_bar_pokemon.dart';
import 'package:poke_app_arc/widgets/pokemon_card.dart';

class PokemonView extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonView({super.key, required this.pokemon});



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final Color primaryTypeColor = getTypeColor(pokemon.types.first);

    final Color cardBackgroundColor = primaryTypeColor.withAlpha(200);
    final PokeApiService pokeApiService = PokeApiService();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryTypeColor.withAlpha(230),
              primaryTypeColor.withAlpha(255).withAlpha(180),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            AppBarPokemon(pokemon: pokemon, textTheme: textTheme),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoCardPokemon(
                      cardBackgroundColor: cardBackgroundColor,
                      title: 'Tipos',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: pokemon.types
                              .map(
                                (type) => Chip(
                                  label: Text(
                                    type.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: getTypeColor(type),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InfoCardPokemon(
                      cardBackgroundColor: cardBackgroundColor,
                      title: 'Versões',
                      children: [
                        ImageCarousselPokemon(
                          imageUrls: pokemon.versionImages,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InfoCardPokemon(
                      cardBackgroundColor: cardBackgroundColor,
                      title: 'Estatísticas',
                      children: pokemon.stats.entries
                          .map(
                            (entry) => StatsBarPokemon(
                              label: entry.key,
                              value: entry.value,
                              progressColor: primaryTypeColor,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    InfoCardPokemon(
                      cardBackgroundColor: cardBackgroundColor,
                      title: 'Fraquezas',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: pokemon.weaknesses
                              .map(
                                (weakness) => Chip(
                                  label: Text(
                                    weakness.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: getTypeColor(weakness),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InfoCardPokemon(
                      cardBackgroundColor: cardBackgroundColor,
                      title: 'Ataques Mais Fortes',
                      children: pokemon.moves
                          .map(
                            (move) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flash_on,
                                    color: Colors.white.withAlpha(180),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    move,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withAlpha(230),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    InfoCardPokemon(
                      cardBackgroundColor: cardBackgroundColor,
                      title: 'Evoluções',
                      children: [
                        FutureBuilder<List<Pokemon>>(
                          future: pokeApiService.fetchEvolutions(
                            pokemon.idPokemon,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Erro ao carregar evoluções: ${snapshot.error}',
                                  style: TextStyle(
                                    color: Colors.red.shade200,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  'Não há evoluções disponíveis.',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(180),
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else {
                              final evolutionsToShow = snapshot.data!;

                              final filteredEvolutions = evolutionsToShow
                                  .where(
                                    (evo) =>
                                        evo.idPokemon != pokemon.idPokemon,
                                  )
                                  .toList();

                              if (filteredEvolutions.isEmpty &&
                                  evolutionsToShow.isNotEmpty) {
                                return Center(
                                  child: Text(
                                    'Este é o único Pokémon em sua cadeia evolutiva.',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(180),
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              } else if (filteredEvolutions.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Não há evoluções adicionais.',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(180),
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: filteredEvolutions.map((evo) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12.0,
                                      ),
                                      child: PokemonCard(
                                        pokemon: evo,
                                        isEvolutionCard: true,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (pokemon.hasMegaEvolution || pokemon.hasGigantamax)
                      InfoCardPokemon(
                        cardBackgroundColor: cardBackgroundColor,
                        title: 'Formas Especiais',
                        children: [
                          if (pokemon.hasMegaEvolution &&
                              pokemon.megaEvolutionImages.isNotEmpty)
                            ImageSectionsPokemon(
                              title: 'Mega Evoluções:',
                              imageUrls: pokemon.megaEvolutionImages,
                            ),
                          if (pokemon.hasGigantamax &&
                              pokemon.gigantamaxImages.isNotEmpty)
                            ImageSectionsPokemon(
                              title: 'Formas Gigantamax:',
                              imageUrls: pokemon.gigantamaxImages,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
