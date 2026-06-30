import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/vpn_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NsProxyApp());
}

class NsProxyApp extends StatelessWidget {
  const NsProxyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VpnProvider()..initialize(),
      child: MaterialApp(
        title: 'NS Proxy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
