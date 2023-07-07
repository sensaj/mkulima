import 'package:flutter/material.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/pages/auth/login_screen.dart';
import 'package:mkulima/pages/homepage.dart';
import 'package:mkulima/providers/map_view_provider.dart';
import 'package:mkulima/services/local_services.dart';
import 'package:mkulima/theme/colors.dart';
import 'package:provider/provider.dart';

class MkulimaApp extends StatefulWidget {
  MkulimaApp({Key? key}) : super(key: key);

  @override
  State<MkulimaApp> createState() => _MkulimaAppState();
}

class _MkulimaAppState extends State<MkulimaApp> {
  bool hasLogin = false;
  late User user;
  @override
  void initState() {
    super.initState();
    checkLocalData();
  }

  checkLocalData() async {
    final _hasLogin = await local.checkLoginState();
    if (_hasLogin) {
      final _user = await local.getLocalUserData();
      if (_user != null) {
        setState(() {
          user = _user;
          hasLogin = _hasLogin;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MapViewProvider>(
            create: (_) => MapViewProvider(context)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: colors.background),
        home: hasLogin ? Homepage(user: user) : LoginScreen(),
      ),
    );
  }
}
