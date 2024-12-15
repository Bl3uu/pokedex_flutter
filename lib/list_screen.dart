import 'package:flutter/material.dart';
import 'poke_api_service.dart';
import 'detail_screen.dart';
import 'models.dart'; // Import the models

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final PokeApiService _apiService = PokeApiService();
  List<Pokemon> _pokemonList = [];
  bool _isLoading = true;

  Map<String, Color> typeColors = {
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow,
    'psychic': Colors.purple,
    'rock': Colors.brown,
    'ground': Colors.orange,
    'ice': Colors.cyan,
    'dragon': Colors.indigo,
    'dark': Colors.black,
    'fairy': Colors.pink,
    'normal': Colors.grey,
    'flying': Colors.lightBlue,
    // Add more types as needed
  };

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();
  }

  Future<void> _fetchPokemonList() async {
    try {
      final pokemonList = await _apiService.fetchPokemonList();
      final updatedList = await Future.wait(pokemonList.map((pokemon) async {
        final details = await _apiService.fetchPokemonDetails(pokemon.name);
        return Pokemon(
          name: pokemon.name,
          url: pokemon.url,
          types: details.types,
          spriteUrl: details.spriteUrl,
        );
      }));

      setState(() {
        _pokemonList = updatedList;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching Pokémon list: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon List')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _pokemonList.length,
        itemBuilder: (context, index) {
          final pokemon = _pokemonList[index];
          final primaryType =
          pokemon.types.isNotEmpty ? pokemon.types.first : 'normal';
          final buttonColor =
              typeColors[primaryType] ?? Colors.grey;

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5, // Adds depth
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15), // Rounded corners
                ),
                backgroundColor:
                buttonColor, // Custom background color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemonDetailsScreen(
                      name: pokemon.name,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Image.network(
                    pokemon.spriteUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    pokemon.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
