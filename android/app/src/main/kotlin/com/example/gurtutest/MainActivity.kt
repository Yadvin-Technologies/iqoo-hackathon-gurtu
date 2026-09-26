package com.example.gurtutest

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/** Exposes device facts and thermal state to the benchmark (`gurtu/device`). */
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "gurtu/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "info" -> result.success(info())
                    "thermal" -> result.success(thermal())
                    "power" -> result.success(power())
                    else -> result.notImplemented()
                }
            }
    }

    private fun info(): Map<String, Any?> {
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val mem = ActivityManager.MemoryInfo().also { am.getMemoryInfo(it) }
        return mapOf(
            "manufacturer" to Build.MANUFACTURER,
            "model" to Build.MODEL,
            "device" to Build.DEVICE,
            "socManufacturer" to if (Build.VERSION.SDK_INT >= 31) Build.SOC_MANUFACTURER else null,
            "socModel" to if (Build.VERSION.SDK_INT >= 31) Build.SOC_MODEL else null,
            "sdkInt" to Build.VERSION.SDK_INT,
            "release" to Build.VERSION.RELEASE,
            "totalMemBytes" to mem.totalMem,
            "availMemBytes" to mem.availMem,
            "cpuCores" to Runtime.getRuntime().availableProcessors(),
        )
    }

    /**
     * Battery current (µA, sign is vendor-specific), voltage (mV) and whether
     * the phone is plugged in; power draw is only meaningful unplugged.
     */
    private fun power(): Map<String, Any?> {
        val bm = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val battery = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val current = bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
        return mapOf(
            "currentUa" to if (current == Long.MIN_VALUE) null else current,
            "voltageMv" to battery?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)?.takeIf { it > 0 },
            "plugged" to ((battery?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0) != 0),
            "levelPct" to bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY),
        ) + thermal()
    }

    /**
     * Thermal status (0 none .. 6 shutdown), thermal headroom (1.0 = throttling
     * imminent, forecast 10 s ahead) and battery temperature in °C.
     */
    private fun thermal(): Map<String, Any?> {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        val battery = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val tenths = battery?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, Int.MIN_VALUE)
        val headroom = if (Build.VERSION.SDK_INT >= 30) pm.getThermalHeadroom(10) else Float.NaN
        return mapOf(
            "status" to pm.currentThermalStatus,
            "headroom" to if (headroom.isNaN()) null else headroom.toDouble(),
            "batteryTempC" to if (tenths == null || tenths == Int.MIN_VALUE) null else tenths / 10.0,
        )
    }
}
