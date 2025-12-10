import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/simulation_provider.dart';
import 'models/state_definition.dart';
import 'models/transition_rule.dart';
import 'screens/home_screen.dart';

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
        neighborCounts: {1: [0, 1, 4, 5, 6, 7, 8]},
      ),
      TransitionRule(
        fromState: 0,
        toState: 1,
        neighborCounts: {1: [3]},
      ),
    ];

    return ChangeNotifierProvider(
      create: (_) => SimulationProvider(
        rows: 20,
        cols: 20,
        states: defaultStates,
        rules: defaultRules,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cellular Automata',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
