import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';

class CampusBottomNavigation extends StatelessWidget {
  const CampusBottomNavigation({
    super.key,
    required this.index,
    required this.onChanged,
    required this.controller,
  });
  final int index;
  final ValueChanged<int> onChanged;
  final AppController controller;
  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: index,
    onDestinationSelected: onChanged,
    destinations: [
      NavigationDestination(
        icon: const Icon(Icons.grid_view_outlined),
        selectedIcon: const Icon(Icons.grid_view_rounded),
        label: controller.t('Home', 'Accueil'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.people_outline_rounded),
        selectedIcon: const Icon(Icons.people_rounded),
        label: controller.t('Students', 'Étudiants'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.auto_stories_outlined),
        selectedIcon: const Icon(Icons.auto_stories_rounded),
        label: controller.t('Courses', 'Cours'),
      ),
      NavigationDestination(
        icon: Badge(
          isLabelVisible: controller.favorites.isNotEmpty,
          label: Text('${controller.favorites.length}'),
          child: const Icon(Icons.star_outline_rounded),
        ),
        selectedIcon: const Icon(Icons.star_rounded),
        label: controller.t('Favorites', 'Favoris'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.tune_rounded),
        label: controller.t('Settings', 'Réglages'),
      ),
    ],
  );
}
