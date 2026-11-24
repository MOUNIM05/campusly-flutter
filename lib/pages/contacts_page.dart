import 'package:material_ui/material_ui.dart';

import '../controllers/app_controller.dart';
import 'students_page.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const Text('ContactsPage'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(child: Text('★ ${controller.favorites.length}')),
          ),
        ],
      ),
      body: StudentsPage(controller: controller),
    ),
  );
}
