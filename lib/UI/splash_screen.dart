import 'package:flutter/material.dart';

import '../firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashservices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashservices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('T-Watch Manager',  style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
