import 'package:dartz/dartz.dart';
import 'package:tithi_gadhi/core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> appStarted();
  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, Unit>> logout();
}
