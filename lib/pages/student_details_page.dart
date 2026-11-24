import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_avatar.dart';
import '../widgets/page_intro.dart';

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({
    super.key,
    required this.studentId,
    required this.controller,
  });
  final String studentId;
  final AppController controller;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final student = controller.studentById(studentId);
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.t('Student profile', 'Profil étudiant')),
          actions: [
            IconButton(
              tooltip: controller.t('Toggle favorite', 'Modifier le favori'),
              onPressed: () => controller.toggleFavorite(studentId),
              icon: Icon(
                student.favori
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: student.favori ? const Color(0xFFE7A629) : null,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: pagePadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue.withValues(alpha: .10),
                          AppColors.turquoise.withValues(alpha: .07),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        CustomAvatar(
                          name: student.nomComplet,
                          photoUrl: student.photoUrl,
                          radius: 60,
                          online: true,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          student.nomComplet,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(student.filiere),
                        const SizedBox(height: 14),
                        const Chip(
                          avatar: Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: AppColors.blue,
                          ),
                          label: Text('Mundiapolis · 2ACINFO'),
                        ),
                      ],
                    ),
                  ),
                  SectionHeading(
                    title: controller.t(
                      'A little more about me',
                      'Mes informations',
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const IconTile(
                            icon: Icons.alternate_email_rounded,
                          ),
                          title: Text(
                            controller.t('Email address', 'Adresse e-mail'),
                          ),
                          subtitle: Text(student.email),
                          trailing: const Icon(Icons.copy_rounded, size: 18),
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: student.email),
                            );
                            if (context.mounted) {
                              showFeedback(
                                context,
                                controller.t(
                                  'Email copied to clipboard',
                                  'Adresse copiée',
                                ),
                              );
                            }
                          },
                        ),
                        const Divider(indent: 72),
                        ListTile(
                          leading: const IconTile(
                            icon: Icons.phone_outlined,
                            color: AppColors.turquoise,
                          ),
                          title: Text(controller.t('Telephone', 'Téléphone')),
                          subtitle: Text(student.telephone),
                        ),
                        const Divider(indent: 72),
                        ListTile(
                          leading: const IconTile(
                            icon: Icons.school_outlined,
                            color: AppColors.purple,
                          ),
                          title: Text(
                            controller.t('Academic program', 'Filière'),
                          ),
                          subtitle: Text(student.filiere),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: () => controller.toggleFavorite(studentId),
                    icon: Icon(
                      student.favori
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                    ),
                    label: Text(
                      student.favori
                          ? controller.t(
                              'Remove from favorites',
                              'Retirer des favoris',
                            )
                          : controller.t(
                              'Add to favorites',
                              'Ajouter aux favoris',
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    controller.t(
                      'Fictional profile for the university demonstration.',
                      'Profil fictif pour la démonstration universitaire.',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
