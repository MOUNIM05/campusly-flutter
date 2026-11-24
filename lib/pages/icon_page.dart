import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoIcons;
import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../widgets/page_intro.dart';

class IconPage extends StatelessWidget {
  const IconPage({super.key});
  @override
  Widget build(BuildContext context) {
    const services = <(IconData, String)>[
      (Icons.schedule_rounded, 'Timetable'),
      (Icons.workspace_premium_outlined, 'Grades'),
      (Icons.local_library_outlined, 'Library'),
      (Icons.chat_bubble_outline_rounded, 'Messaging'),
      (Icons.auto_stories_outlined, 'Courses'),
      (Icons.calendar_month_outlined, 'Calendar'),
      (Icons.notifications_none_rounded, 'Notifications'),
      (Icons.support_agent_rounded, 'Student services'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('IconPage')),
      body: ListView(
        padding: pagePadding(context),
        children: [
          const PageIntro(
            eyebrow: 'WIDGETS LAB / 01',
            title: 'Little symbols.\nClear meaning.',
            subtitle: 'Icon communicates a meaning. IconButton adds an action.',
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _example(Icons.home_rounded, 'Home', 24),
                  _example(Icons.favorite_rounded, 'Favorite', 40),
                  _example(Icons.school_rounded, 'School', 64),
                ],
              ),
            ),
          ),
          const SectionHeading(title: 'At your service'),
          LayoutBuilder(
            builder: (context, constraints) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 122,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) => Card.filled(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      services[index].$1,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                      semanticLabel: services[index].$2,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      services[index].$2,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SectionHeading(title: 'Give an icon a purpose'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A touch of Cupertino',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Tap the bell to try IconButton.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('icon-demo-button'),
                    tooltip: 'Try the Cupertino bell',
                    onPressed: () => showFeedback(context, 'Icône cliquée'),
                    icon: const Icon(
                      CupertinoIcons.bell,
                      size: 28,
                      color: AppColors.blue,
                      semanticLabel: 'Cupertino notification bell',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _example(IconData icon, String label, double size) => Column(
    children: [
      Icon(
        icon,
        size: size,
        color: AppColors.blue,
        semanticLabel: '$label icon, size $size',
      ),
      const SizedBox(height: 12),
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
      const SizedBox(height: 4),
      Text('${size.toInt()} px', style: const TextStyle(fontSize: 10)),
    ],
  );
}
