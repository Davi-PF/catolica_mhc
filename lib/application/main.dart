import 'package:catolica_mhc/application/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'check_auth.dart';

Future<void> main() async {
  await initConfiguration();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Alata',
      useMaterial3: false,
    ),
    home: CheckAuth(),
  ));
}