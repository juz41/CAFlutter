import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../models/cell.dart';
import '../models/state_definition.dart';
import '../models/transition_rule.dart';

class SimulationProvider extends ChangeNotifier {
  int rows;
  int cols;

  late List<List<Cell>> grid;

  List<StateDefinition> states;
  List<TransitionRule> rules;

  bool isRunning = false;
  Duration stepInterval = const Duration(milliseconds: 150);
  Timer? _timer;

  SimulationProvider({
    required this.rows,
    required this.cols,
    required this.states,
    required this.rules,
  }) {
    _initGrid();
  }

  void _initGrid() {
    grid = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));
  }

  void toggleCell(int row, int col) {
    grid[row][col].state = (grid[row][col].state + 1) % states.length;
    notifyListeners();
  }

  void clear() {
    for (var r in grid) {
      for (var c in r) {
        c.state = 0;
      }
    }
    notifyListeners();
  }

  void start() {
    if (isRunning) return;
    isRunning = true;
    _timer = Timer.periodic(stepInterval, (_) => step());
    notifyListeners();
  }

  void pause() {
    isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    pause();
    clear();
  }

  void toggleRunning() {
    if (isRunning) {
      pause();
    } else {
      start();
    }
  }


  void step() {
    final newGrid = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cell = grid[r][c];
        final neighborCounts = _countNeighborStates(r, c);

        TransitionRule? rule;
        for (var r in rules) {
          if (r.fromState == cell.state && r.applies(neighborCounts)) {
            rule = r;
            break;
          }
        }

        newGrid[r][c].state = rule?.toState ?? cell.state;
      }
    }

    grid = newGrid;
    notifyListeners();
  }

  Map<int, int> _countNeighborStates(int r, int c) {
    Map<int, int> counts = {};
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        int nr = r + dr;
        int nc = c + dc;
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
          int s = grid[nr][nc].state;
          counts[s] = (counts[s] ?? 0) + 1;
        }
      }
    }
    return counts;
  }

  void resizeGrid(int newRows, int newCols) {
    rows = newRows;
    cols = newCols;
    _initGrid();
    notifyListeners();
  }

  void addState(String name, Color color) {
    states.add(StateDefinition(name: name, color: color));
    notifyListeners();
  }

  void updateStateColor(int stateIndex, Color color) {
    if (stateIndex < 0 || stateIndex >= states.length) return;
    states[stateIndex].color = color;
    notifyListeners();
  }

  void addRule(TransitionRule rule) {
    rules.add(rule);
    notifyListeners();
  }

  void removeRule(TransitionRule rule) {
    rules.remove(rule);
    notifyListeners();
  }

  Color getCellColor(int stateIndex) {
    return states[stateIndex].color;
  }

  void setInterval(Duration interval) {
    stepInterval = interval;
    if (isRunning) {
      _timer?.cancel();
      _timer = Timer.periodic(stepInterval, (_) => step());
    }
    notifyListeners();
  }

  void randomize() {
    final rng = Random();
    for (var row in grid) {
      for (var cell in row) {
        cell.state = rng.nextInt(states.length);
      }
    }
    notifyListeners();
  }

  void removeStateAt(int index) {
    // Remove the state
    states.removeAt(index);

    // Remove rules that reference the deleted state
    rules.removeWhere((r) => r.fromState == index || r.toState == index);

    // Shift remaining rules down
    rules = rules.map((r) {
      if (r.fromState > index || r.toState > index || r.neighborCounts.keys.any((k) => k == index)) {
        return TransitionRule(
          fromState: r.fromState > index ? r.fromState - 1 : r.fromState,
          toState: r.toState > index ? r.toState - 1 : r.toState,
          neighborCounts: {
            for (var entry in r.neighborCounts.entries)
              if (entry.key != index)
                (entry.key > index ? entry.key - 1 : entry.key): entry.value
          },
        );
      } else {
        return r;
      }
    }).toList();

    clear();

    notifyListeners();
  }

}
