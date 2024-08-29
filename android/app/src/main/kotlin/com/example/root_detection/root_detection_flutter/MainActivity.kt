package com.example.root_detection.root_detection_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val channel = "com.example.root_detection"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "getFridaAvailabilityStatus") {
                val isFridaPresent = RootDetection().isFridaPresent(context.packageManager)
                result.success(isFridaPresent)
            } else {
                result.notImplemented()
            }
        }
    }
}
