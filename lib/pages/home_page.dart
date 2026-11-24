import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../data/courses_data.dart';
import '../theme/app_theme.dart';
import '../widgets/course_card.dart';
import '../widgets/custom_avatar.dart';
import '../widgets/page_intro.dart';
import '../widgets/student_card.dart';
import 'widgets_lab_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.controller,
    required this.onNavigate,
  });
  final AppController controller;
  final ValueChanged<int> onNavigate;
  @override
  Widget build(BuildContext context) {
    final c = controller;
    return SingleChildScrollView(
      key: const PageStorageKey('home-scroll'),
      padding: pagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.t(
                        'YOUR CAMPUS, YOUR COMMUNITY',
                        'VOTRE CAMPUS, VOTRE COMMUNAUTÉ',
                      ),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c.t('Hello, Yasmine.', 'Bonjour, Yasmine.'),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      c.t(
                        'A good day to learn. A great day to connect.',
                        'Une belle journée pour apprendre et se retrouver.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () => onNavigate(4),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: CustomAvatar(
                    name: 'Yasmine Alaoui',
                    photoUrl: 'assets/portraits/student_1.jpg',
                    radius: 25,
                    online: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => onNavigate(1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: .10),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.secondary,
                    size: 21,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      c.t(
                        'Find a classmate, make a connection…',
                        'Retrouvez un camarade…',
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          _CampusHero(controller: c, onExplore: () => onNavigate(1)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '${c.students.length}',
                  label: c.t('Students', 'Étudiants'),
                  icon: Icons.people_outline_rounded,
                  color: AppColors.blue,
                  onTap: () => onNavigate(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  value: '${coursesData.length}',
                  label: c.t('Courses', 'Cours'),
                  icon: Icons.auto_stories_outlined,
                  color: const Color(0xFF078F83),
                  onTap: () => onNavigate(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  value: '${c.favorites.length}',
                  label: c.t('Favorites', 'Favoris'),
                  icon: Icons.star_outline_rounded,
                  color: const Color(0xFFB27522),
                  onTap: () => onNavigate(3),
                ),
              ),
            ],
          ),
          SectionHeading(
            title: c.t(
              'Your campus, one tap away',
              'Votre campus à portée de main',
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final item in [
                  (
                    Icons.people_outline_rounded,
                    c.t('Directory', 'Annuaire'),
                    AppColors.blue,
                    1,
                  ),
                  (
                    Icons.auto_stories_outlined,
                    c.t('My learning', 'Mes cours'),
                    const Color(0xFF078F83),
                    2,
                  ),
                  (
                    Icons.star_outline_rounded,
                    c.t('My circle', 'Mes favoris'),
                    const Color(0xFFB27522),
                    3,
                  ),
                  (
                    Icons.tune_rounded,
                    c.t('Preferences', 'Préférences'),
                    AppColors.purple,
                    4,
                  ),
                ])
                  SizedBox(
                    width: (constraints.maxWidth - 30) / 4,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => onNavigate(item.$4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 17,
                            horizontal: 4,
                          ),
                          child: Column(
                            children: [
                              IconTile(icon: item.$1, color: item.$3, size: 38),
                              const SizedBox(height: 9),
                              Text(
                                item.$2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SectionHeading(
            title: c.t(
              'A little curiosity goes a long way',
              'Cultivez votre curiosité',
            ),
            action: c.t('View all', 'Tout voir'),
            onTap: () => onNavigate(2),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth > 820
                  ? 3
                  : constraints.maxWidth > 570
                  ? 2
                  : 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < count; i++) ...[
                        if (i > 0) const SizedBox(width: 18),
                        Expanded(
                          child: CourseCard(
                            course: coursesData[i],
                            controller: c,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 26),
          Card.filled(
            color: AppColors.blue.withValues(alpha: .07),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: const ValueKey('open-widgets-lab'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => WidgetsLabPage(controller: c),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const IconTile(icon: Icons.widgets_outlined, size: 48),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WIDGETS LAB',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1.8,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            c.t(
                              'Small widgets. Big possibilities.',
                              'Petits widgets, grandes possibilités.',
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.t(
                              'Icons, avatars, cards & more. Explore the assignment.',
                              'Icônes, avatars, cartes… Explorez le TP.',
                            ),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
          SectionHeading(
            title: c.t('New faces on campus', 'De nouveaux visages'),
            action: c.t('Meet everyone', 'Voir tous'),
            onTap: () => onNavigate(1),
          ),
          if (c.students.isEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.people_outline_rounded),
                title: Text(
                  c.t('Your directory is empty', 'Votre annuaire est vide'),
                ),
                subtitle: Text(
                  c.t(
                    'Deleted students can be restored with Undo immediately after a swipe.',
                    'Utilisez Annuler juste après la suppression.',
                  ),
                ),
              ),
            ),
          for (final student in c.students.reversed.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: StudentCard(student: student, controller: c),
            ),
          const SizedBox(height: 20),
          _LearningNote(controller: c, onTap: () => onNavigate(2)),
          if (c.updates) ...[
            SectionHeading(
              title: c.t('Your campus digest', 'Votre résumé du campus'),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.t(
                        'A community worth showing up for.',
                        'Une communauté à retrouver.',
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c.t(
                        '${c.students.length} students to meet and ${coursesData.length} courses to explore. Your next connection starts with a hello.',
                        '${c.students.length} étudiants à rencontrer et ${coursesData.length} cours à découvrir. Commencez par un bonjour.',
                      ),
                    ),
                    if (c.notifications) ...[
                      const SizedBox(height: 12),
                      Text(
                        c.t(
                          'Reminder: explore Widgets Lab before your presentation.',
                          'Rappel : explorez le Widgets Lab avant votre présentation.',
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 26),
          Center(
            child: Text(
              'CAMPUSLY  /  MUNDIAPOLIS  /  2ACINFO',
              style: TextStyle(
                fontSize: 8,
                letterSpacing: 1.5,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampusHero extends StatelessWidget {
  const _CampusHero({required this.controller, required this.onExplore});
  final AppController controller;
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/campus.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, error, stack) =>
                const ColoredBox(color: AppColors.navy),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.navy,
                  AppColors.navy.withValues(alpha: .83),
                  AppColors.navy.withValues(alpha: .35),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -28,
          top: -45,
          child: Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: .09),
                width: 30,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.turquoise,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.t(
                      'THIS IS YOUR PLACE',
                      'VOUS ÊTES À VOTRE PLACE',
                    ),
                    style: const TextStyle(
                      color: AppColors.turquoise,
                      fontSize: 9,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                controller.t(
                  'Big ideas.\nBetter together.',
                  'De grandes idées.\nEnsemble.',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -.8,
                ),
              ),
              const SizedBox(height: 13),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Text(
                  controller.t(
                    'Meet your community. Find your inspiration.\nMake your university years your own.',
                    'Rencontrez votre communauté. Inspirez-vous.\nVivez pleinement vos années universitaires.',
                  ),
                  style: const TextStyle(
                    color: Color(0xFFC1CBDF),
                    height: 1.7,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.turquoise,
                  foregroundColor: AppColors.navy,
                ),
                onPressed: onExplore,
                label: Text(
                  controller.t(
                    'Explore your community',
                    'Explorer la communauté',
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(icon: icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineLarge
                  ?.copyWith(fontSize: 26),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

class _LearningNote extends StatelessWidget {
  const _LearningNote({required this.controller, required this.onTap});
  final AppController controller;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      leading: const IconTile(
        icon: Icons.local_library_outlined,
        color: AppColors.turquoise,
      ),
      title: Text(
        controller.t('Keep your momentum', 'Gardez votre élan'),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        controller.t(
          '${controller.registeredCount} courses in your learning journey.',
          '${controller.registeredCount} cours dans votre parcours.',
        ),
        style: const TextStyle(fontSize: 11),
      ),
      trailing: const Icon(Icons.arrow_forward_rounded, size: 20),
      onTap: onTap,
    ),
  );
}
