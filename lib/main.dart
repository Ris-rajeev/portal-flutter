import 'dart:convert';

import 'package:authsec_flutter/Screens/Components/Dashboard/DashboardScreen.dart';
import 'package:authsec_flutter/Screens/Components/List%20Builder/ListBuilderScreen.dart';
import 'package:authsec_flutter/Screens/Components/Wireframes/DragandandDrop%20copy.dart';
import 'package:authsec_flutter/Screens/Components/Wireframes/DragandandDrop.dart';
import 'package:authsec_flutter/Screens/ContainerLogs/LiveLogsScreen.dart';
import 'package:authsec_flutter/Screens/Module_screen/ModulesScreen.dart';
import 'package:authsec_flutter/Screens/project_screen/sureops_screen/sure_farm_screen.dart';
import 'package:authsec_flutter/Screens/sign_up_screen/CreateUser.dart';
import 'package:authsec_flutter/Screens/sign_up_screen/RegistrationDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'screens/Login Screen/login_screen.dart';
import 'screens/main_app_screen/tabbed_layout_component.dart';

const simplePeriodicTask = "simplePeriodicTask";

// void showNotification(String v, FlutterLocalNotificationsPlugin flp) async {
//   var android = const AndroidNotificationDetails(
//     'channel id',
//     'channel NAME',
//     priority: Priority.high,
//     importance: Importance.max,
//   );
//   var iOS = const IOSNotificationDetails();
//   var platform = NotificationDetails(android: android, iOS: iOS);
//   await flp.show(0, 'CloudnSure', '$v', platform, payload: 'VIS \n $v');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Request notification permissions
  // await _requestNotificationPermissions();

  // await Workmanager().initialize(callbackDispatcher);
  // await Workmanager().registerPeriodicTask(
  //   "5",
  //   simplePeriodicTask,
  //   existingWorkPolicy: ExistingWorkPolicy.replace,
  //   frequency: const Duration(minutes: 15),
  //   initialDelay: const Duration(seconds: 5),
  //   constraints: Constraints(networkType: NetworkType.connected),
  // );
  print("working");
  runApp(const MyApp());
}

