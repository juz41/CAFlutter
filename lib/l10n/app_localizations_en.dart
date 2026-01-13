// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cellular Automata';

  @override
  String get menu => 'Menu';

  @override
  String get gridSize => 'Grid Size';

  @override
  String get rows => 'Rows';

  @override
  String get columns => 'Columns';

  @override
  String get resizeGrid => 'Resize Grid';

  @override
  String get editRules => 'Edit Rules / States';

  @override
  String get exportPng => 'Export PNG';

  @override
  String get exportGif => 'Export GIF';

  @override
  String get steps => 'Steps';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get step => 'Step';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Clear';

  @override
  String get speed => 'Speed';

  @override
  String get randomize => 'Randomize Grid';

  @override
  String savedImage(Object path) {
    return 'Saved image to $path';
  }

  @override
  String savedGif(Object path) {
    return 'Saved GIF to $path';
  }

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get multiStateRuleEditor => 'Multi-State Rule Editor';

  @override
  String get states => 'States:';

  @override
  String get createRule => 'Create Rule:';

  @override
  String get fromState => 'From State';

  @override
  String get toState => 'To State';

  @override
  String get neighborCounts => 'Neighbor Counts:';

  @override
  String get addNewState => 'Add New State';

  @override
  String get stateName => 'State Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get editState => 'Edit State';

  @override
  String get name => 'Name';

  @override
  String get removeState => 'Remove State';

  @override
  String get save => 'Save';

  @override
  String get existingRules => 'Existing Rules:';

  @override
  String get addRule => 'Add Rule';

  @override
  String get importRules => 'Import rules';

  @override
  String get exportRules => 'Export rules';
}
