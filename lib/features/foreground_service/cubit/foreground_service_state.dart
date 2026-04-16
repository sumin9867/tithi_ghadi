/// Simple state class to track foreground service status.
class ForegroundServiceState {
  final bool isRunning;

  const ForegroundServiceState({this.isRunning = false});

  /// Creates a copy with optional field overrides.
  ForegroundServiceState copyWith({bool? isRunning}) {
    return ForegroundServiceState(
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForegroundServiceState &&
          runtimeType == other.runtimeType &&
          isRunning == other.isRunning;

  @override
  int get hashCode => isRunning.hashCode;
}
