import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/page_intro.dart';
import 'avatar_page.dart';
import 'card_page.dart';
import 'contacts_page.dart';
import 'icon_page.dart';
import 'listtile_page.dart';

class WidgetsLabPage extends StatelessWidget {
  const WidgetsLabPage({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final pages = <(IconData, String, String, Widget)>[
      (
        Icons.interests_outlined,
        'IconPage',
        'Sizes, service icons, Cupertino & interactions',
        const IconPage(),
      ),
      (
        Icons.account_circle_outlined,
        'AvatarPage',
        'Initials, assets, network images & fallbacks',
        const AvatarPage(),
      ),
      (
        Icons.dashboard_outlined,
        'CardPage',
        'Elevated, filled and outlined course cards',
        CardPage(controller: controller),
      ),
      (
        Icons.view_list_outlined,
        'ListTilePage',
        'Selection, switches, checkboxes & dividers',
        ListTilePage(controller: controller),
      ),
      (
        Icons.contacts_outlined,
        'ContactsPage',
        'The complete student-directory mini-project',
        ContactsPage(controller: controller),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Widgets Lab')),
      body: ListView(
        padding: pagePadding(context),
        children: [
          PageIntro(
            eyebrow: 'MUNDIAPOLIS / 2ACINFO',
            title: controller.t(
              'The building blocks.',
              'Les briques de l’application.',
            ),
            subtitle: controller.t(
              'Five hands-on demonstrations. Every required widget, easy to find.',
              'Cinq démonstrations pratiques. Tous les widgets du TP, faciles à retrouver.',
            ),
          ),
          for (var i = 0; i < pages.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: ValueKey('lab-${pages[i].$2}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => pages[i].$4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        IconTile(
                          icon: pages[i].$1,
                          color: i.isEven ? AppColors.blue : AppColors.purple,
                          size: 48,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pages[i].$2,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pages[i].$3,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '0${i + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          const Text(
            'TP Flutter Widgets · Icon · CircleAvatar · Card · ListTile',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
