import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/customer_list_screen.dart';

class LoginController extends GetxController {
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  var userIdError = ''.obs;
  var passwordError = ''.obs;

  void validateAndLogin() {
    String userId = userIdController.text.trim();
    String password = passwordController.text.trim();

    userIdError.value = '';
    passwordError.value = '';
    if (userId != 'user@maxmobility.in') {
      userIdError.value = 'Invalid user ID. Use user@maxmobility.in';
    }
    if (password != 'Abc@#123') {
      passwordError.value = 'Invalid password. Use Abc@#123';
    }

    if (userId == 'user@maxmobility.in' && password == 'Abc@#123') {
      Get.snackbar(
        'Alert',
        'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );

      Get.to(() => const CustomerListScreen());
    }


  }

  @override
  void onClose() {
    userIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

