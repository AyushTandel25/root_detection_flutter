package com.example.root_detection.root_detection_flutter

import android.content.pm.PackageManager
import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader

class RootDetection {

    private fun isFridaProcessRunning(): Boolean {
        val processNames = arrayOf("frida-server", "frida-gadget")
        return try {
            val process = Runtime.getRuntime().exec("ps")
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            var line: String?
            while (reader.readLine().also { line = it } != null) {
                for (processName in processNames) {
                    if (line?.contains(processName) == true) {
                        return true
                    }
                }
            }
            false
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun checkFridaInstallPaths(): Boolean {
        val paths = arrayOf(
                "/data/local/tmp/frida-server",
                "/data/local/tmp/libfrida-gadget.so",
                "/data/local/tmp/frida-gadget.so"
        )
        for (path in paths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }

    private fun checkForFridaApps(pm: PackageManager): Boolean {
        val knownApps = arrayOf("com.frida.server", "com.frida.gadget")
        for (app in knownApps) {
            try {
                pm.getPackageInfo(app, 0)
                return true
            } catch (e: PackageManager.NameNotFoundException) {
                // Package not found
            }
        }
        return false
    }

    fun isFridaPresent(pm: PackageManager): Boolean {
        return isFridaProcessRunning() ||
                checkFridaInstallPaths() ||
                checkForFridaApps(pm)
    }
}
