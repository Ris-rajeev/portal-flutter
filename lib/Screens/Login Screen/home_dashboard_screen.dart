import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
              Image.asset(
                '/images/hadwin_system/hadwin-logo-lite.png',
                height: 48,
                width: 48,
              ),
              const SizedBox(height: 20),
              Text(
                'Hello, Gaurav!',
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
      ),
    );
  }
}
