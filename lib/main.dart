import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/screens/home_screen.dart';
import 'package:whatsapp_clone/screens/login_screen.dart';
import 'package:whatsapp_clone/screens/user_information.dart';
import 'package:whatsapp_clone/services/notification_services.dart';
import 'package:whatsapp_clone/viewModels/chat_viewmodel.dart';
import 'package:whatsapp_clone/viewModels/home_viewmodel.dart';
import 'package:whatsapp_clone/viewModels/login_viewmodel.dart';
import 'package:whatsapp_clone/viewModels/searchScreen_viewmodel.dart';
import 'package:whatsapp_clone/viewModels/signup_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/viewModels/userInformation_viewmodel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

SharedPreferences? sharedPreferences;
final notificationService = NotificationServices();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(
  //     (message) async => await Firebase.initializeApp());
  await FirebaseMessaging.instance.getInitialMessage();

  await notificationService.requestPermission();
  //await notificationService.getTokent();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignUpViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserInformationViewmodel(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            // HomeScreen()
            FirebaseAuth.instance.currentUser != null &&
                    sharedPreferences!.getBool("editComplete") == true
                ? HomeScreen()
                : sharedPreferences!.getBool("editComplete") == false
                    ? UserInformation()
                    : LoginScreen(),
      ),
    );
  }
}
