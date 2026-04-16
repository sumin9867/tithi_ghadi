import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Top-level background isolate entry point. Must be annotated with @pragma.
@pragma('vm:entry-point')
void startTithiTaskCallback() {
  FlutterForegroundTask.setTaskHandler(TithiTaskHandler());
}

/// Background task handler that runs in a separate isolate.
/// Updates the foreground notification every 60 seconds with tithi + countdown.
class TithiTaskHandler extends TaskHandler {
  String _tithiName = '';
  String _tithiEnd = ''; // ISO datetime string from API (e.g., "2026-04-16T12:30:45Z")

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _updateNotification();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _updateNotification();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isDetached) async {}

  @override
  void onReceiveData(Object data) {
    if (data is Map<String, dynamic>) {
      _tithiName = data['tithi_name'] as String? ?? '';
      _tithiEnd = data['tithi_end'] as String? ?? '';
      _updateNotification();
    }
  }

  /// Recomputes countdown from stored ISO end time and updates notification.
  /// Called on start, on each repeat event (60s), and when receiving new data.
  void _updateNotification() {
    if (_tithiName.isEmpty) {
      FlutterForegroundTask.updateService(
        notificationTitle: 'Tithi Gadhi',
        notificationText: 'Fetching tithi…',
      );
      return;
    }

    String subtitle = '';
    if (_tithiEnd.isNotEmpty) {
      try {
        final end = DateTime.parse(_tithiEnd).toLocal();
        final now = DateTime.now();
        final diff = end.difference(now);

        if (diff.isNegative) {
          subtitle = 'तिथि परिवर्तन भयो';
        } else {
          final h = diff.inHours;
          final m = diff.inMinutes % 60;
          subtitle = h > 0 ? '${h}घ $mम बाँकी' : '$mम बाँकी';
        }
      } catch (_) {
        // If parsing fails, show tithi name only
      }
    }

    FlutterForegroundTask.updateService(
      notificationTitle: 'तिथि: $_tithiName',
      notificationText: subtitle.isNotEmpty ? subtitle : _tithiName,
    );
  }
}
