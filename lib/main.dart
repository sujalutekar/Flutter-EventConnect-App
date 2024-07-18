import 'package:event_connect/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './constants/app_theme.dart';
import './pages/home/ui/home_page.dart';
import './authentication/auth services/auth_services.dart';
import './authentication/onboarding/pages/welcome_page.dart';
import './pages/organization/organization_provider/add_user_to_org.dart';
import './pages/organization/organization_provider/add_organization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthServices(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddOrganization(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddUser(),
        ),
      ],
      child: MaterialApp(
        title: 'Event Connect',
        theme: AppThemes.darkTheme,
        darkTheme: AppThemes.darkTheme,
        home: StreamBuilder(
          stream: AuthServices().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return const BottomNavBar();
            } else {
              return const WelcomePage();
            }
          },
        ),
      ),
    );
  }
}
