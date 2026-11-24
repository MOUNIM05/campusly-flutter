import 'package:campusly/controllers/app_controller.dart';
import 'package:campusly/main.dart';
import 'package:campusly/pages/avatar_page.dart';
import 'package:campusly/pages/card_page.dart';
import 'package:campusly/pages/contacts_page.dart';
import 'package:campusly/pages/icon_page.dart';
import 'package:campusly/pages/listtile_page.dart';
import 'package:campusly/pages/student_details_page.dart';
import 'package:campusly/widgets/custom_avatar.dart';
import 'package:campusly/widgets/course_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppController> mountApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final controller = AppController(await SharedPreferences.getInstance());
  await tester.pumpWidget(CampuslyApp(controller: controller));
  await tester.pumpAndSettle();
  addTearDown(controller.dispose);
  return controller;
}

Future<void> navigate(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('five navigation destinations and empty favorites work', (
    tester,
  ) async {
    await mountApp(tester);
    expect(find.text('Hello, Yasmine.'), findsOneWidget);
    for (final label in [
      'Students',
      'Courses',
      'Favorites',
      'Settings',
      'Home',
    ]) {
      await navigate(tester, label);
      expect(tester.takeException(), isNull);
    }
    await navigate(tester, 'Favorites');
    expect(find.text('Your circle starts here'), findsOneWidget);
    await tester.tap(find.text('Explore students'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('student-search')), findsOneWidget);
  });

  testWidgets('search, detail navigation and shared favorite count work', (
    tester,
  ) async {
    final c = await mountApp(tester);
    await navigate(tester, 'Students');
    await tester.enterText(
      find.byKey(const ValueKey('student-search')),
      'bEnNaNi',
    );
    await tester.pumpAndSettle();
    expect(find.text('Adam Bennani'), findsOneWidget);
    expect(find.text('Sara El Amrani'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('favorite-s2')));
    await tester.pumpAndSettle();
    expect(c.favorites.length, 1);
    final count = tester.widget<Chip>(
      find.byKey(const ValueKey('appbar-favorite-count')),
    );
    expect((count.label as Text).data, '1');
    await tester.tap(find.text('Adam Bennani'));
    await tester.pumpAndSettle();
    expect(find.byType(StudentDetailsPage), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is CircleAvatar && w.radius == 60),
      findsOneWidget,
    );
    expect(find.text('+212 6XX XXX 002'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await navigate(tester, 'Favorites');
    expect(find.text('Adam Bennani'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('favorite-s2')));
    await tester.pumpAndSettle();
    expect(find.text('Your circle starts here'), findsOneWidget);
    expect(c.favorites, isEmpty);
  });

  testWidgets('empty search and dismiss undo preserve a favorite', (
    tester,
  ) async {
    final c = await mountApp(tester);
    c.toggleFavorite('s2');
    await navigate(tester, 'Students');
    final search = find.byKey(const ValueKey('student-search'));
    await tester.enterText(search, 'no-such-student');
    await tester.pumpAndSettle();
    expect(find.text('No students found'), findsOneWidget);
    await tester.enterText(search, 'Adam');
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const ValueKey('dismiss-s2')),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    expect(c.students.length, 9);
    expect(c.favorites, isEmpty);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(c.students.length, 10);
    expect(c.favorites.single.id, 's2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('course card feedback, details, enrollment and filters work', (
    tester,
  ) async {
    final c = await mountApp(tester);
    await navigate(tester, 'Courses');
    await tester.tap(find.text('Build with Flutter').first);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    await tester.ensureVisible(find.text('Register').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register').first);
    await tester.pumpAndSettle();
    expect(c.isRegistered('c1'), isTrue);
    await tester.tap(find.text('My courses'));
    await tester.pumpAndSettle();
    expect(find.text('Build with Flutter'), findsOneWidget);
    expect(find.text('The art of UI/UX'), findsNothing);
    await tester.ensureVisible(find.text('Details').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Details').first);
    await tester.pumpAndSettle();
    expect(find.text('What you’ll learn'), findsOneWidget);
    await tester.ensureVisible(find.text('Cancel registration'));
    await tester.tap(find.text('Cancel registration'));
    await tester.pumpAndSettle();
    expect(c.isRegistered('c1'), isFalse);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Room for something new'), findsOneWidget);
  });

  testWidgets('course catalog search, sorting and empty state work', (
    tester,
  ) async {
    await mountApp(tester);
    await navigate(tester, 'Courses');
    final search = find.byKey(const ValueKey('course-search'));
    await tester.enterText(search, 'NaCiRi');
    await tester.pumpAndSettle();
    expect(find.text('2 courses'), findsOneWidget);
    expect(find.text('The art of UI/UX'), findsOneWidget);
    expect(find.text('Build with Flutter'), findsNothing);
    await tester.tap(find.byTooltip('Clear course search'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Development'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sort courses'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shortest first'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<CourseCard>(find.byType(CourseCard).first).course.id,
      'c5',
    );
    await tester.tap(find.byTooltip('Sort courses'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Title A–Z'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<CourseCard>(find.byType(CourseCard).first).course.id,
      'c1',
    );
    await tester.enterText(search, 'no-such-course');
    await tester.pumpAndSettle();
    expect(find.text('No courses found'), findsOneWidget);
    final clear = find.widgetWithText(OutlinedButton, 'Clear filters');
    await tester.ensureVisible(clear);
    await tester.pumpAndSettle();
    await tester.tap(clear);
    await tester.pumpAndSettle();
    expect(find.text('6 courses'), findsOneWidget);
    expect(tester.widget<TextField>(search).controller!.text, isEmpty);
    tester.view.physicalSize = const Size(320, 667);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(search, 'Python');
    await tester.pumpAndSettle();
    expect(
      tester.widget<CourseCard>(find.byType(CourseCard).first).course.id,
      'c3',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark mode changes theme, selection, language and logout work', (
    tester,
  ) async {
    final c = await mountApp(tester);
    await navigate(tester, 'Settings');
    await tester.ensureVisible(find.byKey(const ValueKey('dark-mode-switch')));
    await tester.tap(find.byKey(const ValueKey('dark-mode-switch')));
    await tester.pumpAndSettle();
    expect(c.darkMode, isTrue);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(
      Theme.of(tester.element(find.byType(NavigationBar))).brightness,
      Brightness.dark,
    );
    await tester.ensureVisible(find.byKey(const ValueKey('updates-checkbox')));
    await tester.tap(find.byKey(const ValueKey('updates-checkbox')));
    await tester.pumpAndSettle();
    expect(c.updates, isTrue);
    await tester.ensureVisible(find.byKey(const ValueKey('settings-language')));
    await tester.tap(find.byKey(const ValueKey('settings-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();
    expect(c.language, 'fr');
    expect(find.text('Accueil'), findsOneWidget);
    expect(
      tester
          .widget<ListTile>(find.byKey(const ValueKey('settings-language')))
          .selected,
      isTrue,
    );
    await tester.ensureVisible(find.byKey(const ValueKey('settings-logout')));
    await tester.tap(find.byKey(const ValueKey('settings-logout')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Rester'));
    await tester.pumpAndSettle();
    expect(c.signedIn, isTrue);
    await tester.tap(find.byKey(const ValueKey('settings-logout')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Déconnexion'));
    await tester.pumpAndSettle();
    expect(c.signedIn, isFalse);
    await tester.tap(find.byKey(const ValueKey('enter-campus')));
    await tester.pumpAndSettle();
    expect(c.signedIn, isTrue);
    expect(find.text('Bonjour, Yasmine.'), findsOneWidget);
  });

  testWidgets('all five lab pages are reachable and icon feedback is exact', (
    tester,
  ) async {
    await mountApp(tester);
    await tester.tap(find.byKey(const ValueKey('appbar-widgets-lab')));
    await tester.pumpAndSettle();
    final demos = <String, Type>{
      'IconPage': IconPage,
      'AvatarPage': AvatarPage,
      'CardPage': CardPage,
      'ListTilePage': ListTilePage,
      'ContactsPage': ContactsPage,
    };
    for (final demo in demos.entries) {
      final entry = find.byKey(ValueKey('lab-${demo.key}'));
      await tester.scrollUntilVisible(
        entry,
        160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(entry);
      await tester.pumpAndSettle();
      expect(find.byType(demo.value), findsOneWidget);
      if (demo.key == 'IconPage') {
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('icon-demo-button')),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(
          find.byKey(const ValueKey('icon-demo-button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('icon-demo-button')));
        await tester.pump();
        expect(find.text('Icône cliquée'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('missing and invalid avatar images fall back to initials', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              CustomAvatar(name: 'Sara El Amrani'),
              CustomAvatar(
                name: 'Adam Bennani',
                photoUrl: 'assets/not-found.jpg',
              ),
              CustomAvatar(
                name: 'Lina Idrissi',
                photoUrl: 'https://example.invalid/avatar.jpg',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    expect(find.text('SE'), findsOneWidget);
    expect(find.text('AB'), findsOneWidget);
    expect(find.text('LI'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('account, notification, privacy and help actions work', (
    tester,
  ) async {
    final c = await mountApp(tester);
    await navigate(tester, 'Settings');
    Future<void> openSetting(String id) async {
      final row = find.byKey(ValueKey('settings-$id'));
      await tester.ensureVisible(row);
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    }

    await openSetting('account');
    expect(find.text('Your student account'), findsOneWidget);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    await openSetting('notifications');
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(SwitchListTile),
      ),
    );
    await tester.pumpAndSettle();
    expect(c.notifications, isFalse);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await openSetting('privacy');
    expect(find.text('Your privacy matters'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await openSetting('help');
    await tester.tap(find.text('How do favorites work?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tap a star in the directory'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Widgets Lab'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('The building blocks.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    c.setUpdates(true);
    await navigate(tester, 'Home');
    expect(find.text('Your campus digest'), findsOneWidget);
    expect(
      find.text('Reminder: explore Widgets Lab before your presentation.'),
      findsNothing,
    );
    c.setNotifications(true);
    await tester.pumpAndSettle();
    expect(
      find.text('Reminder: explore Widgets Lab before your presentation.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('student search fits a small phone with the keyboard open', (
    tester,
  ) async {
    await mountApp(tester, size: const Size(320, 667));
    await navigate(tester, 'Students');
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('student-search')),
      'Adam',
    );
    await tester.pumpAndSettle();
    expect(find.text('Adam Bennani'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 800.0, 1440.0]) {
    testWidgets('all main screens fit at width $width', (tester) async {
      await mountApp(tester, size: Size(width, 1000));
      for (final label in [
        'Students',
        'Courses',
        'Favorites',
        'Settings',
        'Home',
      ]) {
        if (width < 1100) {
          await navigate(tester, label);
        } else {
          await tester.tap(find.widgetWithText(ListTile, label).first);
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull, reason: '$label at $width px');
      }
    });
  }
}
