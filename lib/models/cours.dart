class Cours {
  const Cours({
    required this.id,
    required this.titre,
    required this.description,
    required this.enseignant,
    required this.categorie,
    required this.image,
    required this.duree,
    required this.niveau,
    required this.modules,
  });
  final String id;
  final String titre;
  final String description;
  final String enseignant;
  final String categorie;
  final String image;
  final String duree;
  final String niveau;
  final List<String> modules;
}
