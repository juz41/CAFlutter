import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';

class CellGrid extends StatelessWidget {
  final double baseCellSize;
  final bool fitToContainer;

  const CellGrid({
    super.key,
    this.baseCellSize = 25.0,
    this.fitToContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationProvider>(
      builder: (context, sim, child) {
        final rows = sim.rows;
        final cols = sim.cols;
        final cellSize = baseCellSize;

        return LayoutBuilder(
          builder: (context, constraints) {
            final scaleX = constraints.maxWidth / (cols * cellSize);
            final scaleY = constraints.maxHeight / (rows * cellSize);
            final scale =
                fitToContainer ? (scaleX < scaleY ? scaleX : scaleY) : 1.0;

            return InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(2000),
              minScale: 0.3,
              maxScale: 6.0,
              child: SizedBox(
                width: cols * cellSize * scale,
                height: rows * cellSize * scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(rows, (row) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(cols, (col) {
                        final cell = sim.grid[row][col];
                        return GestureDetector(
                            onTap: () => sim.toggleCell(row, col),
                            child: Container(
                              width: cellSize * scale,
                              height: cellSize * scale,
                              decoration: BoxDecoration(
                                color: sim.states[cell.state].color,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                            ));
                      }),
                    );
                  }),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
