import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/widgets/menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zaptnzlvgnkeeffluvuw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphcHRuemx2Z25rZWVmZmx1dnV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NjI5MTUsImV4cCI6MjA3NTAzODkxNX0.nRKbCTQXpNyFRL0hhZNjqOUQ6JFQeFig81HIfmtHGQw',
  );

  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matriz Inmobiliaria',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
