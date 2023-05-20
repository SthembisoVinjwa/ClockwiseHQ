import 'package:clockwisehq/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'package:clockwisehq/global/global.dart' as global;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (context) => MainProvider(),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          hoverColor: Colors.black,
          indicatorColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
