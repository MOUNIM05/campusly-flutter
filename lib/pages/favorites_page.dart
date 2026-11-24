import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/page_intro.dart';
import '../widgets/student_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.controller,
    required this.onBrowse,
  });
  final AppController controller;
  final VoidCallback onBrowse;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final students = controller.favorites
        ..sort((a, b) => a.nom.compareTo(b.nom));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: pagePadding(context).copyWith(bottom: 0),
            child: PageIntro(
              eyebrow: controller.t(
                'Your inner circle',
                'Votre cercle de confiance',
              ),
              title: controller.t(
                'Keep your people close.',
                'Gardez le contact.',
              ),
              subtitle: controller.t(
                '${students.length} favorite students, one connected community.',
                '${students.length} étudiants favoris, une communauté connectée.',
              ),
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? EmptyState(
                    icon: Icons.star_outline_rounded,
                    title: controller.t(
                      'Your circle starts here',
                      'Vos favoris commencent ici',
                    ),
                    message: controller.t(
                      'Tap the star beside a classmate to keep their profile within reach.',
                      'Touchez l’étoile d’un étudiant pour retrouver son profil ici.',
                    ),
                    action: FilledButton.icon(
                      onPressed: onBrowse,
                      icon: const Icon(Icons.people_outline_rounded),
                      label: Text(
                        controller.t('Explore students', 'Voir les étudiants'),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: pagePadding(context).copyWith(top: 0),
                    itemCount: students.length,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: StudentCard(
                        student: students[index],
                        controller: controller,
                      ),
                    ),
                  ),
          ),
        ],
      );
    },
  );
}
