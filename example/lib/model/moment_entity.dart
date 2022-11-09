import 'dart:convert';

import 'package:net_assistant_example/generated/json/moment_entity.g.dart';

class TestEntity {

	late double id;
	late String content;
  
  TestEntity();

  factory TestEntity.fromJson(Map<String, dynamic> json) => $MomentEntityFromJson(json);

  Map<String, dynamic> toJson() => $MomentEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}