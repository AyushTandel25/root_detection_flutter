import Foundation
import UIKit

class JailbreakDetection {

    class func isDeviceJailBroken() -> Bool {
        if TARGET_OS_SIMULATOR != 1
        {
            return JailBrokenHelper.hasCydiaInstalled() ||
            JailBrokenHelper.isContainsSuspiciousApps() ||
            JailBrokenHelper.isSuspiciousSystemPathsExists() ||
            JailBrokenHelper.canEditSystemFiles() ||
            JailBrokenHelper.canWriteOutsideSandbox() ||
            JailBrokenHelper.canFork() ||
            JailBrokenHelper.hasSuspiciousSymlink() ||
            JailBrokenHelper.checkRestrictedDirectories() ||
            JailBrokenHelper.checkSandboxIntegrity() ||
            JailBrokenHelper.isFridaRunning() ||
            JailBrokenHelper.hasJailbreakTweaks()
        } else {
            return false
        }
    }
}


private struct JailBrokenHelper {
    //check if cydia is installed (using URI Scheme)
    static func hasCydiaInstalled() -> Bool {
        return (UIApplication.shared.canOpenURL(URL(string: "cydia://")!)) || (FileManager.default.fileExists(atPath: "/Applications/Cydia.app"))
    }

    //Check if suspicious apps (Cydia, FakeCarrier, Icy etc.) is installed
    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }

    //Check if system contains suspicious files
    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }

    // Check if the app can write outside its sandbox
    static func canWriteOutsideSandbox() -> Bool {
        let path = "/private/jailbreak_test.txt"
        do {
            try "This is a test.".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }

    // Check if the process can be forked
    static func canFork() -> Bool {
        let status = posix_spawn(nil, "/bin/sh", nil, nil, nil, nil)
        if status == 0 {
            return true
        }
        return false
    }

    // Check for symbolic links
    static func hasSuspiciousSymlink() -> Bool {
        let paths = [
            "/Applications",
            "/Library/Ringtones",
            "/Library/Wallpaper",
            "/usr/arm-apple-darwin9",
            "/usr/include",
            "/usr/libexec",
            "/usr/share",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"
        ]

        for path in paths {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: path)
                if attributes[FileAttributeKey.type] as? FileAttributeType == .typeSymbolicLink {
                    return true
                }
            } catch {
                continue
            }
        }
        return false
    }

    // Check for files in restricted directories
    static func checkRestrictedDirectories() -> Bool {
        let restrictedPaths = [
            "/bin",
            "/sbin",
            "/usr/sbin",
            "/etc/apt"
        ]

        for path in restrictedPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        return false
    }

    // Check for sandbox integrity
    static func checkSandboxIntegrity() -> Bool {
        let sandboxTestPath = "\(NSHomeDirectory())/Library/Caches/sandbox_test.txt"
        do {
            try "Sandbox integrity test".write(toFile: sandboxTestPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: sandboxTestPath)
            return false
        } catch {
            return true
        }
    }

    // Detect Frida
    static func isFridaRunning() -> Bool {

        let handle = dlopen(nil, RTLD_NOW)
        if handle == nil {
            return false
        }

        let suspiciousSymbols = [
            "frida-agent", "gum-js-loop", "gum-interceptor",
            "frida-trace", "GumJSContext"
        ]

        for symbol in suspiciousSymbols {
            let symbolPointer = dlsym(handle, symbol)
            if symbolPointer != nil {
                dlclose(handle) // Close the handle
                return true
            }
        }

        dlclose(handle) // Close the handle
        return false
    }

    // Detect Jailbreak Tweaks
    static func hasJailbreakTweaks() -> Bool {
        let jailbreakTweaksPaths = [
            "/Library/MobileSubstrate/DynamicLibraries/xCon.dylib", // xCon
            "/Library/MobileSubstrate/DynamicLibraries/Liberty.dylib", // Liberty Lite
            "/Library/MobileSubstrate/DynamicLibraries/Shadow.dylib", // Shadow
            "/Library/MobileSubstrate/DynamicLibraries/ABypass.dylib", // A-Bypass
            "/usr/lib/frida/frida-gadget.dylib" // Frida Gadget
        ]

        for path in jailbreakTweaksPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        return false
    }

    //Check if app can edit system files
    static func canEditSystemFiles() -> Bool {
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile: "/private/JailbreakTest.txt", atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }

    //suspicious apps path to check
    static var suspiciousAppsPathToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }

    //suspicious system paths to check
    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/usr/bin/ssh"
        ]
    }
}