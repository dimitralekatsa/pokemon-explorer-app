class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;
  final String svgUrl;
  final int hp;
  final int attack;
  final int defense;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.svgUrl,
    required this.hp,
    required this.attack,
    required this.defense,
  });
}
