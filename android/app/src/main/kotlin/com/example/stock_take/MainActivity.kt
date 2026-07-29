package com.example.stock_take

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private companion object {
        const val CHANNEL = "stock_take/printer_preferences"
        const val PREFERENCES = "stock_take_printer_preferences"
        const val ADDRESS_KEY = "selected_printer_address"
        const val NAME_KEY = "selected_printer_name"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            val preferences = getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
            when (call.method) {
                "loadSelectedPrinter" -> {
                    val address = preferences.getString(ADDRESS_KEY, null)
                    if (address.isNullOrBlank()) {
                        result.success(null)
                    } else {
                        result.success(
                            mapOf(
                                "address" to address,
                                "name" to preferences.getString(NAME_KEY, "").orEmpty(),
                            ),
                        )
                    }
                }

                "saveSelectedPrinter" -> {
                    val address = call.argument<String>("address")
                    val name = call.argument<String>("name").orEmpty()
                    if (address.isNullOrBlank()) {
                        result.error(
                            "invalid_printer",
                            "Printer address is required.",
                            null,
                        )
                    } else {
                        val saved = preferences.edit()
                            .putString(ADDRESS_KEY, address)
                            .putString(NAME_KEY, name)
                            .commit()
                        if (saved) {
                            result.success(null)
                        } else {
                            result.error(
                                "save_failed",
                                "Unable to persist selected printer.",
                                null,
                            )
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
