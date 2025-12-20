// utils/image_exporter_isolate.dart
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import '../models/cell.dart';
import '../models/state_definition.dart';
import 'image_isolate.dart';
import 'package:path_provider/path_provider.dart';

class ImageExporterIsolate {
  Future<File> exportImage({
    required List<List<Cell>> grid,
    required List<StateDefinition> states,
    int cellSize = 20,
  }) async {
    final rows = grid.length;
    final cols = grid[0].length;
    final gridData = List.generate(
        rows, (r) => List.generate(cols, (c) => grid[r][c].state));
    final colors = states.map((s) => s.color.value).toList();

    final receivePort = ReceivePort();
    final request = ImageIsolateRequest(
      grid: gridData,
      colors: colors,
      rows: rows,
      cols: cols,
      cellSize: cellSize,
      replyTo: receivePort.sendPort,
    );

    await Isolate.spawn(imageIsolateEntry, request);

    final pngBytes = await receivePort.first as Uint8List;
    receivePort.close();

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/automata_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(pngBytes);
    return file;
  }
}
