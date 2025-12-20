import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/simulation_provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final sim = Provider.of<SimulationProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            tooltip: sim.isRunning
                ? AppLocalizations.of(context)!.pause
                : AppLocalizations.of(context)!.start,
            icon: Icon(sim.isRunning ? Icons.pause : Icons.play_arrow),
            onPressed: sim.toggleRunning,
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.step,
            icon: const Icon(Icons.skip_next),
            onPressed: sim.step,
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.reset,
            icon: const Icon(Icons.refresh),
            onPressed: sim.reset,
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.clear,
            icon: const Icon(Icons.clear),
            onPressed: sim.clear,
          ),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context)!.speed,
            softWrap: false,
          ),
          Expanded(
            child: Slider(
              value: sim.stepInterval.inMilliseconds.toDouble(),
              min: 50,
              max: 1000,
              divisions: 19,
              label: '${sim.stepInterval.inMilliseconds} ms',
              onChanged: (v) {
                sim.setInterval(Duration(milliseconds: v.toInt()));
              },
            ),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.randomize,
            icon: const Icon(Icons.casino),
            onPressed: sim.randomize,
          ),
        ],
      ),
    );
  }
}
