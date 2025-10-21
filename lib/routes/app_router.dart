import 'package:flutter/material.dart';
import 'package:ppid/pages/login_page.dart';
import 'package:ppid/pages/activation_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginPage(),
  '/activation_page': (context) => const ActivationPage(),
};
