part of 'tithi_ghadi_cubit.dart';

@freezed
class TithiGhadiState with _$TithiGhadiState {
  const factory TithiGhadiState.initial() = _Initial;
  const factory TithiGhadiState.loading() = _Loading;

  const factory TithiGhadiState.loaded(MonthEventsResponse response) = _Loaded;

  const factory TithiGhadiState.error() = _Error;


}
