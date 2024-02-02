import 'package:flutter/material.dart';
import './pages/splash_screen.dart';
import './pages/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    SplashScreen(
        key: UniqueKey(),
        onInitializationComplete: () => runApp(ProviderScope(child: MyApp()))),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flicked",
      initialRoute: 'home',
      routes: {'home': (BuildContext context) => HomeScreen()},
      theme: ThemeData(
          primaryColor: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}
