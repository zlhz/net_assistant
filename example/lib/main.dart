import 'package:flutter/material.dart';
import 'dart:async';

import 'package:net_assistant/net_assistant.dart';
import 'package:net_assistant_example/generated/json/Converter.dart';
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
    NetAssistant.init(baseUrl: 'http://192.168.2.6:8080',
        converter: Converter(),
        jsonConvertFuncMap: JsonConvert.convertFuncMap,
        logPrint:true,
        headers: {
          "userType": "test",
        },
        globalErrorHandler:(ApiException exception){
            print(exception);
            return true;
        });
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
          onPressed: ()=>request(),
        ),
      ),
    );
  }

  Future<void> request() async {
    Token? token =await login();
    if(token!=null){
      NetAssistant.instance.setAuth(token);
      ApiResponse<List<TestEntity>?> listResponse = await NetAssistant.instance.request<List<TestEntity>>("/test/list?pageNum=1&pageSize=30",
          dataKey: 'rows');
      if(listResponse.data!=null  && listResponse.total!=null){
        print('${listResponse.data!.length}');
        print('total: ${listResponse.total!}');
      }
    }
  }


  Future<Token?> login() async{
    ApiResponse<String?> loginResponse = await NetAssistant.instance.request<String>("/login",method: Method.post,data: {
      'username': 'username',
      'password': 'password',
    },dataKey: 'token',onError: (ApiException exception){
          //if define onError here globalErrorHandler will not run
          print(exception);
          return true;
        });
    if(loginResponse.data!=null){
      return Token("Authorization", "Bearer ${loginResponse.data}");
    }else{
      return null;
    }
  }
}
