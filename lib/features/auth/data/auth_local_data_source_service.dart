import 'package:shared_preferences/shared_preferences.dart';
import 'package:viovid_app/features/auth/data/constants.dart';

class AuthLocalStorageService {
  AuthLocalStorageService(this.sf);

  final SharedPreferences sf;

  // Lưu accessToken
  Future<void> saveAccessToken(String token) async {
    await sf.setString(AuthDataConstants.accessToken, token);
  }

  // Truy xuất accessToken
  Future<String?> getAccessToken() async {
    return sf.getString(AuthDataConstants.accessToken);
  }

  // Xóa accessToken
  Future<void> deleteToken() async {
    await sf.remove(AuthDataConstants.accessToken);
  }

  // Lưu refreshToken
  Future<void> saveRefreshToken(String refreshToken) async {
    await sf.setString(AuthDataConstants.refreshToken, refreshToken);
  }

  // Truy xuất refreshToken
  Future<String?> getRefreshToken() async {
    return sf.getString(AuthDataConstants.refreshToken);
  }

  // Xóa refreshToken
  Future<void> deleteRefreshToken() async {
    await sf.remove(AuthDataConstants.refreshToken);
  }

  // Xóa cả accessToken và refreshToken
  Future<void> clearTokens() async {
    await Future.wait([
      deleteToken(),
      deleteRefreshToken(),
    ]);
  }
}
