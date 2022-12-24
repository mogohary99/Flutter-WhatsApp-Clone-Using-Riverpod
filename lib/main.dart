import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_riverpod/cummon/widgets/error.dart';
import 'package:whatsapp_riverpod/cummon/widgets/loader.dart';
import 'package:whatsapp_riverpod/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_riverpod/features/landing/landing_screen.dart';
import 'package:whatsapp_riverpod/router.dart';
import '/screens/mobile_layout_screen.dart';
import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Whatsapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
          )),
      onGenerateRoute: (settings) => generateRoute(settings),

      home: ref.watch(userDataAuthProvider).when(
          data: (user) {
            if(user==null) {
              return LandingScreen();
            } else {
              return const MobileLayoutScreen();
            }
          },
          error: (err, trace) {
            return ErrorScreen(error: err.toString());
          },
          loading: ()=> const Loader(),),

    );
  }
}
