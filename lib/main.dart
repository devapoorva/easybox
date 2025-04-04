import 'package:easybox/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'form/farmData.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Box Service',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: false,
      ),
      initialRoute: "/",
getPages: [
  GetPage(name: "/", page: ()=>Home1()),
  GetPage(name: "/login", page: ()=>LoginForm()),
  GetPage(name: "/form", page: ()=>MyForm()),

],
    );
  }
}


