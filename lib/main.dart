import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/injector/dependency_injector.dart' as di;
import 'core/core.dart';
import 'ui/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApiDataProvider>(
          create: (_) => sl<ApiDataProvider>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          splashFactory: InkRipple.splashFactory,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: HomePage.id,
        routes: {
          HomePage.id: (_) => const HomePage(),
          EditPage.id: (_) => const EditPage(),
          ShareToPage.id: (_) => const ShareToPage(),
          SaveSharePage.id: (_) => const SaveSharePage(),
        },
      ),
    );
  }
}
