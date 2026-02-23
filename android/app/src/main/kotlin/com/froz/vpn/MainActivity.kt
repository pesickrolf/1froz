package com.froz.vpn

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import android.content.Intent
import android.net.VpnService as AndroidVpnService

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.froz.vpn/service"
    private val EVENT_CHANNEL = "com.froz.vpn/status"
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "connect" -> {
                    val config = call.argument<String>("config")
                    if (config != null) {
                        connectVpn(config, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Config is required", null)
                    }
                }
                "disconnect" -> {
                    disconnectVpn(result)
                }
                "ping" -> {
                    val host = call.argument<String>("host")
                    if (host != null) {
                        pingHost(host, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Host is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }

    private fun connectVpn(config: String, result: MethodChannel.Result) {
        val intent = AndroidVpnService.prepare(this)
        if (intent != null) {
            startActivityForResult(intent, VPN_REQUEST_CODE)
            result.success(false)
        } else {
            val serviceIntent = Intent(this, VpnService::class.java)
            serviceIntent.putExtra("config", config)
            startService(serviceIntent)
            eventSink?.success("connecting")
            result.success(true)
        }
    }

    private fun disconnectVpn(result: MethodChannel.Result) {
        val serviceIntent = Intent(this, VpnService::class.java)
        stopService(serviceIntent)
        eventSink?.success("disconnected")
        result.success(true)
    }

    private fun pingHost(host: String, result: MethodChannel.Result) {
        Thread {
            try {
                val runtime = Runtime.getRuntime()
                val process = runtime.exec("/system/bin/ping -c 1 $host")
                val exitValue = process.waitFor()
                
                if (exitValue == 0) {
                    val output = process.inputStream.bufferedReader().readText()
                    val pingTime = extractPingTime(output)
                    result.success(pingTime)
                } else {
                    result.success(null)
                }
            } catch (e: Exception) {
                result.success(null)
            }
        }.start()
    }

    private fun extractPingTime(output: String): Int? {
        val regex = "time=(\\d+)".toRegex()
        val match = regex.find(output)
        return match?.groupValues?.get(1)?.toIntOrNull()
    }

    companion object {
        private const val VPN_REQUEST_CODE = 100
    }
}
