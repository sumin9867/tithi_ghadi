import 'package:freezed_annotation/freezed_annotation.dart';

part 'panchang_daily_model.freezed.dart';
part 'panchang_daily_model.g.dart';

@freezed
class PanchangDetail with _$PanchangDetail {
  const factory PanchangDetail({
    String? nameEn,
    String? nameNp,
    String? typeEn,
    String? typeNp,
    String? start,
    String? end,
  }) = _PanchangDetail;

  factory PanchangDetail.fromJson(Map<String, dynamic> json) =>
      _$PanchangDetailFromJson(json);
}

@freezed
class VaraDetail with _$VaraDetail {
  const factory VaraDetail({required String nameEn, required String nameNp}) =
      _VaraDetail;

  factory VaraDetail.fromJson(Map<String, dynamic> json) =>
      _$VaraDetailFromJson(json);
}

@freezed
class PanchangDailyModel with _$PanchangDailyModel {
  const factory PanchangDailyModel({
    required String date,
    required String dateAd,
    required VaraDetail vara,
    required PanchangDetail tithi,
    required PanchangDetail nakshatra,
    required PanchangDetail yoga,
    required PanchangDetail karana,
  }) = _PanchangDailyModel;

  factory PanchangDailyModel.fromJson(Map<String, dynamic> json) =>
      _$PanchangDailyModelFromJson(json);
}

@freezed
class MonthEventsResponse with _$MonthEventsResponse {
  const factory MonthEventsResponse({
    required String fromDate,
    required String fromDateAd,
    required String toDate,
    required String toDateAd,
    required String location,
    required int totalDays,
    required List<PanchangDailyModel> days,
  }) = _MonthEventsResponse;

  factory MonthEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$MonthEventsResponseFromJson(json);
}
