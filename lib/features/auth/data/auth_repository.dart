import 'dart:developer';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/features/auth/data/auth_api_service.dart';
import 'package:viovid_app/features/auth/data/auth_local_data_source_service.dart';
import 'package:viovid_app/features/auth/dtos/login_dto.dart';
import 'package:viovid_app/features/auth/dtos/refresh_token_dto.dart';
import 'package:viovid_app/features/auth/dtos/register_dto.dart';
import 'package:viovid_app/features/result_type.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final AuthLocalStorageService authLocalStorageService;

  AuthRepository({
    required this.authApiService,
    required this.authLocalStorageService,
  });

  Future<Result<bool>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await authApiService.register(
        RegisterDto(email: email, password: password, name: name),
      );
      return Success(true);
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result> login({
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
      dio.options.headers = {
        'Authorization':
            'Bearer ${loginSuccessDto.accessToken}', // Thêm Bearer token vào header
      };
      return Success(true);
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<bool> isAccessTokenExpired() async {
    final accessToken = await authLocalStorageService.getAccessToken();
    if (accessToken != null) {
      final payload = JwtDecoder.decode(accessToken);
      final expiry = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      final isExpired = DateTime.now().isAfter(expiry);
      if (isExpired) {
        return true;
      } else {
        log('AccessToken = $accessToken');
        dio.options.headers = {
          'Authorization':
              'Bearer $accessToken', // Thêm Bearer token vào header
        };
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> refreshToken() async {
    final accessToken = await authLocalStorageService.getAccessToken();
    final refreshToken = await authLocalStorageService.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      try {
        log('Refreshing Token ... 🔄🔄🔄');
        final refreshTokenSuccessDto = await authApiService.refreshToken(
          RefreshTokenDto(accessToken: accessToken, refreshToken: refreshToken),
        );
        await authLocalStorageService
            .saveAccessToken(refreshTokenSuccessDto.accessToken);
        await authLocalStorageService
            .saveRefreshToken(refreshTokenSuccessDto.refreshToken);
        dio.options.headers = {
          'Authorization':
              'Bearer ${refreshTokenSuccessDto.accessToken}', // Thêm Bearer token vào header
        };
        return true;
      } catch (e) {
        log('Refreshing FAILED ... ❌❌❌');
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Result> logout() async {
    try {
      await authApiService.logout();
      await authLocalStorageService.clearTokens();
      return Success(true);
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
