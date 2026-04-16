import 'dart:developer';

import '../../../../core/network/dio_client.dart';
import '../../domain/panchang_daily_model.dart';

abstract class PanchangRemoteDataSource {
  Future<MonthEventsResponse> fetchDailyPanchang(DateTime date, String location);
}

class PanchangRemoteDataSourceImpl implements PanchangRemoteDataSource {
  final DioClient dioClient;
  PanchangRemoteDataSourceImpl(this.dioClient);

  static const String _apiPrefix = '/api';

  @override
  Future<MonthEventsResponse> fetchDailyPanchang(DateTime date, String location) async {
    final formattedDate = _formatDate(date);
    final response = await dioClient.dio.get(
      '$_apiPrefix/panchang-events/month-events',
      queryParameters: {
        'fromDate': formattedDate,
        'toDate': formattedDate,
        'location': location,
      },
    );
    final monthResponse = MonthEventsResponse.fromJson(response.data as Map<String, dynamic>);
    if (monthResponse.days.isEmpty) {
      throw Exception('No data available for the given date');
    }
    return monthResponse;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
