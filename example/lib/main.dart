import 'package:flutter/material.dart';
import 'dart:async';

import 'package:net_assistant/net_assistant.dart';
import 'package:net_assistant_example/generated/json/base/json_convert_content.dart';
import 'package:net_assistant_example/model/moment_entity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String response ='';
  @override
  void initState() {
    super.initState();
    NetAssistant.init(baseUrl: 'https://api.xxx.com',
        jsonListChildCovertFunc: JsonConvert.getListChildType,
        jsonConvertFuncMap: JsonConvert.convertFuncMap);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('response is:\n$response'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.near_me
          ),
          onPressed: ()=>login(),
        ),
      ),
    );
  }
  Future<void> login() async {
    String? data = await NetAssistant.instance.post<String>("/login",data: {
      'username':"username",
      'password':"password",
    },dataKey: 'token');
    if(data!=null){
      NetAssistant.instance.setAuth(Token("Authorization", "Bearer ${data}"));
      response=data;
      setState(() {

      });
    }
    List<TestEntity>? testList = await NetAssistant.instance.get<List<TestEntity>>("/test//list?pageNum=1&pageSize=100",
    dataKey: 'rows');
    print('${testList!.length}');
  }
}
