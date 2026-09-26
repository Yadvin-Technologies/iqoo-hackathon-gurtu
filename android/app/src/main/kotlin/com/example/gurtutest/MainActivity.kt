package com.example.gurtutest

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Debug
import android.os.OutcomeReceiver
import android.os.PowerManager
import android.os.PowerMonitor
import android.os.PowerMonitorReadings
import android.os.SystemClock
import android.os.health.SystemHealthManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/**
 * Exposes the device stats the app sandbox can't read from sysfs:
 * battery current/voltage (-> power draw), the platform thermal state,
 * per-rail energy (CPU / GPU / NSP power, API 35+) and the app's PSS
 * including graphics memory. CPU/GPU load and temperatures are read from Dart.
 */
class MainActivity : FlutterActivity() {
    private val background = Executors.newSingleThreadExecutor()

    /** Rails from the on-device power monitor, discovered once (API 35+). */
    private var powerMonitors: List<PowerMonitor>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "gurtutest/device_stats")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "deviceInfo" -> result.success(deviceInfo())
                    "power" -> result.success(power())
                    "powerRails" -> powerRails { result.success(it) }
                    // Walks /proc/self/smaps (slow for a multi-GB model), so off the UI thread.
                    "memory" -> background.execute {
                        val m = memory()
                        runOnUiThread { result.success(m) }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        background.shutdown()
        super.onDestroy()
    }

    private fun deviceInfo(): Map<String, Any?> = mapOf(
        "model" to Build.MODEL,
        "manufacturer" to Build.MANUFACTURER,
        "socModel" to if (Build.VERSION.SDK_INT >= 31) Build.SOC_MODEL else Build.HARDWARE,
        "socManufacturer" to if (Build.VERSION.SDK_INT >= 31) Build.SOC_MANUFACTURER else null,
        "sdkInt" to Build.VERSION.SDK_INT,
        "release" to Build.VERSION.RELEASE,
        "cores" to Runtime.getRuntime().availableProcessors(),
    )

    private fun power(): Map<String, Any?> {
        val bm = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        val battery = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val status = battery?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val plugged = battery?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0
        return mapOf(
            // Sign convention varies by OEM; Dart takes the magnitude.
            "currentMicroAmps" to bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW),
            "voltageMilliVolts" to battery?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0),
            "batteryTempDeciC" to battery?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0),
            "levelPercent" to bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY),
            "charging" to (status == BatteryManager.BATTERY_STATUS_CHARGING ||
                status == BatteryManager.BATTERY_STATUS_FULL),
            // Plugged in but not charging (full / paused) still skews battery current.
            "plugged" to (plugged != 0),
            "thermalStatus" to pm.currentThermalStatus,
            "thermalHeadroom" to pm.getThermalHeadroom(0).takeUnless { it.isNaN() },
        )
    }

    /**
     * Cumulative energy per ODPM rail (e.g. cpu-m, cpu-l, gpu, nsp) in µWs, with
     * the elapsed-realtime timestamp of the snapshot. The OS refreshes these for
     * apps at most every ~30 s, so Dart turns consecutive snapshots into watts.
     */
    private fun powerRails(done: (Map<String, Any?>?) -> Unit) {
        if (Build.VERSION.SDK_INT < 35) return done(null)
        val shm = getSystemService(SystemHealthManager::class.java) ?: return done(null)

        fun read(monitors: List<PowerMonitor>) {
            // Raw rail measurements are the ground truth; modeled consumers are the fallback.
            val rails = monitors.filter { it.type == PowerMonitor.POWER_MONITOR_TYPE_MEASUREMENT }
                .ifEmpty { monitors }
            if (rails.isEmpty()) return done(emptyMap())
            try {
                shm.getPowerMonitorReadings(rails, mainExecutor,
                    object : OutcomeReceiver<PowerMonitorReadings, RuntimeException> {
                        override fun onResult(r: PowerMonitorReadings) = done(mapOf(
                            "nowElapsedMs" to SystemClock.elapsedRealtime(),
                            "rails" to rails.map {
                                mapOf(
                                    "name" to it.name,
                                    "energyUws" to r.getConsumedEnergy(it),
                                    "timestampMs" to r.getTimestampMillis(it),
                                )
                            },
                        ))

                        override fun onError(e: RuntimeException) = done(null)
                    })
            } catch (e: RuntimeException) {
                done(null)
            }
        }

        powerMonitors?.let { return read(it) }
        try {
            shm.getSupportedPowerMonitors(mainExecutor) { list ->
                powerMonitors = list
                read(list)
            }
        } catch (e: RuntimeException) {
            done(null)
        }
    }

    /** This process's proportional memory, including GPU/graphics buffers (memtrack), in kB. */
    private fun memory(): Map<String, Any?> {
        val mi = Debug.MemoryInfo()
        Debug.getMemoryInfo(mi)
        return mapOf(
            "totalPssKb" to mi.totalPss,
            "graphicsKb" to mi.getMemoryStat("summary.graphics")?.toIntOrNull(),
            "nativeHeapKb" to mi.getMemoryStat("summary.native-heap")?.toIntOrNull(),
        )
    }
}
