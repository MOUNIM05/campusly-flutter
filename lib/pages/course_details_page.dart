import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../models/cours.dart';
import '../widgets/course_card.dart';
import '../widgets/page_intro.dart';

class CourseDetailsPage extends StatelessWidget {
  const CourseDetailsPage({
    super.key,
    required this.course,
    required this.controller,
  });
  final Cours course;
  final AppController controller;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: Text(controller.t('Course details', 'Détails du cours')),
      ),
      body: SingleChildScrollView(
        padding: pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    course.image,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stack) => const SizedBox(
                      height: 220,
                      child: Icon(Icons.school_outlined, size: 60),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PageIntro(
                  eyebrow: course.categorie,
                  title: course.titre,
                  subtitle: course.description,
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconTile(
                          icon: Icons.person_outline_rounded,
                          color: courseColor(course.categorie),
                        ),
                        title: Text(course.enseignant),
                        subtitle: Text(
                          controller.t('Course instructor', 'Enseignant'),
                        ),
                      ),
                      const Divider(indent: 70),
                      ListTile(
                        leading: const IconTile(icon: Icons.schedule_rounded),
                        title: Text('${course.duree} · ${course.niveau}'),
                        subtitle: Text(
                          controller.t(
                            'Self-paced · On campus',
                            'À votre rythme · Sur le campus',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SectionHeading(
                  title: controller.t(
                    'What you’ll learn',
                    'Ce que vous allez apprendre',
                  ),
                ),
                for (var i = 0; i < course.modules.length; i++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(course.modules[i]),
                  ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    controller.toggleRegistration(course.id);
                    showFeedback(
                      context,
                      controller.isRegistered(course.id)
                          ? controller.t(
                              'Registration confirmed. Welcome aboard!',
                              'Inscription confirmée. Bienvenue !',
                            )
                          : controller.t(
                              'Registration cancelled',
                              'Inscription annulée',
                            ),
                    );
                  },
                  icon: Icon(
                    controller.isRegistered(course.id)
                        ? Icons.check_circle_outline_rounded
                        : Icons.add_rounded,
                  ),
                  label: Text(
                    controller.isRegistered(course.id)
                        ? controller.t(
                            'Cancel registration',
                            'Annuler l’inscription',
                          )
                        : controller.t(
                            'Register for this course',
                            'S’inscrire à ce cours',
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  controller.t(
                    'Demo registration is saved on this device. No real university enrollment.',
                    'Inscription de démonstration enregistrée sur cet appareil.',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
