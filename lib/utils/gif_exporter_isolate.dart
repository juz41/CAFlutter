import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../providers/simulation_provider.dart';
import 'gif_isolate.dart';

class GifExporterIsolate {
  /// Export a GIF using the current simulation state
  Future<File> exportGif({
    required SimulationProvider simulation,
    int steps = 10,
    int cellSize = 20,
  }) async {
    // Prepare data for the isolate
    final receivePort = ReceivePort();
    final request = GifIsolateRequest(
      initialGrid: simulation.grid,
      states: simulation.states,
      rules: simulation.rules,
      steps: steps,
      cellSize: cellSize,
      intervalMs: simulation.stepInterval.inMilliseconds,
      replyTo: receivePort.sendPort,
    );

    // Spawn isolate
    await Isolate.spawn(gifIsolateEntry, request);

    // Wait for GIF bytes from isolate
    final gifBytes = await receivePort.first as Uint8List;
    receivePort.close();

    // Save GIF to file
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/automata_${DateTime.now().millisecondsSinceEpoch}.gif');
    await file.writeAsBytes(gifBytes);

    return file;
  }
}
