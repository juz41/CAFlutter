import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/transition_rule.dart';
import '../providers/simulation_provider.dart';

class MultiStateRuleEditor extends StatefulWidget {
  const MultiStateRuleEditor({super.key});

  @override
  State<MultiStateRuleEditor> createState() => _MultiStateRuleEditorState();
}

class _MultiStateRuleEditorState extends State<MultiStateRuleEditor> {
  int? selectedFromState;
  int? selectedToState;
  Map<int, List<int>> neighborCounts = {};

  @override
  Widget build(BuildContext context) {
    final sim = Provider.of<SimulationProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.multiStateRuleEditor)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(AppLocalizations.of(context)!.states,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          StateRow(
            states: sim.states,
            onUpdate: () => setState(() {}),
            onAdd: (name, color) {
              sim.addState(name, color);
              setState(() {});
            },
            onRemove: (index) {
              sim.states.removeAt(index);
              sim.rules.removeWhere(
                  (r) => r.fromState == index || r.toState == index);
              setState(() {});
            },
            onRenameOrColorChange: (index, name, color) {
              sim.states[index].name = name;
              sim.updateStateColor(index, color);
              setState(() {});
            },
          ),
          const Divider(height: 24),
          Text(AppLocalizations.of(context)!.createRule,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<int>(
            hint: Text(AppLocalizations.of(context)!.fromState),
            value: selectedFromState,
            items: List.generate(sim.states.length, (i) {
              return DropdownMenuItem(
                  value: i, child: Text(sim.states[i].name));
            }),
            onChanged: (v) => setState(() => selectedFromState = v),
          ),
          DropdownButton<int>(
            hint: Text(AppLocalizations.of(context)!.toState),
            value: selectedToState,
            items: List.generate(sim.states.length, (i) {
              return DropdownMenuItem(
                  value: i, child: Text(sim.states[i].name));
            }),
            onChanged: (v) => setState(() => selectedToState = v),
          ),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context)!.neighborCounts),
          Wrap(
            spacing: 8,
            children: List.generate(sim.states.length, (i) {
              return NeighborCountRow(
                stateName: sim.states[i].name,
                onChanged: (val) => neighborCounts[i] = val,
              );
            }),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (selectedFromState == null || selectedToState == null) return;
              sim.addRule(TransitionRule(
                fromState: selectedFromState!,
                toState: selectedToState!,
                neighborCounts: Map.from(neighborCounts),
              ));
              selectedFromState = null;
              selectedToState = null;
              neighborCounts.clear();
              setState(() {});
            },
            child: Text(AppLocalizations.of(context)!.addRule),
          ),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context)!.existingRules,
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...sim.rules.asMap().entries.map((entry) {
            final r = entry.value;
            return RuleTile(
              rule: r,
              states: sim.states,
              onEdit: () {
                selectedFromState = r.fromState;
                selectedToState = r.toState;
                neighborCounts = Map.from(r.neighborCounts);
                sim.removeRule(r);
                setState(() {});
              },
              onDelete: () {
                sim.removeRule(r);
                setState(() {});
              },
            );
          }),
        ],
      ),
    );
  }
}

// ------------------- Helper Widgets -------------------

class StateRow extends StatelessWidget {
  final List states;
  final VoidCallback onUpdate;
  final void Function(String name, Color color) onAdd;
  final void Function(int index) onRemove;
  final void Function(int index, String name, Color color)
      onRenameOrColorChange;

  const StateRow({
    super.key,
    required this.states,
    required this.onUpdate,
    required this.onAdd,
    required this.onRemove,
    required this.onRenameOrColorChange,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ...List.generate(states.length, (i) {
          final state = states[i];
          return StateChip(
            index: i,
            name: state.name,
            color: state.color,
            onRemove: onRemove,
            onRenameOrColorChange: onRenameOrColorChange,
          );
        }),
        GestureDetector(
          onTap: () async {
            String newName = '';
            Color newColor = Colors.black;
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.addNewState),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.stateName),
                      onChanged: (v) => newName = v,
                    ),
                    const SizedBox(height: 12),
                    ColorPicker(
                      pickerColor: newColor,
                      onColorChanged: (c) => newColor = c,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.add),
                  ),
                ],
              ),
            );
            if (newName.isNotEmpty) onAdd(newName, newColor);
          },
          child: const Chip(
            label: Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}

class StateChip extends StatelessWidget {
  final int index;
  final String name;
  final Color color;
  final void Function(int index) onRemove;
  final void Function(int index, String name, Color color)
      onRenameOrColorChange;

  const StateChip({
    super.key,
    required this.index,
    required this.name,
    required this.color,
    required this.onRemove,
    required this.onRenameOrColorChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final sim = context.read<SimulationProvider>(); // capture BEFORE await

        String newName = name;
        Color picked = color;
        bool removeState = false;

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.editState),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: name),
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name),
                  onChanged: (v) => newName = v,
                ),
                const SizedBox(height: 12),
                ColorPicker(
                  pickerColor: color,
                  onColorChanged: (c) => picked = c,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    removeState = true;
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.removeState),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        );

        if (removeState) {
          sim.removeStateAt(index); // safe, captured before async gap
        } else if (newName.isNotEmpty) {
          onRenameOrColorChange(index, newName, picked);
        }
      },

      child: Chip(label: Text(name), backgroundColor: color),
    );
  }
}

class NeighborCountRow extends StatelessWidget {
  final String stateName;
  final void Function(List<int> values) onChanged;

  const NeighborCountRow(
      {super.key, required this.stateName, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$stateName:'),
        SizedBox(
          width: 80,
          child: TextField(
            keyboardType: TextInputType.text,
            onChanged: (v) {
              // parse comma-separated numbers
              final values = v
                  .split(',')
                  .map((e) => int.tryParse(e.trim()))
                  .where((e) => e != null)
                  .map((e) => e!)
                  .toList();
              onChanged(values);
            },
            decoration: const InputDecoration(
              hintText: 'e.g. 2,3',
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            ),
          ),
        ),
      ],
    );
  }
}

class RuleTile extends StatelessWidget {
  final TransitionRule rule;
  final List states;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RuleTile(
      {super.key,
      required this.rule,
      required this.states,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text('${states[rule.fromState].name} → ${states[rule.toState].name}'),
      subtitle: Text(rule.neighborCounts.entries
          .map((e) => '${states[e.key].name}: ${e.value}')
          .join(', ')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
