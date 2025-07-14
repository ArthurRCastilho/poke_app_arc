import 'package:flutter/material.dart';
import 'package:poke_app_arc/models/pokemon.dart';
import 'package:poke_app_arc/services/pokeapi_service.dart';

import 'package:poke_app_arc/widgets/pokemon_card.dart'; // Certifique-se de que o caminho está correto

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  Pokemon? _foundPokemon; // Armazena o Pokémon encontrado
  bool _isLoading = false; // Indica se está carregando
  String? _errorMessage; // Armazena mensagens de erro

  final PokeApiService _pokeApiService = PokeApiService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchPokemon() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _foundPokemon = null;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _foundPokemon = null;
    });

    try {
      // Tenta buscar por ID primeiro
      final int? pokemonId = int.tryParse(query);
      Pokemon? pokemonResult;

      if (pokemonId != null) {
        pokemonResult = await _pokeApiService.fetchPokemon(pokemonId);
      } else {
        // Se não for um ID, tenta buscar por nome.
        // A PokeAPI não tem um endpoint direto para busca por nome que retorne todos os detalhes
        // de forma simples como por ID sem antes ter que buscar a lista e filtrar.
        // Para simplificar, vou simular uma busca por nome pegando os primeiros 150 Pokémons
        // e verificando se o nome corresponde. Em uma aplicação real, você pode otimizar isso
        // com um backend próprio ou um endpoint de busca mais robusto.

        // Exemplo Simplificado: busca na lista dos primeiros 150 Pokemons
        // Nota: Esta abordagem é ineficiente para muitos Pokemons e um ID específico seria melhor.
        final allPokemons = await _pokeApiService.fetchPokemonList(
          limit: 150,
        );
        pokemonResult = allPokemons.firstWhere(
          (p) => p.name.toLowerCase() == query.toLowerCase(),
          orElse: () => throw Exception(
            'Pokémon não encontrado com o nome "$query"',
          ),
        );
      }

      setState(() {
        _foundPokemon = pokemonResult;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Erro ao buscar Pokémon: ${e.toString().replaceAll('Exception:', '')}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pesquisar Pokémon',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Digite o nome ou ID do Pokémon...',
                hintStyle: TextStyle(color: Colors.white.withAlpha(180)),
                filled: true,
                fillColor: Colors.white.withAlpha(40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          _searchPokemon(); // Limpa os resultados também
                        },
                      )
                    : null,
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) =>
                  _searchPokemon(), // Dispara a pesquisa ao pressionar Enter
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.white.withAlpha(220),
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tente pesquisar por um ID (ex: 25) ou nome exato.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            : _foundPokemon != null
            ? SizedBox(
                height: 250,
                width: 200,
                child: PokemonCard(pokemon: _foundPokemon!),
              ) // Exibe o card do Pokémon
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.white.withAlpha(200),
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pesquise por seu Pokémon favorito!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Use o campo de busca acima para encontrar Pokémons pelo nome ou ID.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
