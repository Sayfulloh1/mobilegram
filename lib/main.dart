import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobilegram/pages/home_page.dart';
import 'package:mobilegram/pages/login_page.dart';
import 'package:mobilegram/pages/register_page.dart';
import 'package:mobilegram/providers/auth_provider.dart';
import 'package:mobilegram/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Mobilegram',
        navigatorKey: NavigationService.instance.navigatorKey,
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(42, 117, 188, 1),
          useMaterial3: true,
          colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
            background: const Color.fromRGBO(28, 27, 27, 1),
            brightness: Brightness.dark,
          ),
        ),
        initialRoute: 'login',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case 'register':
              return MaterialPageRoute(builder: (context) => const RegistrationPage());
            case 'login':
              return MaterialPageRoute(builder: (context) => const LoginPage());
            default:
              return null;
          }
        },
        routes: {
          'login': (context) => const LoginPage(),
          'register': (context) => const RegistrationPage(),
          'home': (context) => const HomePage(),
          /*'login':(context)=>LoginPage(),
        'login':(context)=>LoginPage(),*/
        },
      ),
    );
  }
}
