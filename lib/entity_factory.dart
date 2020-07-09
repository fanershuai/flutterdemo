


//通过工厂解决 json转成T的问题吧


import 'src/entity/login_token_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    }  else if (T.toString() == "LoginTokenEntity") {
      return LoginTokenEntity.fromJson(json) as T;
    }else {
      return null;
    }
  }
}