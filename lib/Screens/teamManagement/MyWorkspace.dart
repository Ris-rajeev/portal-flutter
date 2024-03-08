// import 'package:authsec_flutter/components/teamManagement/teamtab.dart';
// import 'package:authsec_flutter/components/teamManagement/userstab.dart';
// import 'package:flutter/material.dart';
//
// import '../project_screen/sureops_screen/sure_farm_screen.dart';
// import '../project_screen/sureops_screen/surepipe_screen/sure_pipe_screen.dart';
// import 'gueststab.dart';
//
// class MyWorkspace extends StatefulWidget {
//   final Map<String, dynamic> userData;
//
//   const MyWorkspace({required this.userData, Key? key}) : super(key: key);
//
//   @override
//   _MyWorkspaceState createState() => _MyWorkspaceState();
// }
//
// class _MyWorkspaceState extends State<MyWorkspace> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Number of tabs/sections
//       child: Scaffold(
//         appBar: AppBar(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Organization and Workspaces'),
//               const SizedBox(height: 15), // Add space between title and TabBar
//               Column(
//                 children: [
//                   Text("Organization : "),//+widget.userData['companyName']),
//                   Text("Account id : "),//+widget.userData['gstNumber']),
//                   Text("Selected Workspace : "),//+widget.userData['workspace']),
//                 ],
//               )
//             ],
//           ),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'User'),
//               Tab(text: 'Guest'),
//               Tab(text: 'Team'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // You can use widget.userData here to access the provided data
//             // Example: Text(widget.userData['userName']),
//             // Ensure you replace 'userName' with the actual key you want to access.
//             UserContent(),
//             GuestContent(),
//             TeamContent(),
//             //SureFarmContent(projectId: widget.projectId),
//             // SureFarmContent(projectId: widget.projectId),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../project_screen/sureops_screen/sure_farm_screen.dart';
import '../project_screen/sureops_screen/surepipe_screen/sure_pipe_screen.dart';
import 'gueststab.dart';
import 'teamtab.dart';
import 'userstab.dart';

class MyWorkspace extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MyWorkspace({required this.userData, Key? key}) : super(key: key);

  @override
  _MyWorkspaceState createState() => _MyWorkspaceState();
}

class _MyWorkspaceState extends State<MyWorkspace> {
  bool isInfoPopupVisible = false;

  void toggleInfoPopup() {
    setState(() {
      isInfoPopupVisible = !isInfoPopupVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs/sections
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Organization and Workspaces'),
          actions: [
            IconButton(
              icon: Icon(Icons.info),
              onPressed: toggleInfoPopup,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'User'),
              Tab(text: 'Guest'),
              Tab(text: 'Team'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserContent(),
            GuestContent(),
            TeamContent(),
          ],
        ),
        floatingActionButton: isInfoPopupVisible
            ? AlertDialog(
          title: const Text('Organization Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Organization: ${widget.userData['companyName']}"),
              Text("Account ID: ${widget.userData['gstNumber']}"),
              Text("Selected Workspace: ${widget.userData['workspace']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: toggleInfoPopup,
              child: const Text('Close'),
            ),
          ],
        )
            : null,
      ),
    );
  }
}

