import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuntium/core/resorces/manager_strings.dart';

class Failure {
  int code;
  String message;

  Failure(this.code, this.message);
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      failure = Failure(
        400,
        error.response?.data['message'] ?? error.response?.data['errors'].toString() ?? ManagerStrings.error,
      );
    } else if (error is FirebaseAuthException) {
      failure = Failure(400, error.code);
    } else {
      failure = Failure(400, ManagerStrings.badRequest);
    }
  }
}
