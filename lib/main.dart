import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:app_pengaduan/theme/app_theme.dart';

import 'package:app_pengaduan/viewmodels/kb_view_model.dart';
import 'package:app_pengaduan/views/auth/login_page.dart';
import 'package:app_pengaduan/views/onboarding/onboarding_page.dart';
import 'package:app_pengaduan/views/dashboard.dart';
import 'package:app_pengaduan/views/auth/verification.dart';
import 'package:app_pengaduan/views/kategori_pengaduan.dart';
import 'package:app_pengaduan/views/kb_list_page.dart';
import 'package:app_pengaduan/views/keluarga_berencana.dart';
import 'package:app_pengaduan/viewmodels/auth_provider.dart';
import 'package:app_pengaduan/viewmodels/pengaduan_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KbViewModel()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PengaduanViewModel()),
      ],
      child: MaterialApp(
        title: 'Sistem Manajemen KB',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.user != null) {
              if (authProvider.isEmailVerified) {
                return const DashboardPage();
              } else {
                return const VerificationPage();
              }
            } else {
              return const OnboardingPage(); // Changed from LoginPage to OnboardingPage
            }
          },
        ),
        routes: {
          '/onboarding': (context) => const OnboardingPage(),
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/kategori': (context) => const KategoriPengaduanPage(),
          '/KeluargaBerencana': (context) => const KbListPage(),
          '/FormKB': (context) => const KbFormPage(),
        },
      ),
    );
  }
}