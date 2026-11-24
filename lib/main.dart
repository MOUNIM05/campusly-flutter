import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/app_controller.dart';
import 'pages/courses_page.dart';
import 'pages/favorites_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/students_page.dart';
import 'pages/widgets_lab_page.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/custom_avatar.dart';
import 'widgets/page_intro.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final preferences = await SharedPreferences.getInstance();
    runApp(CampuslyApp(controller: AppController(preferences)));
  } catch (_) {
    runApp(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.storage_rounded,
                    size: 48,
                    color: AppColors.blue,
                  ),
                  const SizedBox(height: 20),
                  const Text('Your campus is almost ready.'),
                  const SizedBox(height: 8),
                  const Text(
                    'Local storage could not be opened. Allow browser storage or try again.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(onPressed: main, child: const Text('Try again')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CampuslyApp extends StatelessWidget {
  const CampuslyApp({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => MaterialApp(
      title: 'CAMPUSLY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(controller.language),
      supportedLocales: const [Locale('en'), Locale('fr')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: controller.signedIn
          ? _CampusShell(controller: controller)
          : _WelcomePage(controller: controller),
    ),
  );
}

class _CampusShell extends StatefulWidget {
  const _CampusShell({required this.controller});
  final AppController controller;
  @override
  State<_CampusShell> createState() => _CampusShellState();
}

class _CampusShellState extends State<_CampusShell> {
  int _index = 0;
  final _bucket = PageStorageBucket();
  void _navigate(int index) => setState(() => _index = index);
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final wide = MediaQuery.sizeOf(context).width >= 1100;
    final labels = [
      c.t('Home', 'Accueil'),
      c.t('Students', 'Étudiants'),
      c.t('Courses', 'Cours'),
      c.t('Favorites', 'Favoris'),
      c.t('Settings', 'Réglages'),
    ];
    final pages = [
      HomePage(controller: c, onNavigate: _navigate),
      StudentsPage(controller: c),
      CoursesPage(controller: c),
      FavoritesPage(controller: c, onBrowse: () => _navigate(1)),
      SettingsPage(controller: c),
    ];
    final page = PageStorage(
      bucket: _bucket,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: KeyedSubtree(key: ValueKey(_index), child: pages[_index]),
      ),
    );
    final appbar = AppBar(
      toolbarHeight: 70,
      titleSpacing: wide ? 30 : 20,
      title: wide
          ? Text(labels[_index])
          : const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: _Wordmark(),
            ),
      actions: [
        if (_index == 1 || _index == 3)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Chip(
                key: const ValueKey('appbar-favorite-count'),
                avatar: const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Color(0xFFE7A629),
                ),
                label: Text(
                  '${c.favorites.length}',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ),
        IconButton(
          key: const ValueKey('appbar-widgets-lab'),
          tooltip: 'Widgets Lab',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => WidgetsLabPage(controller: c),
            ),
          ),
          icon: const Icon(Icons.widgets_outlined, size: 21),
        ),
        const SizedBox(width: 12),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          color: Theme.of(context).dividerColor.withValues(alpha: .1),
        ),
      ),
    );
    final scaffold = Scaffold(
      appBar: appbar,
      body: Column(
        children: [
          if (c.storageError != null)
            MaterialBanner(
              content: Text(c.storageError!),
              actions: [
                TextButton(
                  onPressed: () => showFeedback(
                    context,
                    c.t(
                      'Preferences will be saved again after your next change.',
                      'Les préférences seront réenregistrées après votre prochaine modification.',
                    ),
                  ),
                  child: Text(c.t('Details', 'Détails')),
                ),
              ],
            ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: page,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : CampusBottomNavigation(
              index: _index,
              onChanged: _navigate,
              controller: c,
            ),
    );
    if (!wide) {
      return scaffold;
    }
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 232,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor
                        .withValues(alpha: .12),
                  ),
                ),
              ),
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(27, 31, 20, 8),
                      child: _Wordmark(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 28, bottom: 38),
                      child: Text(
                        'YOUR CAMPUS, YOUR COMMUNITY.',
                        style: TextStyle(fontSize: 7, letterSpacing: .8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28, bottom: 13),
                      child: Text(
                        c.t('YOUR SPACE', 'VOTRE ESPACE'),
                        style: const TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (var i = 0; i < labels.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: ListTile(
                          selected: _index == i,
                          selectedTileColor: AppColors.blue.withValues(
                            alpha: .09,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: Icon(
                            [
                              Icons.grid_view_rounded,
                              Icons.people_outline_rounded,
                              Icons.auto_stories_outlined,
                              Icons.star_outline_rounded,
                              Icons.tune_rounded,
                            ][i],
                            size: 21,
                          ),
                          title: Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _index == i
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                          ),
                          trailing: i == 3 && c.favorites.isNotEmpty
                              ? Text(
                                  '${c.favorites.length}',
                                  style: const TextStyle(fontSize: 12),
                                )
                              : null,
                          onTap: () => _navigate(i),
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 22,
                      ),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListTile(
                        leading: const Icon(Icons.widgets_outlined, size: 21),
                        title: const Text(
                          'Widgets Lab',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Icon(
                          Icons.north_east_rounded,
                          size: 15,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => WidgetsLabPage(controller: c),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withValues(alpha: .06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.school_outlined,
                            color: AppColors.blue,
                            size: 22,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            c.t('A place to belong.', 'Un lieu pour grandir.'),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Université Mundiapolis\n2ACINFO · 2026 / 2027',
                            style: TextStyle(fontSize: 10, height: 1.8),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 0, 20, 24),
                      child: Row(
                        children: [
                          CustomAvatar(
                            name: 'Yasmine Alaoui',
                            photoUrl: 'assets/portraits/student_1.jpg',
                            radius: 17,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yasmine Alaoui',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Student account',
                                  style: TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: scaffold),
          ],
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(9),
        ),
        child: const Icon(Icons.school_rounded, color: Colors.white, size: 19),
      ),
      const SizedBox(width: 9),
      Text(
        'CAMPUSLY',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.3,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 3, bottom: 9),
        child: Text(
          '•',
          style: TextStyle(color: AppColors.turquoise, fontSize: 18),
        ),
      ),
    ],
  );
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _Wordmark(),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: .08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    size: 74,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  controller.t(
                    'Your campus is\none tap away.',
                    'Votre campus\nvous attend.',
                  ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(fontSize: 36),
                ),
                const SizedBox(height: 18),
                Text(
                  controller.t(
                    'Discover your community, explore new ideas and make your university years count.',
                    'Découvrez votre communauté, explorez de nouvelles idées et vivez vos années universitaires.',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: const ValueKey('enter-campus'),
                    onPressed: controller.signIn,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      controller.t(
                        'Continue as Yasmine',
                        'Continuer avec Yasmine',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  controller.t(
                    'Local demo account · no password required',
                    'Compte de démonstration local · sans mot de passe',
                  ),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
