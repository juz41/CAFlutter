import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final sim = Provider.of<SimulationProvider>(context);
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            tooltip: sim.isRunning ? 'Pause' : 'Start',
            icon: Icon(sim.isRunning ? Icons.pause : Icons.play_arrow),
            onPressed: sim.toggleRunning,
          ),
          IconButton(
            tooltip: 'Step',
            icon: const Icon(Icons.skip_next),
            onPressed: sim.step,
          ),
          IconButton(
            tooltip: 'Reset (clear)',
            icon: const Icon(Icons.refresh),
            onPressed: sim.reset,
          ),
          IconButton(
            tooltip: 'Clear',
            icon: const Icon(Icons.clear),
            onPressed: sim.clear,
          ),
          const SizedBox(width: 12),
          const Text('Speed:'),
          Slider(
            value: sim.stepInterval.inMilliseconds.toDouble(),
            min: 50,
            max: 1000,
            divisions: 19,
            label: '${sim.stepInterval.inMilliseconds} ms',
            onChanged: (v) {
              sim.setInterval(Duration(milliseconds: v.toInt()));
            },
          ),
          IconButton(
            tooltip: 'Randomize Grid',
            icon: const Icon(Icons.casino), // Dice symbol
            onPressed: sim.randomize,
          ),
        ],
      ),
    );
  }
}
