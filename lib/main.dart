import 'package:flutter/material.dart';
import 'package:reservation_service_app/pages/homepage.dart';
import 'package:reservation_service_app/services/local_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalService.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Homepage());
  }
}
