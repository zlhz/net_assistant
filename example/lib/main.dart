import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:net_assistant/net_assistant.dart';

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
    NetAssistant.init(baseUrl: 'https://api.xxx.com');
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
      NetAssistant.instance.setAuth(Token("Authorization", "Bearer $data"));
      response=data;
      setState(() {

      });
    }
  }
}
