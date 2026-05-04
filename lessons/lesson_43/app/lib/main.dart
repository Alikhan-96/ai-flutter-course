import 'package:flutter/material.dart';
import 'app_config.dart';
import 'app.dart';

void main() {
  AppConfig.init(Flavor.dev);
  runApp(const MyApp());
}
