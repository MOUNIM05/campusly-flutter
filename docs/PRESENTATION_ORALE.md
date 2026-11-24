# CAMPUSLY — Plan de présentation orale

Université Mundiapolis · 2ACINFO · Développement mobile

Durée proposée : 10 à 12 minutes, dont 4 minutes de démonstration. Les noms, les coordonnées et les cours sont fictifs.

## Diapositive 1 — Présentation du projet

**Contenu essentiel**

- CAMPUSLY : « Your Campus, Your Community. »
- Une application Flutter pour découvrir les étudiants, explorer les cours et personnaliser son expérience.
- Public : les étudiants de l’Université Mundiapolis.

**À dire** : « Nous avons transformé les exercices sur les widgets en une application universitaire cohérente. »

**Démonstration** : ouvrir l’accueil, montrer la palette de couleurs et les cinq destinations de navigation.

## Diapositive 2 — Problème et objectifs

**Contenu essentiel**

- Retrouver facilement un camarade dans un annuaire.
- Consulter une fiche, mémoriser des favoris et découvrir des cours.
- Comprendre et appliquer Icon, CircleAvatar, Card et ListTile.
- Proposer une interface lisible, responsive et utilisable sans serveur.

**À dire** : « Chaque interaction doit avoir un résultat observable : une navigation, une modification ou un retour visuel. »

**Démonstration** : utiliser le raccourci de recherche de l’accueil pour rejoindre l’annuaire.

## Diapositive 3 — Architecture de l’application

**Contenu essentiel**

- `models/` définit Etudiant et Cours.
- `data/` contient les données fictives.
- `pages/` contient les écrans ; `widgets/` contient les composants réutilisables.
- `theme/` centralise Material 3 et les thèmes clair/sombre.
- `AppController` partage les favoris et préférences avec ChangeNotifier.
- `setState` gère les filtres et les sélections propres à un écran.
- SharedPreferences conserve les choix sur l’appareil.

**À dire** : « Une seule source de vérité évite qu’un favori soit différent entre deux écrans. L’architecture reste simple à expliquer. »

**Démonstration** : ouvrir `etudiant.dart`, puis `app_controller.dart` dans VS Code. Montrer `toggleFavorite` et `notifyListeners`.

## Diapositive 4 — Icon et IconButton

**Contenu essentiel**

- Icon affiche un symbole ; sa taille et sa couleur sont configurables.
- `semanticLabel` décrit le symbole pour les lecteurs d’écran.
- IconButton ajoute une zone interactive, un tooltip et `onPressed`.
- Les icônes Material et Cupertino peuvent coexister.

**Démonstration** : Widgets Lab → IconPage. Montrer Home 24, Favorite 40, School 64, les huit services, puis toucher la cloche : « Icône cliquée ».

**Question à anticiper** : un Icon seul ne possède pas `onPressed` ; on utilise IconButton pour une action accessible.

## Diapositive 5 — CircleAvatar

**Contenu essentiel**

- Initiales, image réseau, image locale ou icône.
- `initiales('Sara El Amrani')` renvoie `SE`, les premières lettres des deux premiers mots.
- Cinq avatars utilisent des couleurs différentes de `Colors.primaries`.
- Deux CircleAvatar imbriqués créent la bordure : rayon 44 puis rayon 40.
- Stack et Positioned ajoutent la pastille de présence.
- Un chargement ou une erreur d’image affiche les initiales.

**Démonstration** : Widgets Lab → AvatarPage. Montrer l’image locale et l’exemple réseau ; expliquer que l’absence de connexion n’empêche pas l’affichage des initiales.

## Diapositive 6 — Card et InkWell

**Contenu essentiel**

- Comparaison entre Card avec élévation 4, Card.filled et Card.outlined.
- Image de cours : `height: 150`, `BoxFit.cover`.
- `clipBehavior: Clip.antiAlias` respecte les angles arrondis.
- InkWell à l’intérieur de Card fournit le toucher et l’effet d’onde.
- Les boutons Détails et S’inscrire ont des actions distinctes.

**Démonstration** : Widgets Lab → CardPage. Toucher une carte, ouvrir Détails, s’inscrire puis annuler l’inscription.

## Diapositive 7 — ListTile et ses variantes

**Contenu essentiel**

- `leading`, `title`, `subtitle` et `trailing` donnent une structure standard.
- Divider sépare les réglages.
- `isThreeLine: true` permet un sous-titre long.
- `selected` met en évidence une seule ligne à la fois.
- SwitchListTile active le vrai thème sombre ; CheckboxListTile active le résumé du campus.
- Une déconnexion nécessite une confirmation dans AlertDialog.

**Démonstration** : Widgets Lab → ListTilePage. Ouvrir une ligne, la fermer, changer de ligne et montrer la sélection unique. Activer le mode sombre.

## Diapositive 8 — Démonstration du mini-projet

**Parcours conseillé**

1. Ouvrir ContactsPage depuis Widgets Lab.
2. Rechercher « Bennani », puis ouvrir Adam.
3. Montrer le rayon 60, l’e-mail, le téléphone et la filière.
4. Ajouter Adam aux favoris et revenir en arrière.
5. Observer le compteur ; retrouver Adam dans Favoris.
6. Dans l’annuaire, glisser Adam à gauche puis toucher Annuler.
7. Retirer le favori et montrer l’état vide.

**À dire** : « La liste est construite avec ListView.builder. Chaque entrée est une Card contenant un ListTile. Navigator.push ouvre le profil. »

## Diapositive 9 — Bonus et vérification

**Contenu essentiel**

- Recherche immédiate, tri alphabétique et filtres par filière.
- Suppression Dismissible avec annulation.
- Inscriptions locales et filtre Mes cours.
- Préférences conservées après redémarrage.
- Interface anglais/français, mode sombre, images et police intégrées.
- Adaptation mobile, tablette et grand écran.
- Tests de comportement et analyse statique ; résultats exacts dans `docs/VERIFICATION.md`.

**Démonstration** : changer la langue, activer le résumé du campus puis revenir à l’accueil. Agrandir la fenêtre Web pour montrer la navigation latérale.

## Diapositive 10 — Conclusion

**Contenu essentiel**

- Les quatre widgets sont utilisés dans des situations concrètes et dans des pages de démonstration séparées.
- Le projet reste compréhensible : modèles, composants réutilisables, état local et contrôleur partagé.
- Limites assumées : compte local fictif, inscriptions de démonstration, pas de notifications push ni de serveur.
- Évolutions possibles : authentification universitaire et données réelles, avec les autorisations adaptées.

**À dire** : « CAMPUSLY montre qu’une bonne maîtrise des widgets fondamentaux suffit pour construire une application cohérente et interactive. »

**Démonstration** : terminer sur l’accueil et laisser le Widgets Lab accessible pour les questions du professeur.
