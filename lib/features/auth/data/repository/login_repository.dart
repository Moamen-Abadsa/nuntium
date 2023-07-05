import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:nuntium/core/error_handler/error_handler.dart';
import 'package:nuntium/core/error_handler/response_code.dart';
import 'package:nuntium/core/internet_checker/internet_checker.dart';
import 'package:nuntium/core/resorces/manager_strings.dart';
import 'package:nuntium/features/auth/data/data_source/remote_login_data_source.dart';
import 'package:nuntium/features/auth/data/request/login_request.dart';

abstract class LoginRepository {
  Future<Either<Failure, void>> login(LoginRequest loginRequest);
}

class LoginRepositoryImplement implements LoginRepository {
  final RemoteLoginDataSource _remoteLoginDataSource;
  final NetworkInfo _networkInfo;

  LoginRepositoryImplement(
    this._remoteLoginDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, void>> login(LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteLoginDataSource.login(loginRequest);
      } catch (e) {
        debugger();
        return Left(
          ErrorHandler.handle(e).failure,
        );
      }

      return const Right(null);
    } else {
      return Left(
        Failure(
          ResponseCode.NO_INTERNET_CONNECTION.value,
          ManagerStrings.noInternetConnection,
        ),
      );
    }
  }
}
