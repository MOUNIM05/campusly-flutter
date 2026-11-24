import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_avatar.dart';
import '../widgets/page_intro.dart';
import 'widgets_lab_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.controller,
    this.laboratory = false,
  });
  final AppController controller;
  final bool laboratory;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selected;
  AppController get c => widget.controller;
  void _select(String row, VoidCallback action) {
    setState(() => _selected = row);
    action();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: c,
    builder: (context, _) => SingleChildScrollView(
      padding: pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageIntro(
                eyebrow: widget.laboratory
                    ? 'WIDGETS LAB / LISTTILE'
                    : c.t(
                        'Make yourself at home',
                        'Un espace qui vous ressemble',
                      ),
                title: widget.laboratory
                    ? 'ListTile, in action.'
                    : c.t('A little more you.', 'À votre image.'),
                subtitle: widget.laboratory
                    ? 'ListTile · SwitchListTile · CheckboxListTile · selected · isThreeLine'
                    : c.t(
                        'Your account, your preferences, your campus experience.',
                        'Votre compte, vos préférences et votre vie sur le campus.',
                      ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CustomAvatar(
                        name: 'Yasmine Alaoui',
                        photoUrl: 'assets/portraits/student_1.jpg',
                        radius: 30,
                        online: true,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yasmine Alaoui',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              '2ACINFO · Mundiapolis',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.blue,
                        size: 21,
                      ),
                    ],
                  ),
                ),
              ),
              SectionHeading(
                title: c.t('Account & preferences', 'Compte et préférences'),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _row(
                      'account',
                      Icons.person_outline_rounded,
                      c.t('Account', 'Compte'),
                      c.t(
                        'Your student profile and university details',
                        'Votre profil et vos informations universitaires',
                      ),
                      _showAccount,
                    ),
                    const Divider(indent: 74),
                    _row(
                      'notifications',
                      Icons.notifications_none_rounded,
                      c.t('Notifications', 'Notifications'),
                      c.notifications
                          ? c.t(
                              'Campus reminders are enabled',
                              'Les rappels du campus sont activés',
                            )
                          : c.t(
                              'Campus reminders are paused',
                              'Les rappels sont désactivés',
                            ),
                      _showNotifications,
                    ),
                    const Divider(indent: 74),
                    _row(
                      'language',
                      Icons.language_rounded,
                      c.t('Language', 'Langue'),
                      c.language == 'fr' ? 'Français' : 'English',
                      _showLanguage,
                    ),
                    const Divider(indent: 74),
                    _row(
                      'privacy',
                      Icons.shield_outlined,
                      c.t('Privacy', 'Confidentialité'),
                      c.t(
                        'Your favorites and preferences stay on this device. Learn how your demonstration data is stored.',
                        'Vos favoris et préférences restent sur cet appareil. Découvrez comment les données de démonstration sont enregistrées.',
                      ),
                      _showPrivacy,
                      threeLine: true,
                    ),
                    const Divider(indent: 74),
                    _row(
                      'help',
                      Icons.help_outline_rounded,
                      c.t('Help', 'Aide'),
                      c.t(
                        'A few answers, and a little guidance',
                        'Des réponses pour vous accompagner',
                      ),
                      _showHelp,
                    ),
                  ],
                ),
              ),
              SectionHeading(
                title: c.t('Just the way you like it', 'Comme vous l’aimez'),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SwitchListTile(
                      key: const ValueKey('dark-mode-switch'),
                      secondary: const IconTile(
                        icon: Icons.dark_mode_outlined,
                        color: AppColors.purple,
                      ),
                      title: Text(c.t('Dark mode', 'Mode sombre')),
                      subtitle: Text(
                        c.t(
                          'A softer look for late-night ideas',
                          'Un affichage doux pour vos soirées',
                        ),
                      ),
                      value: c.darkMode,
                      onChanged: c.setDarkMode,
                    ),
                    const Divider(indent: 74),
                    CheckboxListTile(
                      key: const ValueKey('updates-checkbox'),
                      title: Text(c.t('Campus digest', 'Actualités du campus')),
                      subtitle: Text(
                        c.t(
                          'Show the community digest on your home page',
                          'Afficher le résumé de la communauté sur l’accueil',
                        ),
                      ),
                      value: c.updates,
                      onChanged: (value) => c.setUpdates(value ?? false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                clipBehavior: Clip.antiAlias,
                child: _row(
                  'logout',
                  Icons.logout_rounded,
                  c.t('Logout', 'Déconnexion'),
                  c.t('See you around campus', 'À bientôt sur le campus'),
                  _confirmLogout,
                  red: true,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'CAMPUSLY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Your Campus, Your Community.\nv1.0.0 · Made for Mundiapolis',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, height: 1.8),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _row(
    String id,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool threeLine = false,
    bool red = false,
  }) => ListTile(
    key: ValueKey('settings-$id'),
    selected: _selected == id,
    selectedTileColor: AppColors.blue.withValues(alpha: .06),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    leading: IconTile(
      icon: icon,
      color: red ? const Color(0xFFDC4C55) : AppColors.blue,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: red ? const Color(0xFFDC4C55) : null,
      ),
    ),
    subtitle: Text(
      subtitle,
      maxLines: threeLine ? 3 : 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 11, height: 1.7),
    ),
    isThreeLine: threeLine,
    trailing: Icon(
      Icons.chevron_right_rounded,
      color: red ? const Color(0xFFDC4C55) : AppColors.secondary,
    ),
    onTap: () => _select(id, onTap),
  );

  void _showAccount() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(c.t('Your student account', 'Votre compte étudiant')),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Yasmine Alaoui'),
          SizedBox(height: 8),
          Text('yasmine.alaoui@example.com'),
          SizedBox(height: 8),
          Text(
            'Computer Science · 2ACINFO\nUniversité Mundiapolis\n\nFictional local demonstration account.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(c.t('Got it', 'Compris')),
        ),
      ],
    ),
  );

  void _showNotifications() => showDialog<void>(
    context: context,
    builder: (dialogContext) => ListenableBuilder(
      listenable: c,
      builder: (context, _) => AlertDialog(
        title: Text(c.t('Campus reminders', 'Rappels du campus')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                c.t('In-app reminders', 'Rappels dans l’application'),
              ),
              value: c.notifications,
              onChanged: c.setNotifications,
            ),
            Text(
              c.t(
                'Controls the reminders shown in the campus digest. This demo does not send push notifications.',
                'Contrôle les rappels du résumé sur l’accueil. La démonstration n’envoie pas de notifications push.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(c.t('Done', 'Terminé')),
          ),
        ],
      ),
    ),
  );

  void _showLanguage() => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(c.t('Choose your language', 'Choisir la langue')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in [('en', 'English'), ('fr', 'Français')])
            ListTile(
              title: Text(option.$2),
              selected: c.language == option.$1,
              trailing: Icon(
                c.language == option.$1
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
              ),
              onTap: () {
                c.setLanguage(option.$1);
                Navigator.pop(dialogContext);
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(c.t('Cancel', 'Annuler')),
        ),
      ],
    ),
  );

  void _showPrivacy() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(c.t('Your privacy matters', 'Votre vie privée compte')),
      content: Text(
        c.t(
          'All student identities and course information are fictional. Favorites, deleted student IDs, course registrations and preferences are stored locally using SharedPreferences. No backend, analytics or real authentication is used. The network-avatar example in Widgets Lab contacts randomuser.me; the rest of the app uses bundled images.',
          'Les identités et les cours sont fictifs. Les favoris, suppressions, inscriptions et préférences sont stockés localement avec SharedPreferences. Aucun serveur, outil d’analyse ni authentification réelle. Seul l’exemple d’avatar réseau du Widgets Lab contacte randomuser.me. Les autres images sont intégrées.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(c.t('Close', 'Fermer')),
        ),
      ],
    ),
  );

  void _showHelp() => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(c.t('A little help', 'Un peu d’aide')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpansionTile(
              title: Text(
                c.t(
                  'How do favorites work?',
                  'Comment fonctionnent les favoris ?',
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    c.t(
                      'Tap a star in the directory or a profile. Your Favorites tab and all counts update immediately.',
                      'Touchez une étoile dans l’annuaire ou un profil. Les favoris et compteurs sont actualisés immédiatement.',
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                c.t(
                  'Can I undo a deletion?',
                  'Puis-je annuler une suppression ?',
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    c.t(
                      'Swipe a student to the left, then tap Undo in the confirmation message.',
                      'Glissez un étudiant vers la gauche puis touchez Annuler dans le message.',
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.widgets_outlined),
              title: const Text('Widgets Lab'),
              subtitle: Text(
                c.t(
                  'All five assignment demonstrations',
                  'Les cinq démonstrations du TP',
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => WidgetsLabPage(controller: c),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(c.t('Close', 'Fermer')),
        ),
      ],
    ),
  );

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC4C55)),
        title: Text(c.t('Leaving for now?', 'Vous partez déjà ?')),
        content: Text(
          c.t(
            'Log out of your demo session? Your saved favorites and preferences will be here when you return.',
            'Quitter la session de démonstration ? Vos favoris et préférences seront conservés.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(c.t('Stay here', 'Rester')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC4C55),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(c.t('Logout', 'Déconnexion')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      c.signOut();
    }
  }
}
