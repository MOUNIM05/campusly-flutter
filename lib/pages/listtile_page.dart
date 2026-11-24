import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import 'settings_page.dart';

class ListTilePage extends StatelessWidget {
  const ListTilePage({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('ListTilePage')),
    body: SettingsPage(controller: controller, laboratory: true),
  );
}
