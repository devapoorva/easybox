import 'dart:convert';

import 'package:easybox/dashboard/dashboard.dart';
import 'package:easybox/helper/shared_prefs_helper.dart';
import 'package:easybox/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  var isLoading = false.obs;

  String loginkey="isLogin";
  bool? isLogin=false;

  Future<void> handleLogin(Map<String, dynamic> response) async {
    if (response.containsKey('user') && response.containsKey('token')) {
      String email = response['user']['email'];
      String token = response['token'];
      await SharedPrefsHelper.setLoggedIn(true);
      await SharedPrefsHelper.setEmail(email);
      await SharedPrefsHelper.setToken(token);
      Get.offAll(() => Dashboard());
    }
  }


  void loginApi() async {
    try {
      isLoading.value = true;
      final response = await post(
        Uri.parse('https://www.easybox.in/Dataentry/api/login'),
        body: {
          'email': emailController.value.text,
          'password': passwordController.value.text
        },
      );

      var data = jsonDecode(response.body);
      print(data);

      if (response.statusCode == 200) {
        isLoading.value = false;
        handleLogin(data);
        _showSuccessSnackbar(
          title: "Login Successful",
          message: 'Welcome to EasyBox!',
          icon: Icons.check_circle,
        );
      } else {
        isLoading.value = false;
        _showErrorSnackbar(
          title: "Login Failed",
          message: data['error'] ?? 'Invalid credentials',
          icon: Icons.error_outline,
        );
      }
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar(
        title: "Error Occurred",
        message: 'An unexpected error occurred',
        icon: Icons.warning_amber_rounded,
      );
    }
  }

  void skipLogin()async
  {
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    isLogin=prefs.getBool(loginkey);
    print(isLogin);
    if(isLogin==true)
      {
        Get.to(Dashboard());
      }
    else
      {
       Get.to(LoginForm());
      }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginkey, false);
    await prefs.remove("token");
    Get.offAllNamed("/login");
  }


  void _showSuccessSnackbar({required String title, required String message, required IconData icon}) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(15),
      duration: Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 2,
          offset: Offset(0, 3),
        ),
      ],
      overlayBlur: 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'DISMISS',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showErrorSnackbar({required String title, required String message, required IconData icon}) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      borderRadius: 12,
      margin: EdgeInsets.all(15),
      duration: Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.elasticInOut,
      reverseAnimationCurve: Curves.easeOut,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 3,
          offset: Offset(0, 5),
        ),
      ],
      overlayBlur: 0.8,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'OK',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}