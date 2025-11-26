import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cell.dart';
import '../providers/simulation_provider.dart';
import '../utils/gif_exporter_isolate.dart';
import '../utils/image_exporter_isolate.dart';
import '../widgets/cell_grid.dart';
import '../widgets/control_panel.dart';
import 'neighbor_rule_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool exporting = false;

  final imageExporter = ImageExporterIsolate();

  Future<void> _exportImage() async {
    setState(() => exporting = true);
    final sim = Provider.of<SimulationProvider>(context, listen: false);

    final file = await imageExporter.exportImage(
      grid: sim.grid,
      states: sim.states,
      cellSize: 20,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved image to ${file.path}')),
      );
    }
    setState(() => exporting = false);
  }


  final exporter = GifExporterIsolate();

  Future<void> _exportGif({required int steps}) async {
    setState(() => exporting = true);
    final sim = Provider.of<SimulationProvider>(context, listen: false);

    final path = await exporter.exportGif(
      simulation: sim,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved GIF to $path')),
      );
    }
    setState(() => exporting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cellular Automata')),
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          const Positioned.fill(child: CellGrid(fitToContainer: true)),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const ControlPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final sim = Provider.of<SimulationProvider>(context, listen: false);
    final rowsController = TextEditingController(text: sim.rows.toString());
    final colsController = TextEditingController(text: sim.cols.toString());
    final gifStepsController = TextEditingController(text: '10');

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.grid_4x4),
            title: const Text('Grid Size'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: rowsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Rows'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: colsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Columns'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final newRows = int.tryParse(rowsController.text) ?? sim.rows;
                    final newCols = int.tryParse(colsController.text) ?? sim.cols;
                    sim.resizeGrid(newRows, newCols);
                  },
                  child: const Text('Resize Grid'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.rule),
            title: const Text('Edit Rules / States'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MultiStateRuleEditor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Export PNG'),
            onTap: exporting ? null : _exportImage,
          ),
          ListTile(
            leading: const Icon(Icons.gif),
            title: const Text('Export GIF'),
            subtitle: TextField(
              controller: gifStepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Steps'),
            ),
            onTap: exporting
                ? null
                : () async {
              final steps = int.tryParse(gifStepsController.text) ?? 10;
              await _exportGif(steps: steps);
            },
          ),
        ],
      ),
    );
  }
}
