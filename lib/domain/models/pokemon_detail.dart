class PokemonDetail {
  final int id;
  final String name;
  final String svgUrl;
  final String gifUrl;
  final int hp;
  final int attack;
  final int defense;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.svgUrl,
    required this.gifUrl,
    required this.hp,
    required this.attack,
    required this.defense,
  });
}
