import 'package:flutter/material.dart';
import 'app_config.dart';
import 'app.dart';

void main() {
  AppConfig.init(Flavor.prod);
  runApp(const MyApp());
}
