# Rapport de vérification — CAMPUSLY

Vérification réalisée le 23 novembre 2026 dans le workspace Windows fourni. SDK détecté : Flutter 3.50.0 stable, Dart 3.14.0.

## Résultat

- Résolution des dépendances : réussie avec `dart pub get`, code de sortie 0.
- Analyse statique des sources et tests : **0 erreur, 0 avertissement, 0 lint**, avec le serveur officiel d’analyse Dart.
- Compilation native du code de test : réussie avec le compilateur frontend Flutter.
- Tests de comportement : **16 sur 16 réussis**, exécutés avec `flutter_tester.exe`, les assertions activées, `flutter_test` et le moteur de tests Dart.
- Captures de l’application : **10 PNG réels** produits dans `docs/screenshots/` ; le scénario de capture a également réussi.
- Compilation Web de production : réussie avec Dart2JS et le SDK Web Flutter. Le bundle local est dans `build/web/`.
- APK Android et exécution sur téléphone/émulateur : **non vérifiés**, à cause de la restriction du lanceur décrite ci-dessous.

## Restriction de l’environnement

Les commandes du lanceur Flutter ont été essayées : `flutter pub get`, `flutter analyze` et `flutter test`, via `tool/flutter.ps1`. Elles échouent au démarrage avant le travail demandé : le processus Dart ne peut pas ouvrir les pipes Windows de ses sous-processus (`CreateFile failed 5`, `Access is denied`, lors de l’appel de `where java` ou de Java).

Un cache de SDK local sous `.tooling/flutter/` a permis d’éviter les écritures dans le SDK système, mais ne supprime pas cette restriction de sous-processus. Aucun paramètre de sécurité système n’a été modifié.

Les résultats positifs ci-dessus proviennent donc de l’exécution directe des composants officiels. Ils ne signifient pas que les trois commandes du lanceur Flutter ont réussi dans cet environnement.

## Méthode de remplacement réellement exécutée

1. `dart pub get` avec `FLUTTER_ROOT` et `PUB_CACHE` dans le workspace : dépendances obtenues et `pubspec.lock` généré.
2. Serveur officiel `analysis_server_aot.dart.snapshot` : protocole d’analyse sur `lib/` et `test/`, avec les règles de `flutter_lints` et exclusion des caches.
3. `frontend_server_aot.dart.snapshot --target flutter --enable-asserts` : compilation des mêmes fichiers de tests présents dans `test/`.
4. `flutter_tester.exe --use-test-fonts --disable-asset-fonts --enable-software-rendering` : exécution de chaque test dans un processus isolé, avec initialisation de `TestWidgetsFlutterBinding` et chargement des tests par `test_api`. Aucun test de `test/` n’a été simulé ou remplacé par une simple inspection de code.
5. Compilation Dart2JS, `--invoker=flutter_tool`, SDK Web Flutter, mode production et optimisation `-O2` : génération du JavaScript de l’application avec enregistrement de SharedPreferences pour le Web.
6. Scénario de capture séparé : chargement réel de Manrope, des polices d’icônes et des photographies ; rendu des interfaces avec le moteur Flutter, puis export PNG.

Les scripts de remplacement et leurs journaux sont conservés dans `.tooling/` dans ce workspace. Ce dossier privé est ignoré par Git et exclu de l’archive source. Sur une machine sans cette restriction, les commandes standard suffisent :

```sh
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
flutter run
flutter build apk --debug
```

## Tests de comportement

| Test | Résultat |
| --- | --- |
| Initiales : nom composé, espaces, nom seul, chaîne vide et Unicode | Réussi |
| Favoris, suppression, annulation, absence de doublons et rechargement | Réussi |
| Inscriptions, langue et préférences conservées après rechargement | Réussi |
| Cinq destinations et navigation depuis l’état vide des favoris | Réussi |
| Recherche sans casse, ouverture du profil, rayon 60 et compteur partagé | Réussi |
| Recherche vide et Dismissible avec restauration du favori | Réussi |
| Retour SnackBar des cours, détails, inscription, annulation et filtre | Réussi |
| Recherche de cours par enseignant/sujet, tri, réinitialisation et clavier sur petit écran | Réussi |
| Thème sombre réel, case à cocher, sélection unique, langue et déconnexion | Réussi |
| Accès aux cinq pages du laboratoire et SnackBar « Icône cliquée » | Réussi |
| Repli des images d’avatar absentes ou invalides | Réussi |
| Compte, notifications, confidentialité, aide et effet des préférences sur l’accueil | Réussi |
| Recherche sur téléphone 320 × 667 avec clavier ouvert | Réussi |
| Les cinq écrans principaux à 320 px de largeur | Réussi |
| Les cinq écrans principaux à 800 px de largeur | Réussi |
| Les cinq écrans principaux à 1440 px de largeur | Réussi |

Les préférences sont simulées en mémoire dans les tests ; la logique de rechargement est vérifiée. Le stockage natif Android reste à confirmer lors du premier lancement sur appareil réel.

## Revue visuelle

Les captures correspondent au vrai code Flutter, avec deux favoris préparés pour illustrer les écrans :

- `home-mobile.png` : accueil, communauté et statistiques.
- `students-mobile.png` : annuaire, filtres et étoiles.
- `profile-mobile.png` : avatar de rayon 60 et coordonnées.
- `courses-mobile.png` : carte illustrée et boutons.
- `courses-desktop.png` : catalogue à trois colonnes, recherche et tri.
- `courses-dark-desktop.png` : catalogue en mode sombre.
- `favorites-mobile.png` : profils conservés.
- `settings-dark-mobile.png` : thème sombre et réglages.
- `widgets-lab-mobile.png` : accès explicite aux cinq démonstrations.
- `home-desktop.png` : navigation latérale et mise en page large.

Les premières captures ont permis de corriger l’héritage de la police ; les fichiers conservés sont les captures actualisées. Les tests ont également permis de corriger des débordements sur écran étroit, un état vide trop haut et la surface Material de la navigation latérale.

## Limites restantes

- Le PDF de l’énoncé n’était pas présent. La grille `REQUIREMENTS.md` vérifie toutes les exigences textuelles fournies ; une comparaison indépendante avec le PDF reste nécessaire.
- Le bundle Web est compilé, mais n’a pas été exécuté dans un navigateur pendant cette vérification. Les captures proviennent du moteur Flutter natif de test.
- Aucun APK n’est livré comme construit ou testé. La configuration Android, la permission Internet et les icônes sont présentes ; la chaîne Gradle doit être vérifiée hors de la restriction de sous-processus.
- Compte, coordonnées et cours fictifs ; inscriptions locales ; rappels dans l’application. Aucun backend, authentification réelle ni notification push.
- Principaux libellés disponibles en anglais et français ; contenus des cours et explications du laboratoire gardés dans leur langue d’origine.
