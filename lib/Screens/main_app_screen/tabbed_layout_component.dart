import 'dart:async';
import 'dart:convert';
import 'package:authsec_flutter/screens/project_screen/ProjectListScreen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:authsec_flutter/Entity/Productmodel/entity_list_screen.dart';
import 'package:authsec_flutter/Entity/imagemodel/imageentity_list_screen.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:authsec_flutter/resources/api_constants.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:authsec_flutter/providers/tab_navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Bookmarks/Bookmarks_entity_list_screen.dart';
import '../LayoutReportBuilder/LayoutReportBuilder.dart';
import '../Login Screen/AppFooter.dart';
import '../Login Screen/login_screen.dart';
import '../QrBarCode/Qr_BarCode/Qr_BarCode_create_entity_screen.dart';
import '../SysParameters/SystemParameterScreen.dart';
import '../profileManagement/Profilesettings.dart';
import '../profileManagement/about.dart';
import '../profileManagement/changepassword.dart';
import '../teamManagement/MyWorkspace.dart';

class TabbedLayoutComponent extends StatefulWidget {
  final Map<String, dynamic> userData;
  const TabbedLayoutComponent({required this.userData, Key? key})
      : super(key: key);
  @override
  _TabbedLayoutComponentState createState() => _TabbedLayoutComponentState();
}

class _TabbedLayoutComponentState extends State<TabbedLayoutComponent> {
  int _currentTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void setTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  List<Map<String, dynamic>> notifications = [];

  Future<void> fetchData() async {
    String baseUrl = ApiConstants.baseUrl;
    final apiUrl = '$baseUrl/notification/get_notification';
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode <= 209) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        notifications = data.cast<Map<String, dynamic>>();
      });
    } else {
      // Handle errors
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAuthKey = TokenManager.getToken().toString();

    print('user auth key is .....' + userAuthKey);

    List<Widget> screens = [
      HomeDashboardScreen(
        userData: widget.userData,
      ),
      const SizedBox(height: 15),
      StaticChartsScreen(
        userData: widget.userData,
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement navigation to view all notifications here
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0), // Adjust the spacing as needed
              //ActivityList(), // This widget should contain the list of notifications
              for (final notification in notifications)
                NotificationItem(notification: notification),
            ],
          ),
        ),
      )
    ];

    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 50,
          leading: IconButton(
              icon: const Icon(
                Icons.circle_outlined,
                color: Colors.white,
              ),
              onPressed: () {}),
          title: const Text("CloudnSure"),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 5.0,
                width: 20,
              ),

              ListTile(
                title: const Text('About'),
                onTap: () {
                  // Handle menu 2 tap
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutScreen(), //go to get all entity
                    ),
                  );
                  // Add your logic for menu 2 here
                },
              ),

              ListTile(
                title: const Text('Profile Settings'),
                onTap: () {
                  // Handle menu 2 tap
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSettingsScreen(
                          userData: widget.userData), //go to get all entity
                    ),
                  );
                  // Add your logic for menu 2 here
                },
              ),

              ListTile(
                title: const Text('My workspace'),
                onTap: () {
                  // Handle menu 2 tap
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyWorkspace(
                          userData: widget.userData), //go to get all entity
                    ),
                  );
                  // Add your logic for menu 2 here
                },
              ),

              ListTile(
                title: const Text('Change Password'),
                onTap: () {
                  // Handle menu 2 tap
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(
                          userEmail: widget.userData['email'],
                          userData: widget.userData), //go to get all entity
                    ),
                  );
                  // Add your logic for menu 2 here
                },
              ),

              ListTile(
                title: const Text('Menu 1'),
                onTap: () {
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EntityListScreen(), //go to get all entity
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Menu 2'),
                onTap: () {
                  // Handle menu 2 tap
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageEntityListScreen(), //go to get all entity
                    ),
                  );
                  // Add your logic for menu 2 here
                },
              ),
              ListTile(
                title: const Text('BookMark'),
                onTap: () {
                  // Handle menu 2 tap
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          bookmarks_entity_list_screen(), //go to get all entity
                    ),
                  );
                  // Add your logic for menu 2 here
                },
              ),

              ListTile(
                title: const Text('Report layout builder'),
                onTap: () {
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportEditor(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('System Parameter'),
                onTap: () {
                  // Handle menu 2 tap
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SysParameter(), //go to get all entity
                    ),
                  );
                  // Add your logic for menu 2 here
                },
              ),
              ListTile(
                title: const Text('Addition Menu'),
                onTap: () {
                  Navigator.pop(context); // Closes the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrBarCodeScreen(),
                    ),
                  );
                },
              ),

              // NEW MENU

              ListTile(
                title: const Row(
                  children: [Text("LogOut"), Icon(Icons.logout)],
                ),
                onTap: () {
                  _logoutUser();
                },
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xfffefefe),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: AppFooter(),
        body: screens.isEmpty
            ? const Text("Loading...")
            : ListView.builder(
                itemCount: screens.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => screens[index],
              ),
      ),
    );
  }

  Future<void> _logoutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Remove 'userData' and 'isLoggedIn' from SharedPreferences
      await prefs.remove('userData');
      await prefs.remove('isLoggedIn');
      String logouturl = "${ApiConstants.baseUrl}/token/logout";
      var response = await http.get(Uri.parse(logouturl));

      if (response.statusCode <= 209) {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // Remove all routes from the stack
        );
      } else {
        const Text('failed to logout');
      }
    } catch (error) {
      print('Error occurred during logout: $error');
    }
  }

  Widget googleNavBar() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.18, vertical: 1),
        child: GNav(
          haptic: false,
          gap: 6,
          activeColor: const Color(0xFF0070BA),
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          duration: const Duration(milliseconds: 300),
          color: const Color(0xFF243656),
          tabs: [
            GButton(
              icon: FluentIcons.home_32_regular,
              iconSize: 36,
              text: 'Home',
              onPressed: () {
                print('home');
              },
            ),
            GButton(
              icon: FluentIcons.people_32_regular,
              iconSize: 36,
              text: 'Contacts',
              onPressed: () {
                print('contacts');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AllContactsScreen(
                //       setTab: setTab,
                //     ),
                //   ),
                // );
              },
            ),
            GButton(
              icon: Icons.wallet,
              text: 'Wallet',
              iconSize: 34,
              onPressed: () {
                print('wallet');
              },
            ),
          ],
          selectedIndex: _currentTab,
          onTabChange: _onTabChange,
        ),
      ),
    );
  }

  void _onTabChange(int index) {
    if (_currentTab == 1 || _currentTab == 2) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    Provider.of<TabNavigationProvider>(context, listen: false)
        .updateTabs(_currentTab);
    setState(() {
      _currentTab = index;
    });
  }

  Future<bool> _onBackPress() {
    if (_currentTab == 0) {
      return Future.value(true);
    } else {
      int lastTab =
          Provider.of<TabNavigationProvider>(context, listen: false).lastTab;
      Provider.of<TabNavigationProvider>(context, listen: false)
          .removeLastTab();
      setTab(lastTab);
    }
    return Future.value(false);
  }
}

class StaticChartsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const StaticChartsScreen({required this.userData, Key? key})
      : super(key: key);
  @override
  _StaticChartsScreenState createState() => _StaticChartsScreenState();
}

class _StaticChartsScreenState extends State<StaticChartsScreen> {
  int myProjectcount = 0;
  int sharedWithMeCount = 0;
  int allprojectCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print("working");
    final token = await TokenManager.getToken();
    print(token);
    String baseUrl = ApiConstants.baseUrl;
    var myProjectcountres = await http.get(
      Uri.parse('$baseUrl/workspace/secworkspaceuser/count_myproject'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
            'application/json', // You may need to adjust the content type as needed
      },
    );
    var sharedWithMeCountres = await http.get(
      Uri.parse('$baseUrl/workspace/secworkspaceuser/count_sharedwithme'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
            'application/json', // You may need to adjust the content type as needed
      },
    );
    var allProjectsCountres = await http.get(
      Uri.parse('$baseUrl/workspace/secworkspaceuser/count_allproject'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
            'application/json', // You may need to adjust the content type as needed
      },
    );
    print(myProjectcountres.statusCode);
    if (myProjectcountres.statusCode <= 209 &&
        sharedWithMeCountres.statusCode <= 209) {
      final myProjectData = jsonDecode(myProjectcountres.body);
      final sharedData = jsonDecode(sharedWithMeCountres.body);
      final allData = jsonDecode(allProjectsCountres.body);
      setState(() {
        myProjectcount = myProjectData;
        sharedWithMeCount = sharedData;
        allprojectCount = allData;
      });
    } else {
      // Handle errors
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Closes the drawer
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectListScreen(
                    userData: widget.userData,
                    type: "myproject"), // Get all projects
              ),
            );
          },
          child: Card(
            color: const Color(0xff1546A0),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    myProjectcount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    'My Projects',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Closes the drawer
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectListScreen(
                    userData: widget.userData,
                    type: "sharedproject"), // Get all projects
              ),
            );
          },
          child: Card(
            color: Colors.white,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    sharedWithMeCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    'Shared with me',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Closes the drawer
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectListScreen(
                    userData: widget.userData,
                    type: "allproject"), // Get all projects
              ),
            );
          },
          child: Card(
            color: Colors.white,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    allprojectCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    'All Projects',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HomeDashboardScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    var firstName = userData['firstName'].toString();
    return Container(
      // height: double.infinity,
      // width: double.infinity,
      width: MediaQuery.of(context)
          .size
          .width, // Set the container width to the screen width
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xff1546A0),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 40, 14, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Text(
              'Hello, ' + firstName + '!',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
    // );
  }
}

class NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final notificationText = notification['notification'] as String;
    final time = notification['time'] as String;
    final timeDifference = calculateTimeDifference(time);

    return ListTile(
      title: Text(notificationText),
      subtitle: Text(timeDifference),
    );
  }

  String calculateTimeDifference(String time) {
    final currentTime = DateTime.now();
    final notificationTime = DateTime.parse(time);

    final difference = currentTime.difference(notificationTime);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '${years} ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '${months} ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Just now';
    }
  }
}
