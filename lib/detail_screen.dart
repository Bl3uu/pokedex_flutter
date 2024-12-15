import 'package:flutter/material.dart';
import 'poke_api_service.dart';
import 'models.dart';

class PokemonDetailsScreen extends StatelessWidget {
  final String name;

  const PokemonDetailsScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PokeApiService apiService = PokeApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blueAccent, // Modify the app bar color
      ),
      body: FutureBuilder<PokemonDetails>(
        future: apiService.fetchPokemonDetails(name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final pokemon = snapshot.data!;
          return SingleChildScrollView( // Allows for better scrolling when content overflows
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display Pokémon Image with rounded corners
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      pokemon.imageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Name of the Pokémon
                  Text(
                    pokemon.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display height, weight, and types in a structured way
                  InfoRow(title: 'Height', value: '${pokemon.height}m'),
                  InfoRow(title: 'Weight', value: '${pokemon.weight}kg'),
                  const SizedBox(height: 10),
                  // Display types
                  Text(
                    'Types: ${pokemon.types.join(', ')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  // Display abilities
                  Text(
                    'Abilities: ${pokemon.abilities.join(', ')}',
                    style: const TextStyle(fontSize: 16),
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

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}