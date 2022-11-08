import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:net_assistant/src/model/token.dart';

class TokenInterceptor extends Interceptor{

  TokenInterceptor();

  Token? _token;

  void set authModel(Token authModel){
    _token = authModel;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(_token!=null&&_token!.key!=null&& _token!.value!=null){
      options.headers[_token!.key!] = _token!.value;
    }

    // options.headers["response-status"] = 401;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}