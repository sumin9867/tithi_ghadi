// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panchang_daily_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PanchangDetailImpl _$$PanchangDetailImplFromJson(Map<String, dynamic> json) =>
    _$PanchangDetailImpl(
      nameEn: json['nameEn'] as String?,
      nameNp: json['nameNp'] as String?,
      typeEn: json['typeEn'] as String?,
      typeNp: json['typeNp'] as String?,
      start: json['start'] as String?,
      end: json['end'] as String?,
    );

Map<String, dynamic> _$$PanchangDetailImplToJson(
  _$PanchangDetailImpl instance,
) => <String, dynamic>{
  'nameEn': instance.nameEn,
  'nameNp': instance.nameNp,
  'typeEn': instance.typeEn,
  'typeNp': instance.typeNp,
  'start': instance.start,
  'end': instance.end,
};

_$VaraDetailImpl _$$VaraDetailImplFromJson(Map<String, dynamic> json) =>
    _$VaraDetailImpl(
      nameEn: json['nameEn'] as String,
      nameNp: json['nameNp'] as String,
    );

Map<String, dynamic> _$$VaraDetailImplToJson(_$VaraDetailImpl instance) =>
    <String, dynamic>{'nameEn': instance.nameEn, 'nameNp': instance.nameNp};

_$PanchangDailyModelImpl _$$PanchangDailyModelImplFromJson(
  Map<String, dynamic> json,
) => _$PanchangDailyModelImpl(
  date: json['date'] as String,
  dateAd: json['dateAd'] as String,
  vara: VaraDetail.fromJson(json['vara'] as Map<String, dynamic>),
  tithi: PanchangDetail.fromJson(json['tithi'] as Map<String, dynamic>),
  nakshatra: PanchangDetail.fromJson(json['nakshatra'] as Map<String, dynamic>),
  yoga: PanchangDetail.fromJson(json['yoga'] as Map<String, dynamic>),
  karana: PanchangDetail.fromJson(json['karana'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PanchangDailyModelImplToJson(
  _$PanchangDailyModelImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'dateAd': instance.dateAd,
  'vara': instance.vara,
  'tithi': instance.tithi,
  'nakshatra': instance.nakshatra,
  'yoga': instance.yoga,
  'karana': instance.karana,
};

_$MonthEventsResponseImpl _$$MonthEventsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MonthEventsResponseImpl(
  fromDate: json['fromDate'] as String,
  fromDateAd: json['fromDateAd'] as String,
  toDate: json['toDate'] as String,
  toDateAd: json['toDateAd'] as String,
  location: json['location'] as String,
  totalDays: (json['totalDays'] as num).toInt(),
  days: (json['days'] as List<dynamic>)
      .map((e) => PanchangDailyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MonthEventsResponseImplToJson(
  _$MonthEventsResponseImpl instance,
) => <String, dynamic>{
  'fromDate': instance.fromDate,
  'fromDateAd': instance.fromDateAd,
  'toDate': instance.toDate,
  'toDateAd': instance.toDateAd,
  'location': instance.location,
  'totalDays': instance.totalDays,
  'days': instance.days,
};
