// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Automaty Komórkowe';

  @override
  String get menu => 'Menu';

  @override
  String get gridSize => 'Rozmiar siatki';

  @override
  String get rows => 'Wiersze';

  @override
  String get columns => 'Kolumny';

  @override
  String get resizeGrid => 'Zmień rozmiar';

  @override
  String get editRules => 'Edytuj reguły / stany';

  @override
  String get exportPng => 'Eksportuj PNG';

  @override
  String get exportGif => 'Eksportuj GIF';

  @override
  String get steps => 'Kroki';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pauza';

  @override
  String get step => 'Krok';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Wyczyść';

  @override
  String get speed => 'Prędkość';

  @override
  String get randomize => 'Losowa siatka';

  @override
  String savedImage(Object path) {
    return 'Zapisano obraz w $path';
  }

  @override
  String savedGif(Object path) {
    return 'Zapisano GIF w $path';
  }

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get lightMode => 'Tryb jasny';

  @override
  String get multiStateRuleEditor => 'Edytor reguł wielostanowych';

  @override
  String get states => 'Stany';

  @override
  String get createRule => 'Utwórz regułę';

  @override
  String get fromState => 'Stan początkowy';

  @override
  String get toState => 'Stan końcowy';

  @override
  String get neighborCounts => 'Liczba sąsiadów';

  @override
  String get addNewState => 'Dodaj nowy stan';

  @override
  String get stateName => 'Nazwa stanu';

  @override
  String get cancel => 'Anuluj';

  @override
  String get add => 'Dodaj';

  @override
  String get editState => 'Edytuj stan';

  @override
  String get name => 'Nazwa';

  @override
  String get removeState => 'Usuń stan';

  @override
  String get save => 'Zapisz';

  @override
  String get existingRules => 'Istniejące reguły';

  @override
  String get addRule => 'Dodaj regułę';
}
