import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mkulima/app.dart';
import 'package:mkulima/widgets/restart_app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RestartWidget(child: MkulimaApp()));
}
