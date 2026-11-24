import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/students_data.dart';
import '../models/etudiant.dart';

/// Shared source of truth. Local filters and selections use setState.
class AppController extends ChangeNotifier {
  AppController(this._preferences) {
    final favoriteIds = _preferences.getStringList('favorites') ?? [];
    final deletedIds = _preferences.getStringList('deleted') ?? [];
    _students = studentsData
        .where((s) => !deletedIds.contains(s.id))
        .map((s) => s.copyWith(favori: favoriteIds.contains(s.id)))
        .toList();
    _darkMode = _preferences.getBool('darkMode') ?? false;
    _notifications = _preferences.getBool('notifications') ?? true;
    _updates = _preferences.getBool('updates') ?? false;
    _language = _preferences.getString('language') == 'fr' ? 'fr' : 'en';
    _registered = (_preferences.getStringList('registered') ?? []).toSet();
  }
  final SharedPreferences _preferences;
  late List<Etudiant> _students;
  late Set<String> _registered;
  late bool _darkMode;
  late bool _notifications;
  late bool _updates;
  late String _language;
  bool _signedIn = true;
  String? _storageError;
  Future<void> _pendingSave = Future<void>.value();
  List<Etudiant> get students => List.unmodifiable(_students);
  List<Etudiant> get favorites => _students.where((s) => s.favori).toList();
  bool get darkMode => _darkMode;
  bool get notifications => _notifications;
  bool get updates => _updates;
  bool get signedIn => _signedIn;
  String get language => _language;
  String? get storageError => _storageError;
  int get registeredCount => _registered.length;
  Future<void> get saved => _pendingSave;
  String t(String en, String fr) => _language == 'fr' ? fr : en;
  bool isRegistered(String id) => _registered.contains(id);
  Etudiant studentById(String id) => _students.firstWhere(
    (s) => s.id == id,
    orElse: () => studentsData.firstWhere((s) => s.id == id),
  );
  void toggleFavorite(String id) {
    _students = _students
        .map((s) => s.id == id ? s.copyWith(favori: !s.favori) : s)
        .toList();
    _changed();
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    _changed();
  }

  void restoreStudent(Etudiant student) {
    if (_students.every((s) => s.id != student.id)) {
      _students.add(student);
      _changed();
    }
  }

  void toggleRegistration(String id) {
    if (!_registered.remove(id)) {
      _registered.add(id);
    }
    _changed();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    _changed();
  }

  void setNotifications(bool value) {
    _notifications = value;
    _changed();
  }

  void setUpdates(bool value) {
    _updates = value;
    _changed();
  }

  void setLanguage(String value) {
    if (value == 'en' || value == 'fr') {
      _language = value;
      _changed();
    }
  }

  void signOut() {
    _signedIn = false;
    notifyListeners();
  }

  void signIn() {
    _signedIn = true;
    notifyListeners();
  }

  // Serialize writes so older state cannot overwrite newer state after rapid taps.
  void _changed() {
    notifyListeners();
    _pendingSave = _pendingSave.then((_) => _save());
    unawaited(_pendingSave);
  }

  Future<void> _save() async {
    try {
      final results = await Future.wait([
        _preferences.setStringList(
          'favorites',
          favorites.map((s) => s.id).toList(),
        ),
        _preferences.setStringList(
          'deleted',
          studentsData
              .where((s) => _students.every((x) => x.id != s.id))
              .map((s) => s.id)
              .toList(),
        ),
        _preferences.setStringList('registered', _registered.toList()),
        _preferences.setBool('darkMode', _darkMode),
        _preferences.setBool('notifications', _notifications),
        _preferences.setBool('updates', _updates),
        _preferences.setString('language', _language),
      ]);
      if (results.any((success) => !success)) {
        throw StateError('Local storage unavailable');
      }
      if (_storageError != null) {
        _storageError = null;
        notifyListeners();
      }
    } catch (_) {
      _storageError =
          'Your changes are active, but could not be saved on this device.';
      notifyListeners();
    }
  }
}
