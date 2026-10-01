import Flutter
import UIKit
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    FaceCheckPlugin.register(
      with: engineBridge.pluginRegistry.registrar(forPlugin: "FaceCheckPlugin")!
    )
  }
}

/// On-device face detection backed by Apple's Vision framework.
///
/// Vision is used instead of Google ML Kit because ML Kit ships no arm64
/// iOS-simulator slice, which makes it impossible to build or test on Apple
/// Silicon. Vision is free, fully on-device and needs no extra SDK.
/// Android uses ML Kit through the matching channel in MainActivity.kt.
enum FaceCheckPlugin {
  static let channelName = "facepix/face_check"

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "detectFaces" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let args = call.arguments as? [String: Any],
        let path = args["path"] as? String
      else {
        result(FlutterError(code: "bad_args", message: "path is required", details: nil))
        return
      }
      detectFaces(atPath: path, result: result)
    }
  }

  private static func detectFaces(atPath path: String, result: @escaping FlutterResult) {
    guard let image = UIImage(contentsOfFile: path), let cgImage = image.cgImage else {
      result(FlutterError(code: "decode_failed", message: "Could not read image", details: path))
      return
    }

    let orientation = cgOrientation(from: image.imageOrientation)

    DispatchQueue.global(qos: .userInitiated).async {
      let request = VNDetectFaceRectanglesRequest()
      let handler = VNImageRequestHandler(
        cgImage: cgImage,
        orientation: orientation,
        options: [:]
      )
      do {
        try handler.perform([request])
        let faces = request.results ?? []
        // Largest face as a fraction of the image, so Dart can reject faces
        // that are too small to generate from.
        let largest = faces
          .map { $0.boundingBox.width * $0.boundingBox.height }
          .max() ?? 0
        DispatchQueue.main.async {
          result([
            "count": faces.count,
            "largestArea": Double(largest),
            "unavailable": false,
          ])
        }
      } catch {
        // Vision cannot create an ML inference context in the arm64 iOS
        // simulator, so every request fails there. Report the detector as
        // unavailable rather than as "no face": a broken detector must not
        // make the app unusable, and Dart lets the photo through instead of
        // showing a false "we couldn't detect a clear face".
        DispatchQueue.main.async {
          result([
            "count": 0,
            "largestArea": 0.0,
            "unavailable": true,
          ])
        }
      }
    }
  }

  private static func cgOrientation(
    from orientation: UIImage.Orientation
  ) -> CGImagePropertyOrientation {
    switch orientation {
    case .up: return .up
    case .down: return .down
    case .left: return .left
    case .right: return .right
    case .upMirrored: return .upMirrored
    case .downMirrored: return .downMirrored
    case .leftMirrored: return .leftMirrored
    case .rightMirrored: return .rightMirrored
    @unknown default: return .up
    }
  }
}
