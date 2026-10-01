package com.skyensolutions.facepix

import android.graphics.BitmapFactory
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetectorOptions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// On-device face detection backed by ML Kit.
///
/// iOS uses Apple Vision through the matching channel in AppDelegate.swift,
/// because ML Kit ships no arm64 iOS-simulator slice.
class MainActivity : FlutterActivity() {
    private val channelName = "facepix/face_check"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "detectFaces") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val path = call.argument<String>("path")
                if (path == null) {
                    result.error("bad_args", "path is required", null)
                    return@setMethodCallHandler
                }
                detectFaces(path, result)
            }
    }

    private fun detectFaces(path: String, result: MethodChannel.Result) {
        val bitmap = BitmapFactory.decodeFile(path)
        if (bitmap == null) {
            result.error("decode_failed", "Could not read image", path)
            return
        }

        val options = FaceDetectorOptions.Builder()
            .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_ACCURATE)
            .build()
        val detector = FaceDetection.getClient(options)

        detector.process(InputImage.fromBitmap(bitmap, 0))
            .addOnSuccessListener { faces ->
                val imageArea = (bitmap.width * bitmap.height).toDouble()
                // Largest face as a fraction of the image, matching the iOS
                // payload so Dart can apply one rule to both platforms.
                val largest = faces.maxOfOrNull { face ->
                    val box = face.boundingBox
                    (box.width().toDouble() * box.height().toDouble()) / imageArea
                } ?: 0.0
                result.success(mapOf("count" to faces.size, "largestArea" to largest))
                detector.close()
            }
            .addOnFailureListener { error ->
                result.error("mlkit_failed", error.localizedMessage, null)
                detector.close()
            }
    }
}
