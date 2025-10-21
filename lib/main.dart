import 'package:flutter/material.dart';
import 'package:ppid/routes/app_router.dart';
import 'package:ppid/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // gunakan initialRoute dan definisikan '/' di routes
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        ...appRoutes, // gabungkan dengan routes lain dari app_router.dart
      },
    );
  }
}
