class TransitionRule {
  final int fromState;
  final int toState;
  final Map<int, List<int>> neighborCounts;

  TransitionRule({
    required this.fromState,
    required this.toState,
    required this.neighborCounts,
  });

  bool applies(Map<int, int> neighbors) {
    for (var state in neighborCounts.keys) {
      final count = neighbors[state] ?? 0;
      if (!neighborCounts[state]!.contains(count)) return false;
    }
    return true;
  }
}
