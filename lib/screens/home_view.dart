import 'package:flutter/material.dart';
import 'package:poke_app_arc/models/pokemon.dart';
import 'package:poke_app_arc/services/pokeapi_service.dart';
import 'package:poke_app_arc/widgets/pokemon_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PokeApiService _pokeApiService = PokeApiService();
  final List<Pokemon> _pokemons = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentOffset = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadMorePokemons();
    // Adicionaum listener para detectar quando o usuário rola para o final
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMorePokemons();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePokemons() async {
    if (_isLoadingMore || !_hasMoreData) {
      // Já está carregando ou não há mais nada
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newPokemons = await _pokeApiService.fetchPokemonList(
        limit: _limit,
        offset: _currentOffset,
      );

      if (!mounted) return;

      if (newPokemons.isEmpty) {
        _hasMoreData = false;
      } else {
        setState(() {
          _pokemons.addAll(newPokemons);
          _currentOffset += _limit;
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar Pokémons: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 94, 10, 10),
      appBar: AppBar(
        title: const Text(
          'PokéDex',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 94, 10, 10),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 94, 10, 10),
              const Color.fromARGB(255, 49, 4, 4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _pokemons.isEmpty && _isLoadingMore
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : _pokemons.isEmpty && !_isLoadingMore && !_hasMoreData
              ? Center(
                  child: Text(
                    'Nenhum Pokemon Encontrado',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount:
                      _pokemons.length +
                      (_isLoadingMore && _hasMoreData
                          ? 1
                          : 0), // Mais um para indicador de carregamento
                  itemBuilder: (context, index) {
                    if (index == _pokemons.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    return PokemonCard(pokemon: _pokemons[index]);
                  },
                ),
        ),
      ),
    );
  }
}


      // body: Center(
      //   child: Lottie.network(
      //     'https://lottie.host/69eaa217-49ab-48eb-aea9-e9f2329934f7/p5OOnpzQYD.json',
      //     repeat: true,
      //   ),
      // ),
