import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/panchang_repository.dart';
import '../datasources/panchang_remote_data_source.dart';
import '../../domain/panchang_daily_model.dart';

class PanchangRepositoryImpl implements PanchangRepository {
  final PanchangRemoteDataSource remoteDataSource;

  PanchangRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MonthEventsResponse>> getDailyPanchang(
    DateTime date,
    String location,
  ) async {
    try {
      final response = await remoteDataSource.fetchDailyPanchang(date, location);
      return Right(response);
    } on DioException catch (e) {
      log('DioException occurred: ${e.message}');
      return Left(_mapDioException(e));
    } catch (e) {
      log('Unexpected error occurred: $e');
      return const Left(Failure.networkFailure('Failed to load daily panchang.'));
    }
  }

  Failure _mapDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      return const Failure.unauthorizedFailure('Unauthorized request.');
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const Failure.networkFailure('Connection timed out.');
    }
    return Failure.serverFailure(e.message);
  }
}
