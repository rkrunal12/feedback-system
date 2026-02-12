import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  static late SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  Future<void> saveToken(String token) async {
    await _preferences.setString('token', token);
  }

  String getShopId() => "3161";
  Future<void> setShopId(String shopId) async {
    await _preferences.setString('shop_id', shopId);
  }
}
