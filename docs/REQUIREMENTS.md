# Grille de conformité du TP

Référence utilisée : les exigences complètes fournies dans la conversation. Le fichier `TP_Flutter_Widgets_2ACINFO.pdf` n’était pas joint au workspace au moment de la réalisation ; sa conformité indépendante ne peut donc pas être certifiée.

| Exigence | Emplacement / démonstration |
| --- | --- |
| Identité CAMPUSLY, slogan, palette, Material 3, thème central | `main.dart`, `theme/app_theme.dart`, accueil et réglages |
| Cinq destinations fonctionnelles | `widgets/bottom_navigation.dart`, `_CampusShell` ; navigation latérale dès 1100 px |
| Accueil : profil, recherche, statistiques, raccourcis, cours, étudiants | `pages/home_page.dart` |
| Modèle Etudiant : prenom, nom, email, telephone, photoUrl, filiere, favori | `models/etudiant.dart` ; identifiant stable ajouté |
| Au moins huit étudiants fictifs | Dix profils dans `data/students_data.dart` |
| Card contenant ListTile : avatar, nom, e-mail, étoile | `widgets/student_card.dart` |
| ListView.builder pour l’annuaire | `pages/students_page.dart` |
| Profil par Navigator.push, retour, rayon 60, coordonnées | `pages/student_details_page.dart` |
| Compteur de favoris dans l’AppBar | `main.dart`, `pages/contacts_page.dart` |
| Favoris synchronisés et état vide | `controllers/app_controller.dart`, `pages/favorites_page.dart` |
| Recherche prénom/nom sans casse, tri par nom, groupes alphabétiques | `pages/students_page.dart` |
| Dismissible, suppression et annulation | `pages/students_page.dart` ; suppression également persistée |
| Au moins quatre cours fictifs | Six dans `data/courses_data.dart` |
| Image 150 px, BoxFit.cover, Clip.antiAlias | `widgets/course_card.dart` |
| Titre, description, enseignant, catégorie, Détails, S’inscrire | `widgets/course_card.dart`, `pages/course_details_page.dart` |
| Card avec élévation 4, filled et outlined | `pages/card_page.dart` ; teinte et bordure explicites pour comparaison |
| Catalogue ListView.builder et InkWell | `pages/courses_page.dart`, `widgets/course_card.dart` |
| Bonus : recherche de cours, tri alphabétique/par durée et filtres combinés | `pages/courses_page.dart` ; recherche par titre, sujet ou enseignant et repli sur écran compact |
| SnackBar au toucher d’une carte, boutons utiles | `widgets/course_card.dart`, `pages/card_page.dart` |
| Six lignes Compte/Notifications/Langue/Confidentialité/Aide/Déconnexion | `pages/settings_page.dart` |
| Leading, title, subtitle, trailing flèche, Divider | `SettingsPage._row` et groupes de réglages |
| SwitchListTile, CheckboxListTile, sélection unique | `pages/settings_page.dart` |
| isThreeLine: true | Ligne Confidentialité de `pages/settings_page.dart` |
| Thème sombre réel | `CampuslyApp.themeMode`, `AppTheme.dark` |
| Déconnexion rouge et AlertDialog | `SettingsPage._confirmLogout` ; retour à un écran d’entrée fonctionnel |
| IconPage distincte, trois tailles 24/40/64 | `pages/icon_page.dart` |
| Huit icônes universitaires, texte et semanticLabel | Grille de `IconPage` |
| CupertinoIcons, IconButton, « Icône cliquée » | Cloche de `IconPage` |
| AvatarPage : initiales, réseau, icône, asset | `pages/avatar_page.dart` |
| Cinq avatars de couleurs Colors.primaries | `pages/avatar_page.dart` |
| initiales('Sara El Amrani') == 'SE' | `widgets/custom_avatar.dart` ; cas vide et Unicode gérés |
| Bordure : CircleAvatar blanc 44 et intérieur 40 | `pages/avatar_page.dart` |
| Badge en ligne Stack/Positioned | `widgets/custom_avatar.dart` |
| Erreurs d’images et chargement | `CustomAvatar` : errorBuilder et loadingBuilder ; images de cours protégées |
| Menu Widgets Lab et cinq pages séparées | `pages/widgets_lab_page.dart`, entrée dans l’AppBar et sur l’accueil |
| CardPage / ListTilePage / ContactsPage | Fichiers dédiés ; réutilisation des composants réels de l’application |
| Null safety, const, setState, séparation simple | Tous les fichiers `lib/` ; filtres dans des StatefulWidget |
| Aucun service backend ni compte réel | SharedPreferences uniquement ; images locales sauf exemple réseau |
| README et six questions de réflexion | `README.md` |
| Plan oral en français, dix diapositives et démonstrations | `docs/PRESENTATION_ORALE.md` |
| Tests et limites de vérification explicites | `test/`, `docs/VERIFICATION.md` |

Les numéros de téléphone sont volontairement non composables et les e-mails utilisent le domaine réservé `example.com`.
