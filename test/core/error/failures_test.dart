import 'package:flutter_boilerplate/app/constants/app_string.dart';
import 'package:flutter_boilerplate/core/error/exceptions.dart';
import 'package:flutter_boilerplate/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('catchFailure', () {
    test('maps 401 to UnauthorizedFailure', () {
      expect(
        catchFailure(ApiException(401, 'Token expired')),
        const UnauthorizedFailure('Token expired'),
      );
    });

    test('maps timeout and no connection to NetworkFailure', () {
      expect(
        catchFailure(ApiException(408, 'Request Time Out')),
        const NetworkFailure('Request Time Out', 408),
      );
      expect(
        catchFailure(ApiException(503, 'No internet connection')),
        const NetworkFailure('No internet connection', 503),
      );
    });

    test('maps other API errors to ServerFailure with the server message', () {
      expect(
        catchFailure(ApiException(422, 'Email already used')),
        const ServerFailure('Email already used', 422),
      );
    });

    test('maps unexpected errors to UnknownFailure', () {
      expect(
        catchFailure(const FormatException('bad json')),
        const UnknownFailure(),
      );
      expect(catchFailure(StateError('x')).message, AppString.unknownError);
    });
  });
}
