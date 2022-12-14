import 'package:dio/dio.dart';
import 'package:net_assistant/net_assistant.dart';
import 'package:net_assistant/src/model/json/json_convert_content.dart';
import 'package:net_assistant/src/token_interceptor.dart';
import 'package:net_assistant/src/model/api_response.dart';
import 'package:net_assistant/src/raw_data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exception.dart';

///失败回调
typedef FailureCallback = void Function(ApiResponse response);

///异常回调
typedef ErrorCallback<T> = bool Function(ApiException exception);

class NetAssistant {
  static late Dio _dio;

  static NetAssistant? _instance;

  NetAssistant._();

  static FailureCallback? _globalFailureHandler;
  static ErrorCallback? _globalErrorHandler;

  static TokenInterceptor? _tokenInterceptor;

  static NetAssistant get instance {
    if (_instance == null) {
      throw Exception('you must call init first');
    } else {
      return _instance!;
    }
  }

  static void init(
      {String? method,
      int? connectTimeout,
      int? receiveTimeout,
      int? sendTimeout,
      String baseUrl = '',
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? extra,
      Map<String, dynamic>? headers,
      ResponseType? responseType = ResponseType.json,
      String? contentType,
      ValidateStatus? validateStatus,
      bool? receiveDataWhenStatusError,
      bool? followRedirects,
      int? maxRedirects,
      RequestEncoder? requestEncoder,
      ResponseDecoder? responseDecoder,
      ListFormat? listFormat,
      setRequestContentTypeWhenNoPayload = false,
      bool logPrint = false,
      Map<String, JsonConvertFunction>? jsonConvertFuncMap,
      BaseConverter? converter,
      FailureCallback? globalFailureHandler,
      ErrorCallback? globalErrorHandler,
      TokenInterceptor? tokenInterceptor}) {
    _globalFailureHandler = globalFailureHandler;
    _globalErrorHandler = globalErrorHandler;
    _tokenInterceptor = tokenInterceptor ?? TokenInterceptor();
    _dio = Dio(BaseOptions(
      method: method,
      baseUrl: baseUrl,
      queryParameters: queryParameters,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      extra: extra,
      headers: headers,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      listFormat: listFormat,
      setRequestContentTypeWhenNoPayload: setRequestContentTypeWhenNoPayload,
    ));
    if (_tokenInterceptor != null) {
      _dio.interceptors.add(_tokenInterceptor!);
    }
    if (logPrint) {
      _dio.interceptors.add(PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 80));
    }
    _instance = NetAssistant._();
    if (jsonConvertFuncMap != null) {
      JsonConvert.convertFuncMap.addAll(jsonConvertFuncMap);
    }
    if (converter != null) {
      JsonConvert.converter = converter;
    }
  }

  Future<ApiResponse<T?>> request<T>(String url,
      {Method method = Method.get,
      Map<String, dynamic>? queryParameters,
      data,
      Map<String, dynamic>? headers,
      ErrorCallback? onError,
      bool throwException=false,
      String? dataKey = 'data'}) async {
    try {
      Options options = Options()
        ..method = method.name
        ..headers = headers;

      // data = _convertRequestData(data);

      Response response = await _dio.request(url,
          queryParameters: queryParameters, data: data, options: options);
      if (_checkStatusCode(response.statusCode)) {
        return  _handleResponse<T>(response, dataKey)..status=Status.success;
      } else if (_globalFailureHandler != null) {
        _globalFailureHandler!(_handleResponse<T>(response, dataKey));
      }
      return ApiResponse.failure(_handleResponse<T>(response, dataKey));
    } catch (e) {
      var exception = ApiException.from(e);
      //method onError is defined,will not run _globalOnErrorHandler
      if (onError != null) {
        throwException=onError(exception);
      } else if (_globalErrorHandler != null) {
        throwException=_globalErrorHandler!(exception);
      }
      if(throwException){
        throw exception;
      }else{
        return ApiResponse.error(exception);
      }
    }
  }

  bool _checkStatusCode(int? code) {
    if (code == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///请求响应内容处理
  ApiResponse<T?> _handleResponse<T>(Response response, dataKey) {
    if (response.statusCode == 200) {
      if (T.toString() == (RawData).toString()) {
        RawData raw = RawData();
        raw.value = response.data;
        ApiResponse<RawData> apiResponse = ApiResponse()..data = raw;
        return apiResponse as ApiResponse<T?>;
      } else {
        ApiResponse<T> apiResponse =
            ApiResponse<T>.fromJson(response.data, dataKey: dataKey);
        return _handleBusinessResponse<T>(apiResponse);
      }
    } else {
      var exception =
          ApiException(response.statusCode, ApiException.unknownException);
      throw exception;
    }
  }

  ///业务内容处理
  ApiResponse<T?> _handleBusinessResponse<T>(ApiResponse<T> response) {
    if (response.code == 200) {
      return response;
    } else {
      var exception = ApiException(response.code, response.msg);
      throw exception;
    }
  }

  void setAuth(Token model) {
    if (_tokenInterceptor != null) {
      _tokenInterceptor!.authModel = model;
    }
  }
}

enum Method {
  get('get'),
  put('put'),
  post('post'),
  update('update'),
  delete('delete');

  final String name;

  const Method(
    this.name,
  );
}
