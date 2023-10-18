
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:quotes_appliction/home_screen.dart';
//import 'package:quotes_appliction/onboarding_screen.dart';
import 'error_screen.dart';
//import 'firebase_config.dart';
import 'home_screen.dart';
import 'notification_service.dart';
import 'notification_util.dart';
import 'onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'home_screen.dart';
import 'initialisation.dart';
import 'onboarding_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';
import 'adMobManager.dart';
import 'dart:io';
import 'package:restart_app/restart_app.dart';





const String kOnboardingStatusKey = 'onboarding_status';

void restartApp() {
  Restart.restartApp();
}

void main() => runApp(const QuotesApp());

class QuotesApp extends StatefulWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  _QuotesAppState createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  late SharedPreferences _prefs;
  bool showOnboarding = false;

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    _prefs = await SharedPreferences.getInstance();
    bool hasGoneThroughOnboarding = _prefs.getBool(kOnboardingStatusKey) ?? false;
    setState(() {
      showOnboarding = !hasGoneThroughOnboarding;
    });
  }

  Future<void> updateOnboardingStatus() async {
    await _prefs.setBool(kOnboardingStatusKey, true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showOnboarding
          ? OnboardingScreen(
        onboardingCompleteCallback: updateOnboardingStatus,
      )
          : HomeScreen(),
    );
  }
}