import 'package:net_assistant_example/generated/json/base/json_convert_content.dart';
import 'package:net_assistant_example/model/moment_entity.dart';

TestEntity $MomentEntityFromJson(Map<String, dynamic> json) {
	final TestEntity testEntity = TestEntity();
	final double? id = jsonConvert.convert<double>(json['id']);
	if (id != null) {
		testEntity.id = id;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		testEntity.content = content;
	}
	return testEntity;
}

Map<String, dynamic> $MomentEntityToJson(TestEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['content'] = entity.content;
	return data;
}