import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../firebase_options.dart';
import '../services/auth_service.dart';

Future<void> initConfiguration() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // GetX Bindings
  Get.lazyPut<AuthService>(() => AuthService());
}
