import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_intro.dart';
import '../widgets/student_card.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key, required this.controller});
  final AppController controller;
  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final _search = TextEditingController();
  String _program = 'All';
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final c = widget.controller;
      final query = _search.text.trim().toLowerCase();
      final students =
          c.students
              .where(
                (s) =>
                    s.nomComplet.toLowerCase().contains(query) &&
                    (_program == 'All' || s.filiere == _program),
              )
              .toList()
            ..sort(
              (a, b) => a.nom.toLowerCase().compareTo(b.nom.toLowerCase()),
            );
      return LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Padding(
              padding: pagePadding(context).copyWith(bottom: 0),
              child: Column(
                children: [
                  if (constraints.maxHeight >= 480)
                    PageIntro(
                      eyebrow: c.t(
                        'The people make the place',
                        'Le campus, ce sont ses étudiants',
                      ),
                      title: c.t(
                        'Find your people.',
                        'Trouvez votre communauté.',
                      ),
                      subtitle: c.t(
                        'A familiar face. A new connection. Your campus community.',
                        'Un visage familier. Une nouvelle rencontre. Votre communauté.',
                      ),
                    ),
                  TextField(
                    key: const ValueKey('student-search'),
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: c.t(
                        'Search by first or last name',
                        'Rechercher par prénom ou nom',
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: c.t('Clear search', 'Effacer'),
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _search.clear();
                                setState(() {});
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final program in [
                          'All',
                          'Computer Science',
                          'Digital Design',
                          'Data Science',
                          'Business Management',
                        ])
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                program == 'All'
                                    ? c.t('All students', 'Tous')
                                    : program,
                              ),
                              selected: _program == program,
                              onSelected: (_) =>
                                  setState(() => _program = program),
                              showCheckmark: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${students.length} ${c.t('students', 'étudiants')}',
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.sort_by_alpha_rounded, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          c.t('Surname A–Z', 'Nom A–Z'),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: students.isEmpty
                  ? EmptyState(
                      icon: Icons.person_search_outlined,
                      title: c.t('No students found', 'Aucun étudiant trouvé'),
                      message: c.t(
                        'Try another name or choose a different program.',
                        'Essayez un autre nom ou une autre filière.',
                      ),
                      action: OutlinedButton(
                        onPressed: () {
                          _search.clear();
                          setState(() => _program = 'All');
                        },
                        child: Text(
                          c.t('Clear filters', 'Effacer les filtres'),
                        ),
                      ),
                    )
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      key: const PageStorageKey('students-list'),
                      padding: pagePadding(context).copyWith(top: 0),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final letter = student.nom[0].toUpperCase();
                        final showLetter =
                            index == 0 ||
                            students[index - 1].nom[0].toUpperCase() != letter;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showLetter)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 8,
                                  top: 8,
                                ),
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Dismissible(
                                key: ValueKey('dismiss-${student.id}'),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 24),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                onDismissed: (_) {
                                  c.deleteStudent(student.id);
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${student.prenom} ${c.t('removed from directory', 'retiré de l’annuaire')}',
                                        ),
                                        action: SnackBarAction(
                                          label: c.t('Undo', 'Annuler'),
                                          onPressed: () =>
                                              c.restoreStudent(student),
                                        ),
                                      ),
                                    );
                                },
                                child: StudentCard(
                                  student: student,
                                  controller: c,
                                ),
                              ),
                            ),
                          ],
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
