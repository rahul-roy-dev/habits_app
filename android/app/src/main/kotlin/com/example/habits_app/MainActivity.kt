package com.example.habits_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.view.WindowManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.habits_app/full_screen_intent"
    private var wakeLock: PowerManager.WakeLock? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "openFullScreenIntentSettings" -> {
                    openFullScreenIntentSettings()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Allow activity to show over lock screen and turn screen on (required for full-screen reminder when screen is off).
        // Do not call requestDismissKeyguard here — it ran on every launch and duplicated/conflicted with system UI.
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON
            )
        }

        // When launched (e.g. by full-screen intent from scheduled notification), wake the device if screen is off.
        // Android 13+ may not turn screen on by default; a short WakeLock forces the display on.
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        val isInteractive = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT_WATCH) {
            pm.isInteractive
        } else {
            @Suppress("DEPRECATION")
            pm.isScreenOn
        }
        if (!isInteractive) {
            @Suppress("DEPRECATION")
            val wl = pm.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "habits_app:reminder_wake"
            )
            wl.acquire(10_000L) // 10 seconds
            wakeLock = wl
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    wl.release()
                } catch (_: Exception) { }
                wakeLock = null
            }, 10_000L)
        }
    }

    override fun onDestroy() {
        wakeLock?.let {
            try {
                if (it.isHeld) it.release()
            } catch (_: Exception) { }
            wakeLock = null
        }
        super.onDestroy()
    }

    /** Opens system settings so the user can grant "Display over other apps" / full-screen intent for this app (Android 14+). */
    private fun openFullScreenIntentSettings() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                data = Uri.parse("package:$packageName")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            try {
                startActivity(intent)
            } catch (_: Exception) { }
        }
    }
}
