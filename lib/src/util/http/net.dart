import 'package:flutter/material.dart';
import 'package:flutter_app_demo/src/entity/login_token_entity.dart';

import 'netutil.dart';
import 'result_data_entity.dart';

class Net {
  static const String host = 'http://frontapi.shidaceping.com';

  static DioNetUtils netUtils = new DioNetUtils();

  /*********************************请求方法**********************************************************/

  /**
   * 登录
   */
  static Future<Data<LoginTokenEntity>> getToken(BuildContext context,
          {params,
          Function(LoginTokenEntity) success,
          Function(LoginTokenEntity) error}) =>
      netUtils.request<LoginTokenEntity>(
        '/api/v1/mobile/user/account-login/',
        context: context,
        method: Method.post,
        contentType: ContentType.formData,
        queryParameters: params,
      );
}
