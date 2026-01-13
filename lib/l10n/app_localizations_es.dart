// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Autómatas Celulares';

  @override
  String get menu => 'Menú';

  @override
  String get gridSize => 'Tamaño de la cuadrícula';

  @override
  String get rows => 'Filas';

  @override
  String get columns => 'Columnas';

  @override
  String get resizeGrid => 'Cambiar tamaño';

  @override
  String get editRules => 'Editar reglas / estados';

  @override
  String get exportPng => 'Exportar PNG';

  @override
  String get exportGif => 'Exportar GIF';

  @override
  String get steps => 'Pasos';

  @override
  String get start => 'Iniciar';

  @override
  String get pause => 'Pausa';

  @override
  String get step => 'Paso';

  @override
  String get reset => 'Restablecer';

  @override
  String get clear => 'Borrar';

  @override
  String get speed => 'Velocidad';

  @override
  String get randomize => 'Aleatorizar cuadrícula';

  @override
  String savedImage(Object path) {
    return 'Imagen guardada en $path';
  }

  @override
  String savedGif(Object path) {
    return 'GIF guardado en $path';
  }

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get multiStateRuleEditor => 'Editor de Reglas Multistado';

  @override
  String get states => 'Estados:';

  @override
  String get createRule => 'Crear Regla:';

  @override
  String get fromState => 'Desde Estado';

  @override
  String get toState => 'Hasta Estado';

  @override
  String get neighborCounts => 'Conteos de Vecinos:';

  @override
  String get addNewState => 'Agregar Nuevo Estado';

  @override
  String get stateName => 'Nombre del Estado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Agregar';

  @override
  String get editState => 'Editar Estado';

  @override
  String get name => 'Nombre';

  @override
  String get removeState => 'Eliminar Estado';

  @override
  String get save => 'Guardar';

  @override
  String get existingRules => 'Reglas Existentes:';

  @override
  String get addRule => 'Agregar Regla';

  @override
  String get importRules => 'Importes rules';

  @override
  String get exportRules => 'Exportes rules';
}
