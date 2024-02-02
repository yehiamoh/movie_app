import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/services/http_services.dart';
import 'package:movie_app/services/movie_service.dart';
import '../models/app_config.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  SplashScreen({super.key, required this.onInitializationComplete});
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((_) =>
        _setUp(context).then((value) => widget.onInitializationComplete()));
  }

  Future<void> _setUp(BuildContext context) async {
    final getIt = GetIt.instance;
    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);

    getIt.registerSingleton<AppConfig>(AppConfig(
        BASE_API_URL: configData['BASE_API_URL'],
        BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
        API_KEY: configData['API_KEY']));

    getIt.registerSingleton<HTTPService>(HTTPService());
    getIt.registerSingleton<MovieService>(MovieService());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flicked",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://tse2.mm.bing.net/th?id=OIP.XzOCvIj4n6x-UGqbPPs9dwHaHZ&pid=Api&P=0&h=220"),
                  fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
