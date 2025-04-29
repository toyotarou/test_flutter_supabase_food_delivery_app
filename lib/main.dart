import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/auth/login_screen.dart';
import 'pages/screen/onbording_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://moklsridzuhriorztfcj.supabase.co',

    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1va2xzcmlkenVocmlvcnp0ZmNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU4Mzg3MzAsImV4cCI6MjA2MTQxNDczMH0.HLfkuSu3DXV1lKU4kbArHuwgn4ajxU74B4u1kI5sTx4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AuthCheck());
  }
}

class AuthCheck extends StatelessWidget {

  AuthCheck({super.key});
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot) {
        final Session? session = supabase.auth.currentSession;
        if (session != null) {
          return const OnbordingScreen(); // if logged in, go to home screen
        } else {
          return const LoginScreen(); // otherwise, show login screen
        }
      },
    );
  }
}
