import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../data/courses_data.dart';
import '../widgets/course_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_intro.dart';

enum _CourseSort { recommended, title, shortest }

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key, required this.controller});
  final AppController controller;
  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  String _category = 'All';
  bool _enrolledOnly = false;
  _CourseSort _sort = _CourseSort.recommended;

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _updateFilters(VoidCallback update) {
    setState(update);
    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  void _clearFilters() {
    _search.clear();
    FocusScope.of(context).unfocus();
    _updateFilters(() {
      _category = 'All';
      _enrolledOnly = false;
      _sort = _CourseSort.recommended;
    });
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final c = widget.controller;
      final query = _search.text.trim().toLowerCase();
      final courses = coursesData
          .where(
            (course) =>
                (_category == 'All' || course.categorie == _category) &&
                (!_enrolledOnly || c.isRegistered(course.id)) &&
                '${course.titre} ${course.description} ${course.enseignant} ${course.categorie}'
                    .toLowerCase()
                    .contains(query),
          )
          .toList();
      switch (_sort) {
        case _CourseSort.recommended:
          break;
        case _CourseSort.title:
          courses.sort(
            (a, b) => a.titre.toLowerCase().compareTo(b.titre.toLowerCase()),
          );
        case _CourseSort.shortest:
          courses.sort(
            (a, b) =>
                int.parse(a.duree.split(' ').first)
                    .compareTo(int.parse(b.duree.split(' ').first)),
          );
      }
      return LayoutBuilder(
        builder: (context, viewport) => Column(
          children: [
            Padding(
              padding: pagePadding(context).copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewport.maxHeight >= 560)
                    PageIntro(
                      eyebrow: c.t(
                        'Stay curious. Go further.',
                        'La curiosité vous emmène plus loin.',
                      ),
                      title: c.t(
                        'Your next big idea.',
                        'Votre prochaine grande idée.',
                      ),
                      subtitle: c.t(
                        'Discover courses made for the way you want to grow.',
                        'Des cours pour apprendre, créer et progresser.',
                      ),
                    ),
                  TextField(
                    key: const ValueKey('course-search'),
                    controller: _search,
                    onChanged: (_) => _updateFilters(() {}),
                    decoration: InputDecoration(
                      hintText: c.t(
                        'Search courses or instructors',
                        'Rechercher un cours ou un enseignant',
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: c.t(
                                'Clear course search',
                                'Effacer la recherche',
                              ),
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _search.clear();
                                _updateFilters(() {});
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final category in [
                          'All',
                          'Development',
                          'Design',
                          'Data',
                          'Business',
                        ])
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                category == 'All'
                                    ? c.t('All courses', 'Tous les cours')
                                    : category,
                              ),
                              selected: _category == category,
                              showCheckmark: false,
                              onSelected: (_) =>
                                  _updateFilters(() => _category = category),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${courses.length} ${c.t('courses', 'cours')}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        PopupMenuButton<_CourseSort>(
                          tooltip: c.t('Sort courses', 'Trier les cours'),
                          initialValue: _sort,
                          icon: const Icon(Icons.sort_rounded, size: 21),
                          onSelected: (value) =>
                              _updateFilters(() => _sort = value),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: _CourseSort.recommended,
                              child: Text(c.t('Recommended', 'Recommandés')),
                            ),
                            PopupMenuItem(
                              value: _CourseSort.title,
                              child: Text(c.t('Title A–Z', 'Titre A–Z')),
                            ),
                            PopupMenuItem(
                              value: _CourseSort.shortest,
                              child: Text(
                                c.t('Shortest first', 'Les plus courts'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        FilterChip(
                          label: Text(c.t('My courses', 'Mes cours')),
                          selected: _enrolledOnly,
                          onSelected: (value) =>
                              _updateFilters(() => _enrolledOnly = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: courses.isEmpty
                  ? EmptyState(
                      icon: query.isEmpty
                          ? Icons.auto_stories_outlined
                          : Icons.search_off_rounded,
                      title: query.isEmpty
                          ? c.t(
                              'Room for something new',
                              'Place à la découverte',
                            )
                          : c.t('No courses found', 'Aucun cours trouvé'),
                      message: query.isEmpty
                          ? c.t(
                              'Register for a course to see it here, or clear your filters.',
                              'Inscrivez-vous à un cours ou effacez les filtres.',
                            )
                          : c.t(
                              'Try a different title, topic or instructor.',
                              'Essayez un autre titre, sujet ou enseignant.',
                            ),
                      action: OutlinedButton(
                        onPressed: _clearFilters,
                        child: Text(
                          query.isEmpty
                              ? c.t(
                                  'Explore all courses',
                                  'Voir tous les cours',
                                )
                              : c.t('Clear filters', 'Effacer les filtres'),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final availableWidth =
                            constraints.maxWidth -
                            pagePadding(context).horizontal;
                        final columns = availableWidth >= 960
                            ? 3
                            : availableWidth >= 600
                            ? 2
                            : 1;
                        final rows = (courses.length / columns).ceil();
                        return ListView.builder(
                          key: const PageStorageKey('courses-list'),
                          controller: _scroll,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: pagePadding(context).copyWith(top: 4),
                          itemCount: rows,
                          itemBuilder: (_, row) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var col = 0; col < columns; col++) ...[
                                  if (col > 0) const SizedBox(width: 20),
                                  Expanded(
                                    child: row * columns + col < courses.length
                                        ? CourseCard(
                                            course:
                                                courses[row * columns + col],
                                            controller: c,
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}
