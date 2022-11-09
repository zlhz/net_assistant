import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:net_assistant/src/model/json/json_convert_content.dart';
import 'package:net_assistant/src/token_interceptor.dart';
import 'package:net_assistant/src/model/api_response.dart';
import 'package:net_assistant/src/model/token.dart';
import 'package:net_assistant/src/exception.dart';
import 'package:net_assistant/src/config.dart';
import 'package:net_assistant/src/raw_data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetAssistant {
  static late Dio _dio;

  static NetAssistant? _instance;
  // factory RequestClient() => instance;
  NetAssistant._();

  static late TokenInterceptor _tokenInterceptor;
  static NetAssistant get instance {
    if(_instance==null){
      throw Exception('you must call init first');
    }else {
      return _instance!;
    }
  }

  static void init({
    String? method,
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
    request = true,
    requestHeader = true,
    requestBody = true,
    responseHeader = true,
    responseBody = true,
    error = true,
    maxWidth = 90,
    compact = true,
    logPrint = print,
    Map<String, JsonConvertFunction>? jsonConvertFuncMap,
    ListJsonConvertFunction? jsonListChildCovertFunc,}) {
    _tokenInterceptor = TokenInterceptor();
    _dio = Dio(
        BaseOptions(method: method,
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
          receiveDataWhenStatusError:receiveDataWhenStatusError,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects,
          requestEncoder: requestEncoder,
          responseDecoder: responseDecoder,
          listFormat: listFormat,
          setRequestContentTypeWhenNoPayload: setRequestContentTypeWhenNoPayload,));
    _dio.interceptors.add(_tokenInterceptor);
    _dio.interceptors.add(PrettyDioLogger(
        request: request,
        requestHeader: requestHeader,
        requestBody: requestBody,
        responseBody: responseBody,
        responseHeader: responseHeader,
        error: error,
        compact: compact,
        maxWidth: maxWidth));
    _instance = NetAssistant._();
    if(jsonConvertFuncMap!=null){
      JsonConvert.convertFuncMap.addAll(jsonConvertFuncMap);
    }
    if(jsonListChildCovertFunc!=null){
      JsonConvert.jsonListChildCovertFunc=jsonListChildCovertFunc;
    }
  }

  Future<T?> request<T>(
      String url, {
        String method = "Get",
        Map<String, dynamic>? queryParameters,
        data,
        Map<String, dynamic>? headers,
        bool Function(ApiException)? onError,
        dataKey
      }) async {
    try {
      Options options = Options()
        ..method = method
        ..headers = headers;

      // data = _convertRequestData(data);

      Response response = await _dio.request(url,
          queryParameters: queryParameters, data: data, options: options);

      return _handleResponse<T>(response,dataKey);
    } catch (e) {
      var exception = ApiException.from(e);
      if(onError?.call(exception) != true){
        throw exception;
      }
    }

    return null;
  }

  Future<T?> get<T>(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool showLoading = true,
        bool Function(ApiException)? onError,dataKey
      }) {
    return request(url,
        queryParameters: queryParameters,
        headers: headers,
        onError: onError,dataKey: dataKey);
  }

  Future<T?> post<T>(
      String url, {
        Map<String, dynamic>? queryParameters,
        data,
        dataKey,
        Map<String, dynamic>? headers,
        bool showLoading = true,
        bool Function(ApiException)? onError,
      }) {
    return request(url,
        method: "POST",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        onError: onError,dataKey: dataKey);
  }

  Future<T?> delete<T>(
      String url, {
        Map<String, dynamic>? queryParameters,
        data,
        dataKey,
        Map<String, dynamic>? headers,
        bool showLoading = true,
        bool Function(ApiException)? onError,
      }) {
    return request(url,
        method: "DELETE",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        onError: onError,dataKey: dataKey);
  }

  Future<T?> put<T>(
      String url, {
        Map<String, dynamic>? queryParameters,
        data,
        dataKey,
        Map<String, dynamic>? headers,
        bool showLoading = true,
        bool Function(ApiException)? onError,
      }) {
    return request(url,
        method: "PUT",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        onError: onError,dataKey: dataKey);
  }

  ///请求响应内容处理
  T? _handleResponse<T>(Response response,dataKey) {
    if (response.statusCode == 200) {
      if(T.toString() == (RawData).toString()){
        RawData raw = RawData();
        raw.value = response.data;
        return raw as T;
      }else {
        ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(response.data,dataKey:dataKey);
        return _handleBusinessResponse<T>(apiResponse);
      }
    } else {
      var exception = ApiException(response.statusCode, ApiException.unknownException);
      throw exception;
    }
  }

  ///业务内容处理
  T? _handleBusinessResponse<T>(ApiResponse<T> response) {
    if (response.code == RequestConfig.successCode) {
      return response.data;
    } else {
      var exception = ApiException(response.code, response.msg);
      throw exception;
    }
  }

  void setAuth(Token model){
    _tokenInterceptor.authModel=model;
  }
}
