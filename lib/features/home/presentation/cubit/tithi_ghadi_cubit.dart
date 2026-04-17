import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tithi_gadhi/features/home/domain/panchang_daily_model.dart';
import 'package:tithi_gadhi/features/home/domain/repositories/panchang_repository.dart';

part 'tithi_ghadi_state.dart';
part 'tithi_ghadi_cubit.freezed.dart';

class TithiGhadiCubit extends Cubit<TithiGhadiState> {
  final PanchangRepository _repository;

  TithiGhadiCubit(this._repository) : super(const TithiGhadiState.initial());

  Future<void> loadDailyPanchang(DateTime date, String location) async {
    emit(const TithiGhadiState.loading());
    final result = await _repository.getDailyPanchang(date, location);
    result.fold((failure) => emit(const TithiGhadiState.error()), (response) {
      return emit(TithiGhadiState.loaded(response));
    });
  }
}
