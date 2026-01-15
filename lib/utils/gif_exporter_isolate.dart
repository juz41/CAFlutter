import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../providers/simulation_provider.dart';
import 'gif_isolate.dart';

class GifExporterIsolate {
  Future<File> exportGif({
    required SimulationProvider simulation,
    int steps = 10,
    int cellSize = 20,
  }) async {
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

    await Isolate.spawn(gifIsolateEntry, request);

    final gifBytes = await receivePort.first as Uint8List;
    receivePort.close();

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/automata_${DateTime.now().millisecondsSinceEpoch}.gif');
    await file.writeAsBytes(gifBytes);

    return file;
  }
}
