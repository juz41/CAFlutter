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

  Map<String, dynamic> toJson() => {
        'fromState': fromState,
        'toState': toState,
        'neighborCounts': {
          for (var e in neighborCounts.entries) e.key.toString(): e.value,
        },
      };

  factory TransitionRule.fromJson(Map<String, dynamic> json) {
    return TransitionRule(
      fromState: json['fromState'],
      toState: json['toState'],
      neighborCounts: {
        for (var e in (json['neighborCounts'] as Map<String, dynamic>).entries)
          int.parse(e.key): List<int>.from(e.value),
      },
    );
  }
}
