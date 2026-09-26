package com.example.gurtutest

import android.app.ActivityManager
import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Facts the on-device AI needs to pick the right model build for this
        // phone (NPU builds are compiled per chip) and to respect "Wi-Fi only".
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "gurtu/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "info" -> result.success(deviceInfo())
                    "isUnmetered" -> result.success(isUnmetered())
                    else -> result.notImplemented()
                }
            }
    }

    private fun deviceInfo(): Map<String, Any> {
        val memory = ActivityManager.MemoryInfo()
        (getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager).getMemoryInfo(memory)
        val soc = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) Build.SOC_MODEL else ""
        return mapOf(
            "socModel" to soc,
            "board" to Build.BOARD,
            "hardware" to Build.HARDWARE,
            "manufacturer" to Build.MANUFACTURER,
            "model" to Build.MODEL,
            "sdkInt" to Build.VERSION.SDK_INT,
            "totalRamMb" to (memory.totalMem / (1024 * 1024)).toInt(),
            "freeStorageMb" to (filesDir.usableSpace / (1024 * 1024)).toInt(),
        )
    }

    private fun isUnmetered(): Boolean {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val caps = cm.getNetworkCapabilities(cm.activeNetwork) ?: return false
        return caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_METERED) ||
            caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
            caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)
    }
}
