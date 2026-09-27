package com.example.gurtutest

import android.app.ActivityManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createReminderChannel()
    }

    /** Where reminder pushes land (named in the manifest as the default),
     *  so people can find and control them under "Reminders". */
    private fun createReminderChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channel = NotificationChannel(
            getString(R.string.reminder_channel_id),
            getString(R.string.reminder_channel_name),
            NotificationManager.IMPORTANCE_HIGH,
        )
        channel.description = getString(R.string.reminder_channel_description)
        manager.createNotificationChannel(channel)
        // Missed doses, for the family: its own channel so it stands out
        // (and can't be silenced together with ordinary reminders).
        val alerts = NotificationChannel(
            getString(R.string.alert_channel_id),
            getString(R.string.alert_channel_name),
            NotificationManager.IMPORTANCE_HIGH,
        )
        alerts.description = getString(R.string.alert_channel_description)
        alerts.enableVibration(true)
        alerts.vibrationPattern = longArrayOf(0, 400, 200, 400, 200, 600)
        alerts.enableLights(true)
        alerts.lightColor = android.graphics.Color.RED
        manager.createNotificationChannel(alerts)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Facts the on-device AI needs to pick the right model build for this
        // phone (NPU builds are compiled per chip) and to respect "Wi-Fi only".
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "gurtu/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "info" -> result.success(deviceInfo())
                    "isUnmetered" -> result.success(isUnmetered())
                    // The IANA zone (e.g. Asia/Kolkata), so reminders fire
                    // at the family's own local time.
                    "timeZone" -> result.success(TimeZone.getDefault().id)
                    // While a doctor visit is being listened to, so the
                    // phone doesn't lock and cut off the microphone.
                    "keepScreenOn" -> {
                        if (call.arguments == true) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        }
                        result.success(null)
                    }
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
