package com.venzo.astroPrompt

import android.app.AlarmManager
import android.content.ContentValues
import android.content.Context
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability

class MainActivity : FlutterActivity() {
    private val ALARM_CHANNEL = "com.venzo.astroPrompt/alarm"
    private val FILE_CHANNEL = "com.venzo.astroPrompt/filesaver"
    private val UPDATE_CHANNEL = "com.venzo.astroPrompt/update"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Alarm method
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "canScheduleExactAlarms") {
                    val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                    result.success(alarmManager.canScheduleExactAlarms())
                } else {
                    result.notImplemented()
                }
            }

        // File saving method
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FILE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "saveFileToDownloads") {
                    val fileName = call.argument<String>("fileName") ?: return@setMethodCallHandler
                    val bytes = call.argument<ByteArray>("bytes") ?: return@setMethodCallHandler
                    val mimeType = call.argument<String>("mimeType") ?: "application/pdf"

                    val resolver = applicationContext.contentResolver
                    val contentValues = ContentValues().apply {
                        put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                        put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            put(
                                MediaStore.MediaColumns.RELATIVE_PATH,
                                Environment.DIRECTORY_DOWNLOADS
                            )
                        }
                    }

                    val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
                    if (uri != null) {
                        try {
                            val outputStream: OutputStream? = resolver.openOutputStream(uri)
                            outputStream?.write(bytes)
                            outputStream?.close()
                            result.success("File saved to Downloads")
                        } catch (e: Exception) {
                            result.error("SAVE_ERROR", "Failed to save file: ${e.message}", null)
                        }
                    } else {
                        result.error("SAVE_ERROR", "Unable to create file URI", null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        //update check method
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UPDATE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "checkForUpdate") {
                    val appUpdateManager = AppUpdateManagerFactory.create(this)
                    val appUpdateInfoTask = appUpdateManager.appUpdateInfo
                    appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
                        if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                            && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    }.addOnFailureListener {
                        result.error("ERROR", "Failed to check update", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
