
import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferenceUtil {
  static const String KEY_LOGIN_PHONE= "loginphone";
  static const String KEY_LOGIN_PWD = "loginpwd";
  static const String KEY_TOKEN = "token";
  static const String KEY_USER = "user";

  // 异步保存
  static Future save(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  // 异步读取
  static Future<String> get(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
}
