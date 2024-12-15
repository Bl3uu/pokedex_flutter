import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart'; // Import the models

class PokeApiService {
  static const String baseUrl = "https://pokeapi.co/api/v2";

  Future<List<Pokemon>> fetchPokemonList({int limit = 60, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Map the results into a list of Pokemon objects
      return (data['results'] as List).map((pokemon) => Pokemon.fromJson(pokemon)).toList();
    } else {
      throw Exception("Failed to fetch Pokémon list");
    }
  }

  Future<PokemonDetails> fetchPokemonDetails(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PokemonDetails.fromJson(data);  // Return a PokemonDetails object
    } else {
      throw Exception("Failed to fetch Pokémon details");
    }
  }
}