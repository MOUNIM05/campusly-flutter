import 'package:campusly/controllers/app_controller.dart';
import 'package:campusly/widgets/custom_avatar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('initiales handles multiword names, whitespace, empty and Unicode', () {
    expect(initiales('Sara El Amrani'), 'SE');
    expect(initiales('  Yasmine   Alaoui  '), 'YA');
    expect(initiales('Amine'), 'A');
    expect(initiales(''), '');
    expect(initiales('Émilie Dupont'), 'ÉD');
  });

  test('favorites, deletions and undo stay synchronized and persist', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = AppController(prefs);
    expect(controller.students.length, 10);
    controller.toggleFavorite('s2');
    final favorite = controller.studentById('s2');
    expect(controller.favorites.single.id, 's2');
    controller.deleteStudent('s2');
    expect(controller.students.length, 9);
    expect(controller.favorites, isEmpty);
    controller.restoreStudent(favorite);
    controller.restoreStudent(favorite);
    expect(controller.students.length, 10);
    expect(controller.favorites.single.id, 's2');
    await controller.saved;
    final reloaded = AppController(prefs);
    expect(reloaded.favorites.single.id, 's2');
    controller.deleteStudent('s2');
    await controller.saved;
    expect(AppController(prefs).students.length, 9);
    expect(AppController(prefs).favorites, isEmpty);
    controller.dispose();
    reloaded.dispose();
  });

  test('registrations and preferences survive controller reload', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = AppController(prefs);
    controller.toggleRegistration('c1');
    controller.toggleRegistration('c2');
    controller.toggleRegistration('c2');
    controller.setDarkMode(true);
    controller.setNotifications(false);
    controller.setUpdates(true);
    controller.setLanguage('fr');
    controller.setLanguage('unsupported');
    await controller.saved;
    final reloaded = AppController(prefs);
    expect(reloaded.isRegistered('c1'), isTrue);
    expect(reloaded.isRegistered('c2'), isFalse);
    expect(reloaded.registeredCount, 1);
    expect(reloaded.darkMode, isTrue);
    expect(reloaded.notifications, isFalse);
    expect(reloaded.updates, isTrue);
    expect(reloaded.language, 'fr');
    expect(reloaded.t('Home', 'Accueil'), 'Accueil');
    controller.signOut();
    expect(controller.signedIn, isFalse);
    controller.signIn();
    expect(controller.signedIn, isTrue);
    controller.dispose();
    reloaded.dispose();
  });
}
