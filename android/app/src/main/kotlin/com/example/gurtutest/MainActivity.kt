package com.example.gurtutest

import android.app.ActivityManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import android.view.WindowManager
import android.webkit.MimeTypeMap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.TimeZone
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    /** Gurtu in the phone's Share menu (see the manifest): what was shared,
     *  copied into the app, until Flutter takes it. */
    private var shareChannel: MethodChannel? = null
    private var pendingShare: Map<String, Any>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createReminderChannel()
        // Not again when the activity is only recreated (e.g. rotation).
        if (savedInstanceState == null) receiveShare(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        receiveShare(intent)
    }

    /** Copies what was shared off the main thread, then hands it over. */
    private fun receiveShare(intent: Intent?) {
        val action = intent?.action
        if (action != Intent.ACTION_SEND && action != Intent.ACTION_SEND_MULTIPLE) return
        val text = intent.getStringExtra(Intent.EXTRA_TEXT) ?: ""
        val uris = sharedUris(intent)
        thread {
            val paths = uris.mapNotNull { copyToApp(it) }
            if (paths.isEmpty() && text.isBlank()) return@thread
            val shared = mapOf("paths" to paths, "text" to text)
            runOnUiThread {
                pendingShare = shared
                shareChannel?.invokeMethod("shared", shared)
            }
        }
    }

    @Suppress("DEPRECATION")
    private fun sharedUris(intent: Intent): List<Uri> =
        if (intent.action == Intent.ACTION_SEND_MULTIPLE) {
            if (Build.VERSION.SDK_INT >= 33) {
                intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM, Uri::class.java)
            } else {
                intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM)
            } ?: emptyList()
        } else {
            listOfNotNull(
                if (Build.VERSION.SDK_INT >= 33) {
                    intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
                } else {
                    intent.getParcelableExtra(Intent.EXTRA_STREAM)
                },
            )
        }

    /** A private copy of a shared file, keeping its name and type. */
    private fun copyToApp(uri: Uri): String? = try {
        var name = "shared"
        contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)
            ?.use { c -> if (c.moveToFirst()) c.getString(0)?.let { name = it } }
        if (!name.contains('.')) {
            MimeTypeMap.getSingleton()
                .getExtensionFromMimeType(contentResolver.getType(uri))
                ?.let { name = "$name.$it" }
        }
        val safe = name.replace(Regex("[^A-Za-z0-9._ -]"), "_")
        val dir = File(cacheDir, "shared").apply { mkdirs() }
        val file = File(dir, "${System.nanoTime()}_$safe")
        val input = contentResolver.openInputStream(uri)
        if (input == null) {
            null
        } else {
            input.use { src -> file.outputStream().use { src.copyTo(it) } }
            file.absolutePath
        }
    } catch (e: Exception) {
        null
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
        shareChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "gurtu/share")
            .also { channel ->
                channel.setMethodCallHandler { call, result ->
                    when (call.method) {
                        // What was shared to open the app, if Flutter hasn't had it.
                        "initial" -> result.success(pendingShare)
                        "done" -> {
                            pendingShare = null
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                }
            }
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
