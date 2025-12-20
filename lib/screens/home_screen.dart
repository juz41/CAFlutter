import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/simulation_provider.dart';
import '../providers/theme_provider.dart';
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
        SnackBar(
            content: Text(AppLocalizations.of(context)!.savedImage(file.path))),
      );
    }
    setState(() => exporting = false);
  }

  final exporter = GifExporterIsolate();

  Future<void> _exportGif({required int steps}) async {
    setState(() => exporting = true);
    final sim = Provider.of<SimulationProvider>(context, listen: false);

    final file = await exporter.exportGif(
      simulation: sim,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.savedGif(file.path))),
      );
    }
    setState(() => exporting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
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
                  color:
                  Theme.of(context).colorScheme.surface.withAlpha((0.95 * 255).round()),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.25 * 255).round()),
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
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                AppLocalizations.of(context)!.menu,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.grid_4x4),
            title: Text(AppLocalizations.of(context)!.gridSize),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: rowsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.rows),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: colsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.columns),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final newRows =
                        int.tryParse(rowsController.text) ?? sim.rows;
                    final newCols =
                        int.tryParse(colsController.text) ?? sim.cols;
                    sim.resizeGrid(newRows, newCols);
                  },
                  child: Text(AppLocalizations.of(context)!.resizeGrid),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.rule),
            title: Text(AppLocalizations.of(context)!.editRules),
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
            title: Text(AppLocalizations.of(context)!.exportPng),
            onTap: exporting ? null : _exportImage,
          ),
          ListTile(
            leading: const Icon(Icons.gif),
            title: Text(AppLocalizations.of(context)!.exportGif),
            subtitle: TextField(
              controller: gifStepsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.steps),
            ),
            onTap: exporting
                ? null
                : () async {
                    final steps = int.tryParse(gifStepsController.text) ?? 10;
                    await _exportGif(steps: steps);
                  },
          ),
          Consumer<ThemeProvider>(
            builder: (context, theme, _) {
              return ListTile(
                leading: Icon(
                  theme.isDark ? Icons.dark_mode : Icons.light_mode,
                ),
                title: Text(
                  theme.isDark
                      ? AppLocalizations.of(context)!.darkMode
                      : AppLocalizations.of(context)!.lightMode,
                ),
                onTap: theme.toggleTheme,
              );
            },
          ),
        ],
      ),
    );
  }
}
