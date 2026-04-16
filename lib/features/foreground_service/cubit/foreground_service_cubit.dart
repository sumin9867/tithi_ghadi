import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tithi_gadhi/core/services/tithi_foreground_service.dart';
import 'foreground_service_state.dart';

/// Cubit to manage foreground service lifecycle and data relay.
/// Provides a clean BLoC interface for UI components to interact with the service.
@lazySingleton
class ForegroundServiceCubit extends Cubit<ForegroundServiceState> {
  ForegroundServiceCubit() : super(const ForegroundServiceState());

  /// Starts the foreground service and updates state.
  Future<void> startService() async {
    try {
      await TithiForegroundService.startService();
      emit(state.copyWith(isRunning: true));
    } catch (e) {
      emit(state.copyWith(isRunning: false));
    }
  }

  /// Stops the foreground service and updates state.
  Future<void> stopService() async {
    try {
      await TithiForegroundService.stopService();
      emit(state.copyWith(isRunning: false));
    } catch (e) {
      emit(state.copyWith(isRunning: false));
    }
  }

  /// Sends tithi data to the background task for notification update.
  Future<void> sendTithiData({
    required String tithiName,
    required String tithiEnd,
  }) async {
    try {
      await TithiForegroundService.sendTithiData(
        tithiName: tithiName,
        tithiEnd: tithiEnd,
      );
    } catch (e) {
      // Silent fail - service might not be running
    }
  }
}
