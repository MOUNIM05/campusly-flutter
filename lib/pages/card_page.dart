import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../data/courses_data.dart';
import '../widgets/course_card.dart';
import '../widgets/page_intro.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('CardPage')),
    body: ListenableBuilder(
      listenable: controller,
      builder: (context, _) => ListView(
        padding: pagePadding(context),
        children: [
          const PageIntro(
            eyebrow: 'WIDGETS LAB / 03',
            title: 'Good things\ncome in cards.',
            subtitle:
                'Three Material 3 surfaces, one consistent design language.',
          ),
          Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: _demo(
              context,
              'Elevated card',
              'elevation: 4 · a shadow separates the surface',
              Icons.layers_outlined,
            ),
          ),
          const SizedBox(height: 18),
          Card.filled(
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: _demo(
              context,
              'Filled card',
              'Card.filled · a tinted surface without a shadow',
              Icons.format_color_fill_rounded,
            ),
          ),
          const SizedBox(height: 18),
          Card.outlined(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            child: _demo(
              context,
              'Outlined card',
              'Card.outlined · a visible border defines the surface',
              Icons.crop_square_rounded,
            ),
          ),
          const SectionHeading(title: 'From a widget to a real course'),
          CourseCard(course: coursesData.first, controller: controller),
          const SizedBox(height: 22),
          const Text(
            'Image.asset · height: 150 · BoxFit.cover\nCard → InkWell → content\nclipBehavior: Clip.antiAlias keeps both the image and ripple inside rounded corners.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
  Widget _demo(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) => InkWell(
    onTap: () => showFeedback(context, '$title clicked'),
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          IconTile(icon: icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
