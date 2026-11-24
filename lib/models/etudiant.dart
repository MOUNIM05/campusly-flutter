/// Immutable data. Changes go through AppController so every page agrees.
class Etudiant {
  const Etudiant({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.filiere,
    this.photoUrl,
    this.favori = false,
  });
  final String id;
  final String prenom;
  final String nom;
  final String email;
  final String telephone;
  final String? photoUrl;
  final String filiere;
  final bool favori;
  String get nomComplet => '$prenom $nom';
  Etudiant copyWith({bool? favori}) => Etudiant(
    id: id,
    prenom: prenom,
    nom: nom,
    email: email,
    telephone: telephone,
    filiere: filiere,
    photoUrl: photoUrl,
    favori: favori ?? this.favori,
  );
}
