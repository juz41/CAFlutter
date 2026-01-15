import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../models/cell.dart';
import '../models/transition_rule.dart';
import '../models/state_definition.dart';
import '../providers/simulation_provider.dart';

class GifIsolateRequest {
  final List<List<Cell>> initialGrid;
  final List<StateDefinition> states;
  final List<TransitionRule> rules;
  final int steps;
  final int cellSize;
  final int intervalMs;
  final SendPort replyTo;

  GifIsolateRequest({
    required this.initialGrid,
    required this.states,
    required this.rules,
    required this.steps,
    required this.cellSize,
    required this.intervalMs,
    required this.replyTo,
  });
}

void gifIsolateEntry(GifIsolateRequest request) {
  final rows = request.initialGrid.length;
  final cols = request.initialGrid[0].length;

  final sim = SimulationProvider(
    rows: rows,
    cols: cols,
    states: request.states,
    rules: request.rules,
  );

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      sim.grid[r][c].state = request.initialGrid[r][c].state;
    }
  }

  final frames = <img.Image>[];

  for (int i = 0; i < request.steps; i++) {
    final image = img.Image(
        width: cols * request.cellSize, height: rows * request.cellSize);

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final colorInt = sim.states[sim.grid[r][c].state].color.toARGB32();
        final pixelColor = img.ColorRgb8(
          (colorInt >> 16) & 0xFF, // Red
          (colorInt >> 8) & 0xFF, // Green
          colorInt & 0xFF, // Blue
        );

        for (int dy = 0; dy < request.cellSize; dy++) {
          for (int dx = 0; dx < request.cellSize; dx++) {
            image.setPixel(c * request.cellSize + dx, r * request.cellSize + dy,
                pixelColor);
          }
        }
      }
    }

    frames.add(image);

    sim.step();
  }

  final encoder = img.GifEncoder(repeat: 0);
  for (var frame in frames) {
    encoder.addFrame(frame, duration: request.intervalMs);
  }

  final gifBytes = Uint8List.fromList(encoder.finish()!);

  request.replyTo.send(gifBytes);
}
