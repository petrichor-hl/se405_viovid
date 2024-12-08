import 'dart:developer';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:viovid_app/features/auth/data/auth_api_service.dart';
import 'package:viovid_app/features/auth/data/auth_local_data_source_service.dart';
import 'package:viovid_app/features/auth/dtos/login_dto.dart';
import 'package:viovid_app/features/auth/dtos/refresh_token_dto.dart';
import 'package:viovid_app/features/result_type.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final AuthLocalStorageService authLocalStorageService;

  AuthRepository({
    required this.authApiService,
    required this.authLocalStorageService,
  });

  Future<Result<bool>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginSuccessDto = await authApiService.login(
        LoginDto(email: email, password: password),
      );
      await authLocalStorageService
          .saveAccessToken(loginSuccessDto.accessToken);
      await authLocalStorageService
          .saveRefreshToken(loginSuccessDto.refreshToken);
      return Success(true);
    } catch (error) {
      print(error);
      return Failure('$error');
    }
  }

  Future<bool> isAccessTokenExpired() async {
    final accessToken = await authLocalStorageService.getAccessToken();
    if (accessToken != null) {
      final payload = JwtDecoder.decode(accessToken);
      final expiry = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      return DateTime.now().isAfter(expiry);
    } else {
      return false;
    }
  }

  Future<bool> refreshToken() async {
    final accessToken = await authLocalStorageService.getAccessToken();
    final refreshToken = await authLocalStorageService.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      try {
        final loginSuccessDto = await authApiService.refreshToken(
          RefreshTokenDto(accessToken: accessToken, refreshToken: refreshToken),
        );
        await authLocalStorageService
            .saveAccessToken(loginSuccessDto.accessToken);
        await authLocalStorageService
            .saveRefreshToken(loginSuccessDto.refreshToken);
        return true;
      } catch (e) {
        log('$e');
        return false;
      }
    } else {
      return false;
    }
  }
}
