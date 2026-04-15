import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../panchang_daily_model.dart';

abstract class PanchangRepository {
  Future<Either<Failure, MonthEventsResponse>> getDailyPanchang(
    DateTime date,
    String location,
  );
}
