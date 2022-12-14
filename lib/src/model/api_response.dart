import 'dart:convert';

import 'package:net_assistant/src/model/json/json_convert_content.dart';

import '../../net_assistant.dart';

class ApiResponse<T> {

	late int code;
  late Status status;
	late String msg;
  int? total;
	T? data;
  ApiException? exception;
  ApiResponse();
  factory ApiResponse.fromJson(Map<String, dynamic> json,{dataKey}) => $ApiResponseFromJson<T>(json,dataKey: dataKey)..status=Status.success;
  factory ApiResponse.failure(ApiResponse response) =>ApiResponse()..code=-1..msg=response.msg..status=Status.failure;
  factory ApiResponse.error(ApiException? exception) =>ApiResponse()..code=-1..msg=exception==null?'未知异常':exception.message??'未知异常'..exception=exception..status=Status.error;
  Map<String, dynamic> toJson() => $ApiResponseToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

ApiResponse<T> $ApiResponseFromJson<T>(Map<String, dynamic> json,{String? dataKey = 'data'}) {
  final ApiResponse<T> apiResponse = ApiResponse();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    apiResponse.code = code;
  }else{
    apiResponse.code = -1;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    apiResponse.msg = msg;
  }else{
    apiResponse.msg = '';
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    apiResponse.total = total;
  }
  final T? data = JsonConvert.fromJsonAsT<T>(json[dataKey]);
  if (data != null) {
    apiResponse.data = data;
  }
  return apiResponse;
}

enum Status {
  success,
  error,
  failure,
}


Map<String, dynamic> $ApiResponseToJson(ApiResponse entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['total'] = entity.total;
  data['data'] = entity.data?.toJson();
  return data;
}