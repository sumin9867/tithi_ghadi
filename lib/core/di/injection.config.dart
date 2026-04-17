// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/google_login_usecase.dart' as _i850;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/foreground_service/cubit/foreground_service_cubit.dart'
    as _i239;
import '../../features/splash/presentation/cubit/splash_cubit.dart' as _i125;
import '../network/auth_interceptor.dart' as _i908;
import '../network/dio_client.dart' as _i667;
import '../router/app_router.dart' as _i81;
import '../services/push_notification_service.dart' as _i63;
import '../services/secure_storage_service.dart' as _i535;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i239.ForegroundServiceCubit>(
      () => _i239.ForegroundServiceCubit(),
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => registerModule.firebaseMessaging,
    );
    gh.lazySingleton<_i81.AppRouter>(
      () => _i81.AppRouter(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i535.SecureStorageService>(
      () => _i535.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i908.AuthInterceptor>(
      () => _i908.AuthInterceptor(gh<_i535.SecureStorageService>()),
    );
    gh.lazySingleton<_i667.DioClient>(
      () => _i667.DioClient(gh<_i361.Dio>(), gh<_i908.AuthInterceptor>()),
    );
    gh.factory<_i125.SplashCubit>(
      () => _i125.SplashCubit(
        gh<_i535.SecureStorageService>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i63.PushNotificationService>(
      () => _i63.PushNotificationService(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i667.DioClient>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i535.SecureStorageService>(),
        gh<_i116.GoogleSignIn>(),
        gh<_i59.FirebaseAuth>(),
        gh<_i892.FirebaseMessaging>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i850.GoogleLoginUseCase>(
      () => _i850.GoogleLoginUseCase(gh<_i787.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
