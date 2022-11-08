import 'dart:convert';

import 'package:net_assistant/src/model/json/json_convert_content.dart';

class ApiResponse<T> {

	int? code;
	String? msg;
	T? data;

  ApiResponse();

  factory ApiResponse.fromJson(Map<String, dynamic> json,{dataKey}) => $ApiResponseFromJson<T>(json,dataKey: dataKey);

  Map<String, dynamic> toJson() => $ApiResponseToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

ApiResponse<T> $ApiResponseFromJson<T>(Map<String, dynamic> json,{dataKey = 'data'}) {
  final ApiResponse<T> apiResponse = ApiResponse();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    apiResponse.code = code;
  }
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    apiResponse.msg = msg;
  }
  final T? data = JsonConvert.fromJsonAsT<T>(json[dataKey]);
  if (data != null) {
    apiResponse.data = data;
  }
  return apiResponse;
}

Map<String, dynamic> $ApiResponseToJson(ApiResponse entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['msg'] = entity.msg;
  data['data'] = entity.data?.toJson();
  return data;
}