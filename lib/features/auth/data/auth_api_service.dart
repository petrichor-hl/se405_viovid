import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/auth/dtos/login_dto.dart';
import 'package:viovid_app/features/auth/dtos/login_success_dto.dart';
import 'package:viovid_app/features/auth/dtos/refresh_token_dto.dart';
import 'package:viovid_app/features/auth/dtos/refresh_token_success_dto.dart';

class AuthApiService {
  AuthApiService(this.dio);

  final Dio dio;

  Future<LoginSuccessDto> login(LoginDto loginDto) async {
    try {
      return await ApiClient(dio).request<LoginDto, LoginSuccessDto>(
        url: '/Account/login',
        method: ApiMethod.post,
        payload: loginDto,
        fromJson: (resultJson) => LoginSuccessDto.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  // Future<void> register(RegisterDto registerDto) async {
  //   try {
  //     await dio.post(
  //       '/auth/register',
  //       data: registerDto.toJson(),
  //     );
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       throw Exception(e.response!.data['message']);
  //     } else {
  //       throw Exception(e.message);
  //     }
  //   }
  // }

  Future<RefreshTokenSuccessDto> refreshToken(
    RefreshTokenDto refreshTokenDto,
  ) async {
    try {
      final response = await dio.post(
        '/Account/refresh',
        data: refreshTokenDto.toJson(),
      );
      return RefreshTokenSuccessDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
