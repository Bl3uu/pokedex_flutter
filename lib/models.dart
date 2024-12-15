class Pokemon {
  final String name;
  final String url;
  final List<String> types;
  final String spriteUrl;

  Pokemon({
    required this.name,
    required this.url,
    this.types = const [],
    required this.spriteUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
      types: [],
      spriteUrl: json['sprites']?['front_default'] ?? '',
    );
  }
}

class PokemonDetails {
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final String spriteUrl;
  final List<String> types;  // List of types
  final List<String> abilities;  // List of abilities

  PokemonDetails({
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.spriteUrl,
    required this.types,
    required this.abilities,
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    return PokemonDetails(
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      imageUrl: json['sprites']['front_default'],
      spriteUrl: json['sprites']['front_default'],
      types: List<String>.from(json['types'].map((type) => type['type']['name'])),
      abilities: List<String>.from(json['abilities'].map((ability) => ability['ability']['name'])),
    );
  }
}