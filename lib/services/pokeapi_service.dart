import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poke_app_arc/models/pokemon.dart';

class PokeApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  static const Set<int> _ultraBeastIds = {
    793,
    794,
    795,
    796,
    797,
    798,
    799,
    803,
    804,
    805,
    806,
  };

  Future<Map<String, dynamic>> _fetchPokemonSpeciesData(
    int pokemonId,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pokemon-species/$pokemonId/'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Erro ao buscar dados da espécie do Pokémon: $pokemonId',
      );
    }
  }

  Future<List<String>> _getFormImages(
    int pokemonId,
    String formType,
  ) async {
    List<String> images = [];
    final speciesResponse = await http.get(
      Uri.parse('$_baseUrl/pokemon-species/$pokemonId/'),
    );
    if (speciesResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body);
      final List varieties = speciesData['varieties'] ?? [];
      for (var variety in varieties) {
        final String pokemonName = variety['pokemon']['name'] as String;
        // Verifica se o nome da variedade contém o tipo de forma (ex: '-mega', '-gigantamax', '-gmax')
        if (pokemonName.contains(formType) ||
            (formType == '-gigantamax' && pokemonName.contains('-gmax'))) {
          final pokemonDetailResponse = await http.get(
            Uri.parse(variety['pokemon']['url']),
          );
          if (pokemonDetailResponse.statusCode == 200) {
            final detailData = jsonDecode(pokemonDetailResponse.body);
            String? imageUrl;

            // Tentar obter a imagem do 'official-artwork' primeiro
            if (detailData['sprites']['other'] != null &&
                detailData['sprites']['other']['official-artwork']?['front_default'] !=
                    null) {
              imageUrl =
                  detailData['sprites']['other']['official-artwork']['front_default'];
            }

            // Se não encontrar em 'official-artwork', tentar 'home'
            if (imageUrl == null &&
                detailData['sprites']['other'] != null &&
                detailData['sprites']['other']['home']?['front_default'] !=
                    null) {
              imageUrl =
                  detailData['sprites']['other']['home']['front_default'];
            }

            // Se ainda não encontrar, tentar 'dream_world'
            if (imageUrl == null &&
                detailData['sprites']['other'] != null &&
                detailData['sprites']['other']['dream_world']?['front_default'] !=
                    null) {
              imageUrl =
                  detailData['sprites']['other']['dream_world']['front_default'];
            }

            // Fallback para 'front_default' geral se nenhuma das anteriores for encontrada
            imageUrl ??= detailData['sprites']['front_default'];

            if (imageUrl != null) {
              images.add(imageUrl);
            }
          }
        }
      }
    }
    return images;
  }

  Future<Pokemon> fetchPokemon(int id) async {
    final pokemonResponse = await http.get(
      Uri.parse('$_baseUrl/pokemon/$id'),
    );

    if (pokemonResponse.statusCode != 200) {
      throw Exception('Erro ao buscar Pokémon');
    }

    final pokemonData = jsonDecode(pokemonResponse.body);
    final types = (pokemonData['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    final weaknesses = await _fetchWeaknesses(types);

    final speciesData = await _fetchPokemonSpeciesData(id);
    final bool isLegendary = speciesData['is_legendary'] ?? false;
    final bool isMythical = speciesData['is_mythical'] ?? false;

    final List<String> megaEvolutionImages = await _getFormImages(
      id,
      '-mega',
    );
    final List<String> gigantamaxImages = await _getFormImages(
      id,
      '-gigantamax',
    );

    final bool hasMegaEvolution = megaEvolutionImages.isNotEmpty;
    final bool hasGigantamax = gigantamaxImages.isNotEmpty;
    final bool isUltraBeast = _ultraBeastIds.contains(id);

    return Pokemon.fromJson(
      pokemonData,
      weaknesses,
      isLegendary: isLegendary,
      isMythical: isMythical,
      hasMegaEvolution: hasMegaEvolution,
      hasGigantamax: hasGigantamax,
      isUltraBeast: isUltraBeast,
      megaEvolutionImages: megaEvolutionImages,
      gigantamaxImages: gigantamaxImages,
    );
  }

  Future<List<Pokemon>> fetchPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar lista de Pokémon');
    }

    final data = jsonDecode(response.body);
    final List results = data['results'];
    List<Pokemon> pokemons = [];

    for (final result in results) {
      final String url = result['url'];
      final int pokemonId = int.parse(
        url.split('/')[url.split('/').length - 2],
      );

      final detailRes = await http.get(Uri.parse(result['url']));
      if (detailRes.statusCode == 200) {
        final detailData = jsonDecode(detailRes.body);
        final types = (detailData['types'] as List)
            .map((t) => t['type']['name'] as String)
            .toList();
        final weaknesses = await _fetchWeaknesses(types);

        final speciesData = await _fetchPokemonSpeciesData(pokemonId);
        final bool isLegendary = speciesData['is_legendary'] ?? false;
        final bool isMythical = speciesData['is_mythical'] ?? false;

        final List<String> megaEvolutionImages = await _getFormImages(
          pokemonId,
          '-mega',
        );
        final List<String> gigantamaxImages = await _getFormImages(
          pokemonId,
          '-gigantamax',
        );

        final bool hasMegaEvolution = megaEvolutionImages.isNotEmpty;
        final bool hasGigantamax = gigantamaxImages.isNotEmpty;
        final bool isUltraBeast = _ultraBeastIds.contains(pokemonId);

        pokemons.add(
          Pokemon.fromJson(
            detailData,
            weaknesses,
            isLegendary: isLegendary,
            isMythical: isMythical,
            hasMegaEvolution: hasMegaEvolution,
            hasGigantamax: hasGigantamax,
            isUltraBeast: isUltraBeast,
            megaEvolutionImages: megaEvolutionImages,
            gigantamaxImages: gigantamaxImages,
          ),
        );
      }
    }

    return pokemons;
  }

  Future<List<String>> _fetchWeaknesses(List<String> types) async {
    Set<String> weaknesses = {};

    for (final type in types) {
      final response = await http.get(Uri.parse('$_baseUrl/type/$type'));
      if (response.statusCode == 200) {
        final typeData = jsonDecode(response.body);
        final damageRelations = typeData['damage_relations'];

        final doubleDamageFrom =
            damageRelations['double_damage_from'] as List;
        for (final item in doubleDamageFrom) {
          weaknesses.add(item['name']);
        }
      }
    }

    return weaknesses.toList();
  }

  Future<String?> _fetchEvolutionChainUrl(int pokemonId) async {
    final speciesResponse = await http.get(
      Uri.parse('$_baseUrl/pokemon-species/$pokemonId/'),
    );
    if (speciesResponse.statusCode == 200) {
      final data = jsonDecode(speciesResponse.body);
      if (data['evolution_chain'] != null) {
        return data['evolution_chain']['url'];
      }
    }
    return null;
  }

  Future<List<String>> _getEvolutionSpeciesNames(
    String evolutionChainUrl,
  ) async {
    final response = await http.get(Uri.parse(evolutionChainUrl));
    List<String> speciesNames = [];

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var chain = data['chain'];

      void parseChain(Map<String, dynamic> currentChain) {
        speciesNames.add(currentChain['species']['name']);
        for (var evolvesTo in currentChain['evolves_to']) {
          parseChain(evolvesTo);
        }
      }

      parseChain(chain);
    }
    return speciesNames;
  }

  Future<List<Pokemon>> fetchEvolutions(int pokemonId) async {
    final evolutionChainUrl = await _fetchEvolutionChainUrl(pokemonId);
    if (evolutionChainUrl == null) {
      return [];
    }

    final speciesNames = await _getEvolutionSpeciesNames(
      evolutionChainUrl,
    );
    List<Pokemon> evolutions = [];

    for (var name in speciesNames) {
      try {
        final pokemonDetailsResponse = await http.get(
          Uri.parse('$_baseUrl/pokemon/$name'),
        );
        if (pokemonDetailsResponse.statusCode == 200) {
          final data = jsonDecode(pokemonDetailsResponse.body);
          final types = (data['types'] as List)
              .map((t) => t['type']['name'] as String)
              .toList();
          final weaknesses = await _fetchWeaknesses(types);

          final speciesData = await _fetchPokemonSpeciesData(data['id']);
          final bool isLegendary = speciesData['is_legendary'] ?? false;
          final bool isMythical = speciesData['is_mythical'] ?? false;

          final List<String> megaEvolutionImages = await _getFormImages(
            data['id'],
            '-mega',
          );
          final List<String> gigantamaxImages = await _getFormImages(
            data['id'],
            '-gigantamax',
          );

          final bool hasMegaEvolution = megaEvolutionImages.isNotEmpty;
          final bool hasGigantamax = gigantamaxImages.isNotEmpty;
          final bool isUltraBeast = _ultraBeastIds.contains(data['id']);

          evolutions.add(
            Pokemon.fromJson(
              data,
              weaknesses,
              isLegendary: isLegendary,
              isMythical: isMythical,
              hasMegaEvolution: hasMegaEvolution,
              hasGigantamax: hasGigantamax,
              isUltraBeast: isUltraBeast,
              megaEvolutionImages: megaEvolutionImages,
              gigantamaxImages: gigantamaxImages,
            ),
          );
        }
      } catch (e) {}
    }

    evolutions.sort((a, b) => a.idPokemon.compareTo(b.idPokemon));
    return evolutions;
  }
}
