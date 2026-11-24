import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../models/etudiant.dart';
import '../pages/student_details_page.dart';
import '../theme/app_theme.dart';
import 'custom_avatar.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.controller,
  });
  final Etudiant student;
  final AppController controller;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: CustomAvatar(
        name: student.nomComplet,
        photoUrl: student.photoUrl,
        radius: 25,
      ),
      title: Text(
        student.nomComplet,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          student.email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11),
        ),
      ),
      trailing: IconButton(
        key: ValueKey('favorite-${student.id}'),
        tooltip: student.favori
            ? controller.t('Remove favorite', 'Retirer des favoris')
            : controller.t('Add favorite', 'Ajouter aux favoris'),
        onPressed: () => controller.toggleFavorite(student.id),
        icon: Icon(
          student.favori ? Icons.star_rounded : Icons.star_outline_rounded,
          color: student.favori ? const Color(0xFFE7A629) : AppColors.secondary,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) =>
              StudentDetailsPage(studentId: student.id, controller: controller),
        ),
      ),
    ),
  );
}
