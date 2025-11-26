// utils/image_isolate.dart
import 'dart:typed_data';
import 'dart:isolate';
import 'package:image/image.dart' as img;

class ImageIsolateRequest {
  final List<List<int>> grid;
  final List<int> colors;
  final int rows;
  final int cols;
  final int cellSize;
  final SendPort replyTo;

  ImageIsolateRequest({
    required this.grid,
    required this.colors,
    required this.rows,
    required this.cols,
    required this.cellSize,
    required this.replyTo,
  });
}

void imageIsolateEntry(ImageIsolateRequest request) {
  final image = img.Image(width: request.cols * request.cellSize, height: request.rows * request.cellSize);

  for (int r = 0; r < request.rows; r++) {
    for (int c = 0; c < request.cols; c++) {
      final colorValue = request.colors[request.grid[r][c]];
      final pixelColor = img.ColorRgb8(
        (colorValue >> 16) & 0xFF,
        (colorValue >> 8) & 0xFF,
        colorValue & 0xFF,
      );
      for (int dy = 0; dy < request.cellSize; dy++) {
        for (int dx = 0; dx < request.cellSize; dx++) {
          image.setPixel(c * request.cellSize + dx, r * request.cellSize + dy, pixelColor);
        }
      }
    }
  }

  final pngBytes = Uint8List.fromList(img.encodePng(image));
  request.replyTo.send(pngBytes);
}
