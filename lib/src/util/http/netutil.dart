import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../sharedpreferenceutil.dart';
import '../toast.dart';

import 'result_data_entity.dart';
import 'resultcode.dart';
import 'net.dart';

/// 请求方法.
class Method {
  static const String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

class ContentType {
  static const String json = "application/json; charset=utf-8";
  static const String formData = "application/x-www-form-urlencoded";
}

class DioNetUtils {
  static final DioNetUtils _singleton = DioNetUtils._init();
  static Dio _dio;

  /// 是否是debug模式.
  static bool _isDebug = true;

  /// 打开debug模式.
  static void openDebug() {
    _isDebug = true;
  }

  void netPrint(Object log) {
    if (_isDebug) {
      print(log);
    }
  }

  DioNetUtils._init() {
    print("dio初始化了一次");
    BaseOptions options = new BaseOptions(
      baseUrl: Net.host,
      connectTimeout: 1000 * 1,
      receiveTimeout: 1000 * 2,
      //Http请求头.
      headers: {
        //可以增加token之类的
        "version": "1.0.0"
      },
      //请求的Content-Type，默认值是"application/json; charset=utf-8". 也可以用"application/x-www-form-urlencoded"
      // contentType: "application/json; charset=utf-8",
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    _dio = Dio(options);
    //添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      netPrint("请求之前处理");
      return options; //continue
    }, onResponse: (Response response) {
      netPrint("响应之前处理");
      netPrint(options);
      return response; // continue
    }, onError: (DioError e) {
      netPrint("错误之前提示");
      Response errorInfo = _dealErrorInfo(e);
      return errorInfo; //continue
    }));
  }

  factory DioNetUtils() {
    return _singleton;
  }

  /**
   * 请求方法
   */



  Future<Data<T>> request<T>(String path, {
    BuildContext context,
    String method = Method.get,
    String contentType = ContentType.json,
    queryParameters,
    Options options,
    Function(T) success, //暂时不用
    Function(T) error, //暂时不用

    // CancelToken cancelToken,
  }) async {
    netPrint('path===' + path);

    //增加 头部token

    if (_dio.options.headers['Authorization'] == null ||
        _dio.options.headers['Authorization'].toString() == '') {
      netPrint('加载token' + _dio.options.headers['Authorization'].toString());
      SharedPreferenceUtil.get(SharedPreferenceUtil.KEY_TOKEN).then((value) =>
      _dio.options.headers['Authorization'] = value);
    }
    Response response;
    if (method == Method.get) {
      //GET方式
      response = await _dio.request(
        path,
        queryParameters: queryParameters,
        options: _checkOptions(method, contentType, options),
        // cancelToken: cancelToken,
      );
    } else {
      //除GET的其他方式
      var requestData;
      netPrint(contentType);
      if (contentType == ContentType.formData) {
        //表单方式
        requestData = new FormData.fromMap(queryParameters);
      } else {
        //json格式
        requestData = queryParameters;
      }
      response = await _dio.request(
        path,
        data: requestData,
        options: _checkOptions(method, contentType, options),
        // cancelToken: cancelToken,
      );
    }

    _printHttpLog(response);
    if (response.statusCode == 200) {
      try {
        if (response.data is Map) {
          ResultDataEntity resultDataEntity =
          ResultDataEntity<T>.fromJson(response.data);

          if (resultDataEntity.code != ResultCode.SUCCESS) {
            Toast.warning(context, msg: response.data["message"]);
            return new Future.error(new DioError(
              response: response,
              type: DioErrorType.RESPONSE,
            ));
          }
          // 由于不同的接口返回的格式不固定不规范，所以需要根据接口格式自定义.
          //success(resultDataEntity.data);这里全部用Future处理了，就不用onsucess了，后期如果有需要可以放开
          return resultDataEntity.data;
        } else if (response.data is List) {
          if (response.data is List) {
            ResultDataListEntity resultDataListEntity =
            ResultDataListEntity<T>.fromJson(response.data);
            return resultDataListEntity.data;
          }
        }
      } catch (e) {
        Toast.warning(context, msg: "网络连接不可用，请稍后重试");
        return new Future.error(new DioError(
          response: response,
          type: DioErrorType.RESPONSE,
        ));
      }
    }
    Toast.warning(context, msg: "网络连接不可用，请稍后重试");
    return new Future.error(new DioError(
      response: response,
      type: DioErrorType.RESPONSE,
    ));
  }

  /// check Options.
  Options _checkOptions(method, contentType, options) {
    if (options == null) {
      options = new Options();
    }
    // if (contentType) {
    //   //设置请求的类型 json 表单
    //   options.contentType = contentType;
    // }
    options.method = method;
    return options;
  }

  // print Http Log.
  void _printHttpLog(Response response) {
    netPrint(!_isDebug);
    if (!_isDebug) {
      return;
    }
    try {
      netPrint("----------------Http Log Start----------------" +
          _getOptionsStr(response.request));
      netPrint(response);
      netPrint("----------------Http Log end----------------");
    } catch (ex) {
      netPrint("Http Log" + " error......");
    }
  }

  // get Options Str.
  String _getOptionsStr(RequestOptions request) {
    return "method: " +
        request.method +
        "  baseUrl: " +
        request.baseUrl +
        "  path: " +
        request.path;
  }

// 错误全局处理
  _dealErrorInfo(error) {
    netPrint(error.type);
    // 请求错误处理
    Response errorResponse;
    if (error.response != null) {
      errorResponse = error.response;
    } else {
      errorResponse = new Response(statusCode: 201);
    }
    // 请求超时
    if (error.type == DioErrorType.CONNECT_TIMEOUT) {
      netPrint("网络请求超时，请稍后重试");
      errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
    }
    // 请求连接超时
    else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
      netPrint("网络连接超时，请稍后重试");
      errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
    }
    // 服务器错误
    else if (error.type == DioErrorType.RESPONSE) {
      netPrint("服务器繁忙，请稍后重试");
      errorResponse.statusCode = ResultCode.RESPONSE;
    }
    // 一般服务器错误
    else {
      netPrint("网络连接不可用，请稍后重试1");
      errorResponse.statusCode = ResultCode.DEFAULT;
    }
    return errorResponse;
  }
}
