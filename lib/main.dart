import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'theme/app_theme.dart';
import 'utilities/app_storage.dart';
import 'view/start_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([.portraitUp]);
  await AppStorage.load();
  runApp(const TypeFighterApp());
}

class TypeFighterApp extends StatelessWidget {
  const TypeFighterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TypeFighter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const StartScreenView(),
    );
  }
}
