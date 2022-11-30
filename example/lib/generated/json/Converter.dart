
import 'package:net_assistant/net_assistant.dart';

import 'base/json_convert_content.dart';

class Converter extends BaseConverter{

  @override
  M? getListChildType<M>(List<Map<String, dynamic>> data) {
    return JsonConvert.getListChildType<M>(data);
  }
}