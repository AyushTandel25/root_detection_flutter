import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:root_detection_flutter/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    checkForRootDevice();
    super.initState();
  }

  Future checkForRootDevice() async {
    try {
      bool isRootedDevice = false;
      if (Platform.isAndroid) {
        bool isFridaPresent =
            await methodChannel.invokeMethod("getFridaAvailabilityStatus");
        isRootedDevice = isFridaPresent &&
            ((await RootCheckerPlus.isRootChecker()) ?? false);
      } else {
        isRootedDevice =
            await methodChannel.invokeMethod("getRootDeviceStatus");
      }
      if (!isRootedDevice) {
        showAppClosingDialog();
      }
    } catch (error, stackTrace) {
      debugPrint("Error:$error");
      debugPrint("Stack Trace:$stackTrace");
    }
  }

  Future showAppClosingDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(
                "Security Alert!!!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                "This device is rooted. The app cannot run on a rooted device for security reasons.",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Root Detection",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
