class Pokemon {
  final int idPokemon;
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> moves;
  final Map<String, int> stats;
  final List<String> versionImages;
  final List<String> weaknesses;
  final bool isLegendary;
  final bool isMythical;
  final bool hasMegaEvolution;
  final bool hasGigantamax;
  final bool isUltraBeast;
  final List<String> megaEvolutionImages;
  final List<String> gigantamaxImages;

  Pokemon({
    required this.idPokemon,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.moves,
    required this.stats,
    required this.versionImages,
    required this.weaknesses,
    this.isLegendary = false,
    this.isMythical = false,
    this.hasMegaEvolution = false,
    this.hasGigantamax = false,
    this.isUltraBeast = false,
    this.megaEvolutionImages = const [],
    this.gigantamaxImages = const [],
  });

  factory Pokemon.fromJson(
    Map<String, dynamic> json,
    List<String> weaknesses, {
    required bool isLegendary,
    required bool isMythical,
    required bool hasMegaEvolution,
    required bool hasGigantamax,
    required bool isUltraBeast,
    required List<String> megaEvolutionImages,
    required List<String> gigantamaxImages,
  }) {
    final types = (json['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    final List<String> moves = (json['moves'] as List)
        .take(5)
        .map((m) => m['move']['name'] as String)
        .toList();

    final Map<String, int> stats = {
      for (var stat in json['stats'])
        stat['stat']['name']: stat['base_stat'],
    };

    String? imageUrl;
    if (json['sprites']['other'] != null) {
      if (json['sprites']['other']['official-artwork']?['front_default'] !=
          null) {
        imageUrl =
            json['sprites']['other']['official-artwork']['front_default'];
      } else if (json['sprites']['other']['home']?['front_default'] !=
          null) {
        imageUrl = json['sprites']['other']['home']['front_default'];
      }
    }
    imageUrl ??=
        json['sprites']['front_default'] ??
        'https://placehold.co/90x90/cccccc/000000?text=No+Image';

    List<String> versionImages = [];
    final sprites = json['sprites'];
    if (sprites['versions'] != null) {
      final versions = sprites['versions'] as Map<String, dynamic>;
      for (var generation in versions.values) {
        if (generation is Map) {
          for (var version in generation.values) {
            if (version is Map && version['front_default'] != null) {
              versionImages.add(version['front_default']);
            }
          }
        }
      }
    }

    return Pokemon(
      idPokemon: json['id'],
      name: json['name'],
      imageUrl: imageUrl!,
      types: types,
      moves: moves,
      stats: stats,
      versionImages: versionImages,
      weaknesses: weaknesses,
      isLegendary: isLegendary,
      isMythical: isMythical,
      hasMegaEvolution: hasMegaEvolution,
      hasGigantamax: hasGigantamax,
      isUltraBeast: isUltraBeast,
      megaEvolutionImages: megaEvolutionImages,
      gigantamaxImages: gigantamaxImages,
    );
  }
}
