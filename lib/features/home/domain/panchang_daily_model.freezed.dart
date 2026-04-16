// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panchang_daily_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PanchangDetail _$PanchangDetailFromJson(Map<String, dynamic> json) {
  return _PanchangDetail.fromJson(json);
}

/// @nodoc
mixin _$PanchangDetail {
  String? get nameEn => throw _privateConstructorUsedError;
  String? get nameNp => throw _privateConstructorUsedError;
  String? get typeEn => throw _privateConstructorUsedError;
  String? get typeNp => throw _privateConstructorUsedError;
  String? get start => throw _privateConstructorUsedError;
  String? get end => throw _privateConstructorUsedError;

  /// Serializes this PanchangDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PanchangDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PanchangDetailCopyWith<PanchangDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PanchangDetailCopyWith<$Res> {
  factory $PanchangDetailCopyWith(
    PanchangDetail value,
    $Res Function(PanchangDetail) then,
  ) = _$PanchangDetailCopyWithImpl<$Res, PanchangDetail>;
  @useResult
  $Res call({
    String? nameEn,
    String? nameNp,
    String? typeEn,
    String? typeNp,
    String? start,
    String? end,
  });
}

/// @nodoc
class _$PanchangDetailCopyWithImpl<$Res, $Val extends PanchangDetail>
    implements $PanchangDetailCopyWith<$Res> {
  _$PanchangDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PanchangDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nameEn = freezed,
    Object? nameNp = freezed,
    Object? typeEn = freezed,
    Object? typeNp = freezed,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(
      _value.copyWith(
            nameEn: freezed == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String?,
            nameNp: freezed == nameNp
                ? _value.nameNp
                : nameNp // ignore: cast_nullable_to_non_nullable
                      as String?,
            typeEn: freezed == typeEn
                ? _value.typeEn
                : typeEn // ignore: cast_nullable_to_non_nullable
                      as String?,
            typeNp: freezed == typeNp
                ? _value.typeNp
                : typeNp // ignore: cast_nullable_to_non_nullable
                      as String?,
            start: freezed == start
                ? _value.start
                : start // ignore: cast_nullable_to_non_nullable
                      as String?,
            end: freezed == end
                ? _value.end
                : end // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PanchangDetailImplCopyWith<$Res>
    implements $PanchangDetailCopyWith<$Res> {
  factory _$$PanchangDetailImplCopyWith(
    _$PanchangDetailImpl value,
    $Res Function(_$PanchangDetailImpl) then,
  ) = __$$PanchangDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? nameEn,
    String? nameNp,
    String? typeEn,
    String? typeNp,
    String? start,
    String? end,
  });
}

/// @nodoc
class __$$PanchangDetailImplCopyWithImpl<$Res>
    extends _$PanchangDetailCopyWithImpl<$Res, _$PanchangDetailImpl>
    implements _$$PanchangDetailImplCopyWith<$Res> {
  __$$PanchangDetailImplCopyWithImpl(
    _$PanchangDetailImpl _value,
    $Res Function(_$PanchangDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanchangDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nameEn = freezed,
    Object? nameNp = freezed,
    Object? typeEn = freezed,
    Object? typeNp = freezed,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(
      _$PanchangDetailImpl(
        nameEn: freezed == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String?,
        nameNp: freezed == nameNp
            ? _value.nameNp
            : nameNp // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeEn: freezed == typeEn
            ? _value.typeEn
            : typeEn // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeNp: freezed == typeNp
            ? _value.typeNp
            : typeNp // ignore: cast_nullable_to_non_nullable
                  as String?,
        start: freezed == start
            ? _value.start
            : start // ignore: cast_nullable_to_non_nullable
                  as String?,
        end: freezed == end
            ? _value.end
            : end // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PanchangDetailImpl implements _PanchangDetail {
  const _$PanchangDetailImpl({
    this.nameEn,
    this.nameNp,
    this.typeEn,
    this.typeNp,
    this.start,
    this.end,
  });

  factory _$PanchangDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PanchangDetailImplFromJson(json);

  @override
  final String? nameEn;
  @override
  final String? nameNp;
  @override
  final String? typeEn;
  @override
  final String? typeNp;
  @override
  final String? start;
  @override
  final String? end;

  @override
  String toString() {
    return 'PanchangDetail(nameEn: $nameEn, nameNp: $nameNp, typeEn: $typeEn, typeNp: $typeNp, start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PanchangDetailImpl &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.nameNp, nameNp) || other.nameNp == nameNp) &&
            (identical(other.typeEn, typeEn) || other.typeEn == typeEn) &&
            (identical(other.typeNp, typeNp) || other.typeNp == typeNp) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, nameEn, nameNp, typeEn, typeNp, start, end);

  /// Create a copy of PanchangDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PanchangDetailImplCopyWith<_$PanchangDetailImpl> get copyWith =>
      __$$PanchangDetailImplCopyWithImpl<_$PanchangDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PanchangDetailImplToJson(this);
  }
}

abstract class _PanchangDetail implements PanchangDetail {
  const factory _PanchangDetail({
    final String? nameEn,
    final String? nameNp,
    final String? typeEn,
    final String? typeNp,
    final String? start,
    final String? end,
  }) = _$PanchangDetailImpl;

  factory _PanchangDetail.fromJson(Map<String, dynamic> json) =
      _$PanchangDetailImpl.fromJson;

  @override
  String? get nameEn;
  @override
  String? get nameNp;
  @override
  String? get typeEn;
  @override
  String? get typeNp;
  @override
  String? get start;
  @override
  String? get end;

  /// Create a copy of PanchangDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PanchangDetailImplCopyWith<_$PanchangDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VaraDetail _$VaraDetailFromJson(Map<String, dynamic> json) {
  return _VaraDetail.fromJson(json);
}

/// @nodoc
mixin _$VaraDetail {
  String get nameEn => throw _privateConstructorUsedError;
  String get nameNp => throw _privateConstructorUsedError;

  /// Serializes this VaraDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaraDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaraDetailCopyWith<VaraDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaraDetailCopyWith<$Res> {
  factory $VaraDetailCopyWith(
    VaraDetail value,
    $Res Function(VaraDetail) then,
  ) = _$VaraDetailCopyWithImpl<$Res, VaraDetail>;
  @useResult
  $Res call({String nameEn, String nameNp});
}

/// @nodoc
class _$VaraDetailCopyWithImpl<$Res, $Val extends VaraDetail>
    implements $VaraDetailCopyWith<$Res> {
  _$VaraDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaraDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nameEn = null, Object? nameNp = null}) {
    return _then(
      _value.copyWith(
            nameEn: null == nameEn
                ? _value.nameEn
                : nameEn // ignore: cast_nullable_to_non_nullable
                      as String,
            nameNp: null == nameNp
                ? _value.nameNp
                : nameNp // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VaraDetailImplCopyWith<$Res>
    implements $VaraDetailCopyWith<$Res> {
  factory _$$VaraDetailImplCopyWith(
    _$VaraDetailImpl value,
    $Res Function(_$VaraDetailImpl) then,
  ) = __$$VaraDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nameEn, String nameNp});
}

/// @nodoc
class __$$VaraDetailImplCopyWithImpl<$Res>
    extends _$VaraDetailCopyWithImpl<$Res, _$VaraDetailImpl>
    implements _$$VaraDetailImplCopyWith<$Res> {
  __$$VaraDetailImplCopyWithImpl(
    _$VaraDetailImpl _value,
    $Res Function(_$VaraDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VaraDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nameEn = null, Object? nameNp = null}) {
    return _then(
      _$VaraDetailImpl(
        nameEn: null == nameEn
            ? _value.nameEn
            : nameEn // ignore: cast_nullable_to_non_nullable
                  as String,
        nameNp: null == nameNp
            ? _value.nameNp
            : nameNp // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VaraDetailImpl implements _VaraDetail {
  const _$VaraDetailImpl({required this.nameEn, required this.nameNp});

  factory _$VaraDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaraDetailImplFromJson(json);

  @override
  final String nameEn;
  @override
  final String nameNp;

  @override
  String toString() {
    return 'VaraDetail(nameEn: $nameEn, nameNp: $nameNp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaraDetailImpl &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.nameNp, nameNp) || other.nameNp == nameNp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nameEn, nameNp);

  /// Create a copy of VaraDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaraDetailImplCopyWith<_$VaraDetailImpl> get copyWith =>
      __$$VaraDetailImplCopyWithImpl<_$VaraDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaraDetailImplToJson(this);
  }
}

abstract class _VaraDetail implements VaraDetail {
  const factory _VaraDetail({
    required final String nameEn,
    required final String nameNp,
  }) = _$VaraDetailImpl;

  factory _VaraDetail.fromJson(Map<String, dynamic> json) =
      _$VaraDetailImpl.fromJson;

  @override
  String get nameEn;
  @override
  String get nameNp;

  /// Create a copy of VaraDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaraDetailImplCopyWith<_$VaraDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PanchangDailyModel _$PanchangDailyModelFromJson(Map<String, dynamic> json) {
  return _PanchangDailyModel.fromJson(json);
}

/// @nodoc
mixin _$PanchangDailyModel {
  String get date => throw _privateConstructorUsedError;
  String get dateAd => throw _privateConstructorUsedError;
  VaraDetail get vara => throw _privateConstructorUsedError;
  PanchangDetail get tithi => throw _privateConstructorUsedError;
  PanchangDetail get nakshatra => throw _privateConstructorUsedError;
  PanchangDetail get yoga => throw _privateConstructorUsedError;
  PanchangDetail get karana => throw _privateConstructorUsedError;

  /// Serializes this PanchangDailyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PanchangDailyModelCopyWith<PanchangDailyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PanchangDailyModelCopyWith<$Res> {
  factory $PanchangDailyModelCopyWith(
    PanchangDailyModel value,
    $Res Function(PanchangDailyModel) then,
  ) = _$PanchangDailyModelCopyWithImpl<$Res, PanchangDailyModel>;
  @useResult
  $Res call({
    String date,
    String dateAd,
    VaraDetail vara,
    PanchangDetail tithi,
    PanchangDetail nakshatra,
    PanchangDetail yoga,
    PanchangDetail karana,
  });

  $VaraDetailCopyWith<$Res> get vara;
  $PanchangDetailCopyWith<$Res> get tithi;
  $PanchangDetailCopyWith<$Res> get nakshatra;
  $PanchangDetailCopyWith<$Res> get yoga;
  $PanchangDetailCopyWith<$Res> get karana;
}

/// @nodoc
class _$PanchangDailyModelCopyWithImpl<$Res, $Val extends PanchangDailyModel>
    implements $PanchangDailyModelCopyWith<$Res> {
  _$PanchangDailyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? dateAd = null,
    Object? vara = null,
    Object? tithi = null,
    Object? nakshatra = null,
    Object? yoga = null,
    Object? karana = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            dateAd: null == dateAd
                ? _value.dateAd
                : dateAd // ignore: cast_nullable_to_non_nullable
                      as String,
            vara: null == vara
                ? _value.vara
                : vara // ignore: cast_nullable_to_non_nullable
                      as VaraDetail,
            tithi: null == tithi
                ? _value.tithi
                : tithi // ignore: cast_nullable_to_non_nullable
                      as PanchangDetail,
            nakshatra: null == nakshatra
                ? _value.nakshatra
                : nakshatra // ignore: cast_nullable_to_non_nullable
                      as PanchangDetail,
            yoga: null == yoga
                ? _value.yoga
                : yoga // ignore: cast_nullable_to_non_nullable
                      as PanchangDetail,
            karana: null == karana
                ? _value.karana
                : karana // ignore: cast_nullable_to_non_nullable
                      as PanchangDetail,
          )
          as $Val,
    );
  }

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VaraDetailCopyWith<$Res> get vara {
    return $VaraDetailCopyWith<$Res>(_value.vara, (value) {
      return _then(_value.copyWith(vara: value) as $Val);
    });
  }

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PanchangDetailCopyWith<$Res> get tithi {
    return $PanchangDetailCopyWith<$Res>(_value.tithi, (value) {
      return _then(_value.copyWith(tithi: value) as $Val);
    });
  }

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PanchangDetailCopyWith<$Res> get nakshatra {
    return $PanchangDetailCopyWith<$Res>(_value.nakshatra, (value) {
      return _then(_value.copyWith(nakshatra: value) as $Val);
    });
  }

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PanchangDetailCopyWith<$Res> get yoga {
    return $PanchangDetailCopyWith<$Res>(_value.yoga, (value) {
      return _then(_value.copyWith(yoga: value) as $Val);
    });
  }

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PanchangDetailCopyWith<$Res> get karana {
    return $PanchangDetailCopyWith<$Res>(_value.karana, (value) {
      return _then(_value.copyWith(karana: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PanchangDailyModelImplCopyWith<$Res>
    implements $PanchangDailyModelCopyWith<$Res> {
  factory _$$PanchangDailyModelImplCopyWith(
    _$PanchangDailyModelImpl value,
    $Res Function(_$PanchangDailyModelImpl) then,
  ) = __$$PanchangDailyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    String dateAd,
    VaraDetail vara,
    PanchangDetail tithi,
    PanchangDetail nakshatra,
    PanchangDetail yoga,
    PanchangDetail karana,
  });

  @override
  $VaraDetailCopyWith<$Res> get vara;
  @override
  $PanchangDetailCopyWith<$Res> get tithi;
  @override
  $PanchangDetailCopyWith<$Res> get nakshatra;
  @override
  $PanchangDetailCopyWith<$Res> get yoga;
  @override
  $PanchangDetailCopyWith<$Res> get karana;
}

/// @nodoc
class __$$PanchangDailyModelImplCopyWithImpl<$Res>
    extends _$PanchangDailyModelCopyWithImpl<$Res, _$PanchangDailyModelImpl>
    implements _$$PanchangDailyModelImplCopyWith<$Res> {
  __$$PanchangDailyModelImplCopyWithImpl(
    _$PanchangDailyModelImpl _value,
    $Res Function(_$PanchangDailyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? dateAd = null,
    Object? vara = null,
    Object? tithi = null,
    Object? nakshatra = null,
    Object? yoga = null,
    Object? karana = null,
  }) {
    return _then(
      _$PanchangDailyModelImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        dateAd: null == dateAd
            ? _value.dateAd
            : dateAd // ignore: cast_nullable_to_non_nullable
                  as String,
        vara: null == vara
            ? _value.vara
            : vara // ignore: cast_nullable_to_non_nullable
                  as VaraDetail,
        tithi: null == tithi
            ? _value.tithi
            : tithi // ignore: cast_nullable_to_non_nullable
                  as PanchangDetail,
        nakshatra: null == nakshatra
            ? _value.nakshatra
            : nakshatra // ignore: cast_nullable_to_non_nullable
                  as PanchangDetail,
        yoga: null == yoga
            ? _value.yoga
            : yoga // ignore: cast_nullable_to_non_nullable
                  as PanchangDetail,
        karana: null == karana
            ? _value.karana
            : karana // ignore: cast_nullable_to_non_nullable
                  as PanchangDetail,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PanchangDailyModelImpl implements _PanchangDailyModel {
  const _$PanchangDailyModelImpl({
    required this.date,
    required this.dateAd,
    required this.vara,
    required this.tithi,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
  });

  factory _$PanchangDailyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PanchangDailyModelImplFromJson(json);

  @override
  final String date;
  @override
  final String dateAd;
  @override
  final VaraDetail vara;
  @override
  final PanchangDetail tithi;
  @override
  final PanchangDetail nakshatra;
  @override
  final PanchangDetail yoga;
  @override
  final PanchangDetail karana;

  @override
  String toString() {
    return 'PanchangDailyModel(date: $date, dateAd: $dateAd, vara: $vara, tithi: $tithi, nakshatra: $nakshatra, yoga: $yoga, karana: $karana)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PanchangDailyModelImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dateAd, dateAd) || other.dateAd == dateAd) &&
            (identical(other.vara, vara) || other.vara == vara) &&
            (identical(other.tithi, tithi) || other.tithi == tithi) &&
            (identical(other.nakshatra, nakshatra) ||
                other.nakshatra == nakshatra) &&
            (identical(other.yoga, yoga) || other.yoga == yoga) &&
            (identical(other.karana, karana) || other.karana == karana));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    dateAd,
    vara,
    tithi,
    nakshatra,
    yoga,
    karana,
  );

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PanchangDailyModelImplCopyWith<_$PanchangDailyModelImpl> get copyWith =>
      __$$PanchangDailyModelImplCopyWithImpl<_$PanchangDailyModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PanchangDailyModelImplToJson(this);
  }
}

abstract class _PanchangDailyModel implements PanchangDailyModel {
  const factory _PanchangDailyModel({
    required final String date,
    required final String dateAd,
    required final VaraDetail vara,
    required final PanchangDetail tithi,
    required final PanchangDetail nakshatra,
    required final PanchangDetail yoga,
    required final PanchangDetail karana,
  }) = _$PanchangDailyModelImpl;

  factory _PanchangDailyModel.fromJson(Map<String, dynamic> json) =
      _$PanchangDailyModelImpl.fromJson;

  @override
  String get date;
  @override
  String get dateAd;
  @override
  VaraDetail get vara;
  @override
  PanchangDetail get tithi;
  @override
  PanchangDetail get nakshatra;
  @override
  PanchangDetail get yoga;
  @override
  PanchangDetail get karana;

  /// Create a copy of PanchangDailyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PanchangDailyModelImplCopyWith<_$PanchangDailyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthEventsResponse _$MonthEventsResponseFromJson(Map<String, dynamic> json) {
  return _MonthEventsResponse.fromJson(json);
}

/// @nodoc
mixin _$MonthEventsResponse {
  String get fromDate => throw _privateConstructorUsedError;
  String get fromDateAd => throw _privateConstructorUsedError;
  String get toDate => throw _privateConstructorUsedError;
  String get toDateAd => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  int get totalDays => throw _privateConstructorUsedError;
  List<PanchangDailyModel> get days => throw _privateConstructorUsedError;

  /// Serializes this MonthEventsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthEventsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthEventsResponseCopyWith<MonthEventsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthEventsResponseCopyWith<$Res> {
  factory $MonthEventsResponseCopyWith(
    MonthEventsResponse value,
    $Res Function(MonthEventsResponse) then,
  ) = _$MonthEventsResponseCopyWithImpl<$Res, MonthEventsResponse>;
  @useResult
  $Res call({
    String fromDate,
    String fromDateAd,
    String toDate,
    String toDateAd,
    String location,
    int totalDays,
    List<PanchangDailyModel> days,
  });
}

/// @nodoc
class _$MonthEventsResponseCopyWithImpl<$Res, $Val extends MonthEventsResponse>
    implements $MonthEventsResponseCopyWith<$Res> {
  _$MonthEventsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthEventsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromDate = null,
    Object? fromDateAd = null,
    Object? toDate = null,
    Object? toDateAd = null,
    Object? location = null,
    Object? totalDays = null,
    Object? days = null,
  }) {
    return _then(
      _value.copyWith(
            fromDate: null == fromDate
                ? _value.fromDate
                : fromDate // ignore: cast_nullable_to_non_nullable
                      as String,
            fromDateAd: null == fromDateAd
                ? _value.fromDateAd
                : fromDateAd // ignore: cast_nullable_to_non_nullable
                      as String,
            toDate: null == toDate
                ? _value.toDate
                : toDate // ignore: cast_nullable_to_non_nullable
                      as String,
            toDateAd: null == toDateAd
                ? _value.toDateAd
                : toDateAd // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            totalDays: null == totalDays
                ? _value.totalDays
                : totalDays // ignore: cast_nullable_to_non_nullable
                      as int,
            days: null == days
                ? _value.days
                : days // ignore: cast_nullable_to_non_nullable
                      as List<PanchangDailyModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonthEventsResponseImplCopyWith<$Res>
    implements $MonthEventsResponseCopyWith<$Res> {
  factory _$$MonthEventsResponseImplCopyWith(
    _$MonthEventsResponseImpl value,
    $Res Function(_$MonthEventsResponseImpl) then,
  ) = __$$MonthEventsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String fromDate,
    String fromDateAd,
    String toDate,
    String toDateAd,
    String location,
    int totalDays,
    List<PanchangDailyModel> days,
  });
}

/// @nodoc
class __$$MonthEventsResponseImplCopyWithImpl<$Res>
    extends _$MonthEventsResponseCopyWithImpl<$Res, _$MonthEventsResponseImpl>
    implements _$$MonthEventsResponseImplCopyWith<$Res> {
  __$$MonthEventsResponseImplCopyWithImpl(
    _$MonthEventsResponseImpl _value,
    $Res Function(_$MonthEventsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MonthEventsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromDate = null,
    Object? fromDateAd = null,
    Object? toDate = null,
    Object? toDateAd = null,
    Object? location = null,
    Object? totalDays = null,
    Object? days = null,
  }) {
    return _then(
      _$MonthEventsResponseImpl(
        fromDate: null == fromDate
            ? _value.fromDate
            : fromDate // ignore: cast_nullable_to_non_nullable
                  as String,
        fromDateAd: null == fromDateAd
            ? _value.fromDateAd
            : fromDateAd // ignore: cast_nullable_to_non_nullable
                  as String,
        toDate: null == toDate
            ? _value.toDate
            : toDate // ignore: cast_nullable_to_non_nullable
                  as String,
        toDateAd: null == toDateAd
            ? _value.toDateAd
            : toDateAd // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        totalDays: null == totalDays
            ? _value.totalDays
            : totalDays // ignore: cast_nullable_to_non_nullable
                  as int,
        days: null == days
            ? _value._days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<PanchangDailyModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthEventsResponseImpl implements _MonthEventsResponse {
  const _$MonthEventsResponseImpl({
    required this.fromDate,
    required this.fromDateAd,
    required this.toDate,
    required this.toDateAd,
    required this.location,
    required this.totalDays,
    required final List<PanchangDailyModel> days,
  }) : _days = days;

  factory _$MonthEventsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthEventsResponseImplFromJson(json);

  @override
  final String fromDate;
  @override
  final String fromDateAd;
  @override
  final String toDate;
  @override
  final String toDateAd;
  @override
  final String location;
  @override
  final int totalDays;
  final List<PanchangDailyModel> _days;
  @override
  List<PanchangDailyModel> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  String toString() {
    return 'MonthEventsResponse(fromDate: $fromDate, fromDateAd: $fromDateAd, toDate: $toDate, toDateAd: $toDateAd, location: $location, totalDays: $totalDays, days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthEventsResponseImpl &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.fromDateAd, fromDateAd) ||
                other.fromDateAd == fromDateAd) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.toDateAd, toDateAd) ||
                other.toDateAd == toDateAd) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays) &&
            const DeepCollectionEquality().equals(other._days, _days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fromDate,
    fromDateAd,
    toDate,
    toDateAd,
    location,
    totalDays,
    const DeepCollectionEquality().hash(_days),
  );

  /// Create a copy of MonthEventsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthEventsResponseImplCopyWith<_$MonthEventsResponseImpl> get copyWith =>
      __$$MonthEventsResponseImplCopyWithImpl<_$MonthEventsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthEventsResponseImplToJson(this);
  }
}

abstract class _MonthEventsResponse implements MonthEventsResponse {
  const factory _MonthEventsResponse({
    required final String fromDate,
    required final String fromDateAd,
    required final String toDate,
    required final String toDateAd,
    required final String location,
    required final int totalDays,
    required final List<PanchangDailyModel> days,
  }) = _$MonthEventsResponseImpl;

  factory _MonthEventsResponse.fromJson(Map<String, dynamic> json) =
      _$MonthEventsResponseImpl.fromJson;

  @override
  String get fromDate;
  @override
  String get fromDateAd;
  @override
  String get toDate;
  @override
  String get toDateAd;
  @override
  String get location;
  @override
  int get totalDays;
  @override
  List<PanchangDailyModel> get days;

  /// Create a copy of MonthEventsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthEventsResponseImplCopyWith<_$MonthEventsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
