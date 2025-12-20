import 'package:cellular_automata/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/simulation_provider.dart';
import 'models/state_definition.dart';
import 'models/transition_rule.dart';
import 'screens/home_screen.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultStates = [
      StateDefinition(name: 'Dead', color: Colors.white),
      StateDefinition(name: 'Alive', color: Colors.black),
    ];

    // Conway's Game of Life rules:
    // Alive (state 1) survives if 2 or 3 neighbors are alive
    // Dead (state 0) becomes alive if exactly 3 neighbors are alive
    final defaultRules = [
      TransitionRule(
        fromState: 1,
        toState: 0,
        neighborCounts: {
          1: [0, 1, 4, 5, 6, 7, 8]
        },
      ),
      TransitionRule(
        fromState: 0,
        toState: 1,
        neighborCounts: {
          1: [3]
        },
      ),
    ];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => SimulationProvider(
            rows: 20,
            cols: 20,
            states: defaultStates,
            rules: defaultRules,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('pl'),
              Locale('es'),
            ],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
