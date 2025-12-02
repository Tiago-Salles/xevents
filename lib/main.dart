import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xevents/firebase_options.dart';
import 'core/router/app_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(ProviderScope(child: XEventsApp(app: app)));
}

class XEventsApp extends StatelessWidget {
  const XEventsApp({
    required this.app,
    super.key});
  final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;
    return MaterialApp.router(
      title: 'Xevents',
      theme: ThemeData(primarySwatch: Colors.indigo),
      routerConfig: router,
    );
  }
}
