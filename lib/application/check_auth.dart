import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../pages_default/dashboard.dart';
import '../pages_default/login.dart';
import '../services/auth_service.dart';


class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AuthService.to.userIsAuthenticated.value
        ? DashBoard()
        : Home());
  }
}