// Future<void> _requestNotificationPermissions() async {
//   final status = await Permission.notification.request();
//   if (status.isGranted) {
//     print('Notification permissions granted');
//   } else {
//     print('Notification permissions denied');
//   }
// }

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
//     var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = const IOSInitializationSettings();
//     var initSettings = InitializationSettings(android: android, iOS: iOS);
//     flp.initialize(initSettings);
//     String baseUrl = ApiConstants.baseUrl;
//     final apiUrl = '$baseUrl/user_notifications/get_unseen';
//     final token = await TokenManager.getToken();
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//     if (response.statusCode <= 209) {
//       final List<dynamic> data = jsonDecode(response.body);
//       List<Map<String, dynamic>> notifications =
//           data.cast<Map<String, dynamic>>();
//       notifications.forEach((element) async {
//         showNotification(element['notification'], flp);
//         int id = element['id'];
//         final apiUrl2 = '$baseUrl/user_notifications/seen_success/$id';
//         final response2 = await http.get(
//           Uri.parse(apiUrl2),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         );
//         if (response2.statusCode <= 209) {
//           print("seen request to web success");
//         }
//       });
//     } else {
//       print('Failed to fetch data');
//     }
//     return Future.value(true);
//   });
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Welcome to cloudNsure',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const LoginScreen(),
//       routes: {
//         // '/load': (context) => const ProjectListScreen(),
//
//         // '/drag': (context) => DragAndDropFormBuilder(
//         //       projId: 13249,
//         //       headerId: 1550,
//         //       moduleId: 13258,
//         //     ),
//         '/drag': (context) => DragAndDropFormBuilder(
//               projId: 11096,
//               headerId: 1538,
//               moduleId: 12867,
//               backendId: 215,
//             ),
//         '/drag1': (context) => DragAndDrop1FormBuilder(
//               headerId: 1451,
//             ),
//         '/mod': (context) => ModuleScreen(
//               projectId: 12802,
//               type: 'myproject',
//             ),
//         '/dash': (context) => Dashboard_screen(
//               projId: 12802,
//               moduleId: 12811,
//             ),
//         '/regi': (context) =>
//             RegistrationDetailsScreen(email: 'gaurav@dekatc.com'),
//         '/user': (context) => CreateUserScreen(),
//
//         '/list': (context) =>
//             ListBuilder_screen(projId: 13249, moduleId: 13258),
//         '/log': (context) => const LiveLogsScreen(
//               containerName: 'sukhantest_realnet_d-mysql',
//             ),
//         '/farm': (context) => SureFarmContent(projectId: 13261),
//       },
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLogin = false;
  Map<String, dynamic> userData = {};
  checkifLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    var userdatastr = prefs.getString('userData');

    print('userData....$userdatastr');
    if (isLoggedIn != null && isLoggedIn) {
      setState(() {
        isLogin = true;
      });
    }

    if (userdatastr != null) {
      userData = json.decode(userdatastr);
    } else {
      setState(() {
        isLogin = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkifLogin();
  }

  double getMargin(BuildContext context) {
    // Calculate the margin based on a percentage of screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double marginPercentage = 0.2; // Adjust the percentage as needed
    return screenWidth * marginPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Container(
            margin: EdgeInsets.symmetric(
              horizontal: getMargin(context),
            ),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Welcome to cloudNsure',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: isLogin
                  ? TabbedLayoutComponent(
                      userData: userData,
                    )
                  : const LoginScreen(),
              routes: {
                // '/load': (context) => const ProjectListScreen(),

                // '/drag': (context) => DragAndDropFormBuilder(
                //       projId: 13249,
                //       headerId: 1550,
                //       moduleId: 13258,
                //     ),
                '/drag': (context) => DragAndDropFormBuilder(
                      projId: 11096,
                      headerId: 1615,
                      moduleId: 12867,
                      backendId: 215,
                    ),
                '/drag1': (context) => DragAndDrop1FormBuilder(
                      headerId: 1451,
                    ),
                '/mod': (context) => ModuleScreen(
                      projectId: 12802,
                      type: 'myproject',
                    ),
                '/dash': (context) => Dashboard_screen(
                      projId: 12802,
                      moduleId: 12811,
                    ),
                '/regi': (context) =>
                    RegistrationDetailsScreen(email: 'gaurav@dekatc.com'),
                '/user': (context) => CreateUserScreen(),

                '/list': (context) =>
                    ListBuilder_screen(projId: 13249, moduleId: 13258),
                '/log': (context) => const LiveLogsScreen(
                      containerName: 'sukhantest_realnet_d-mysql',
                    ),
                '/farm': (context) => SureFarmContent(projectId: 13261),
              },
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Welcome to cloudNsure',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: isLogin
                ? TabbedLayoutComponent(
                    userData: userData,
                  )
                : const LoginScreen(),
            routes: {
              // '/load': (context) => const ProjectListScreen(),

              // '/drag': (context) => DragAndDropFormBuilder(
              //       projId: 13249,
              //       headerId: 1550,
              //       moduleId: 13258,
              //     ),
              '/drag': (context) => DragAndDropFormBuilder(
                    projId: 11096,
                    headerId: 1538,
                    moduleId: 12867,
                    backendId: 215,
                  ),
              '/drag1': (context) => DragAndDrop1FormBuilder(
                    headerId: 1451,
                  ),
              '/mod': (context) => ModuleScreen(
                    projectId: 12802,
                    type: 'myproject',
                  ),
              '/dash': (context) => Dashboard_screen(
                    projId: 12802,
                    moduleId: 12811,
                  ),
              '/regi': (context) =>
                  RegistrationDetailsScreen(email: 'gaurav@dekatc.com'),
              '/user': (context) => CreateUserScreen(),

              '/list': (context) =>
                  ListBuilder_screen(projId: 13249, moduleId: 13258),
              '/log': (context) => const LiveLogsScreen(
                    containerName: 'sukhantest_realnet_d-mysql',
                  ),
              '/farm': (context) => SureFarmContent(projectId: 13261),
            },
          );
  }
}
