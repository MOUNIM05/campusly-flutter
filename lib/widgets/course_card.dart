import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../models/cours.dart';
import '../pages/course_details_page.dart';
import '../theme/app_theme.dart';
import 'custom_avatar.dart';
import 'page_intro.dart';

Color courseColor(String category) => switch (category) {
  'Design' => AppColors.purple,
  'Data' => const Color(0xFF078F83),
  'Business' => const Color(0xFFB27522),
  _ => AppColors.blue,
};

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, required this.controller});
  final Cours course;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final registered = controller.isRegistered(course.id);
    final accent = courseColor(course.categorie);
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final teacherName = course.enseignant.replaceFirst(
      RegExp(r'^(Dr\.|Prof\.)\s*'),
      '',
    );
    return Card(
      elevation: 4,
      shadowColor: AppColors.navy.withValues(alpha: .10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: registered
              ? AppColors.turquoise.withValues(alpha: .45)
              : dark
              ? Colors.white.withValues(alpha: .08)
              : const Color(0xFFE9EDF5),
        ),
      ),
      child: InkWell(
        onTap: () =>
            showFeedback(context, '${course.titre} · ${course.enseignant}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  course.image,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stack) => Container(
                    height: 150,
                    color: accent.withValues(alpha: .15),
                    child: const Center(
                      child: Icon(Icons.school_outlined, size: 42),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xA6101B35)],
                        stops: [.35, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .96),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.categorie.toUpperCase(),
                      style: TextStyle(
                        color: accent,
                        fontSize: 9,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 13,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.view_module_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${course.modules.length} ${controller.t('learning modules', 'modules de formation')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (registered)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Semantics(
                      label: controller.t('Registered course', 'Cours inscrit'),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.turquoise,
                        child: Icon(
                          Icons.check_rounded,
                          color: AppColors.navy,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.titre, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, height: 1.65),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      CustomAvatar(
                        name: teacherName,
                        radius: 16,
                        color: accent,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.t('COURSE INSTRUCTOR', 'ENSEIGNANT'),
                              style: const TextStyle(
                                fontSize: 8,
                                letterSpacing: .8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course.enseignant,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _CourseMeta(
                        icon: Icons.schedule_rounded,
                        label: course.duree,
                        accent: accent,
                      ),
                      _CourseMeta(
                        icon: Icons.signal_cellular_alt_rounded,
                        label: course.niveau,
                        accent: accent,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => CourseDetailsPage(
                                course: course,
                                controller: controller,
                              ),
                            ),
                          ),
                          child: Text(controller.t('Details', 'Détails')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Tooltip(
                          message: registered
                              ? controller.t(
                                  'Cancel registration',
                                  'Annuler l’inscription',
                                )
                              : controller.t(
                                  'Register for this course',
                                  'S’inscrire à ce cours',
                                ),
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: registered
                                  ? AppColors.turquoise.withValues(alpha: .14)
                                  : theme.colorScheme.primary,
                              foregroundColor: registered
                                  ? dark
                                        ? AppColors.turquoise
                                        : const Color(0xFF078F83)
                                  : theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                            ),
                            onPressed: () {
                              controller.toggleRegistration(course.id);
                              showFeedback(
                                context,
                                controller.isRegistered(course.id)
                                    ? controller.t(
                                        'You’re registered for ${course.titre}',
                                        'Inscription confirmée : ${course.titre}',
                                      )
                                    : controller.t(
                                        'Registration cancelled',
                                        'Inscription annulée',
                                      ),
                              );
                            },
                            icon: Icon(
                              registered
                                  ? Icons.check_rounded
                                  : Icons.add_rounded,
                              size: 16,
                            ),
                            label: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: Text(
                                registered
                                    ? controller.t('Enrolled', 'Inscrit')
                                    : controller.t('Register', 'S’inscrire'),
                                key: ValueKey(registered),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseMeta extends StatelessWidget {
  const _CourseMeta({
    required this.icon,
    required this.label,
    required this.accent,
  });
  final IconData icon;
  final String label;
  final Color accent;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: accent.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    ),
  );
}
