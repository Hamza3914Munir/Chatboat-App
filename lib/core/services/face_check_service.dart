import 'package:flutter/services.dart';

/// Why a chosen photo cannot be used.
enum FaceCheckFailure { noFace, multipleFaces, faceTooSmall, unreadable }

/// Result of the on-device face check.
class FaceCheckResult {
  const FaceCheckResult._(this.faceCount, this.largestFaceArea, this.failure);

  const FaceCheckResult.ok(int faceCount, double largestFaceArea)
    : this._(faceCount, largestFaceArea, null);

  const FaceCheckResult.failed(
    FaceCheckFailure failure, {
    int faceCount = 0,
    double largestFaceArea = 0,
  }) : this._(faceCount, largestFaceArea, failure);

  final int faceCount;

  /// Area of the largest face as a fraction (0..1) of the whole image.
  final double largestFaceArea;

  final FaceCheckFailure? failure;

  bool get passed => failure == null;
}

/// On-device face detection, used to keep unusable photos from ever reaching a
/// paid generation API.
///
/// Backed by Apple Vision on iOS and Google ML Kit on Android — see
/// `ios/Runner/AppDelegate.swift` and `android/.../MainActivity.kt`. ML Kit is
/// not used on iOS because it ships no arm64 simulator slice.
class FaceCheckService {
  const FaceCheckService();

  static const _channel = MethodChannel('facepix/face_check');

  /// A face smaller than this fraction of the frame is too low-resolution to
  /// generate from.
  static const minimumFaceArea = 0.02;

  Future<FaceCheckResult> check(String imagePath) async {
    final Map<Object?, Object?>? response;
    try {
      response = await _channel.invokeMethod<Map<Object?, Object?>>(
        'detectFaces',
        {'path': imagePath},
      );
    } on PlatformException {
      return const FaceCheckResult.failed(FaceCheckFailure.unreadable);
    } on MissingPluginException {
      // No native implementation on this platform (e.g. web) — do not block.
      return const FaceCheckResult.ok(1, 1);
    }

    if (response == null) {
      return const FaceCheckResult.failed(FaceCheckFailure.unreadable);
    }

    final count = (response['count'] as num?)?.toInt() ?? 0;
    final area = (response['largestArea'] as num?)?.toDouble() ?? 0;

    // The platform reports that its detector could not run (the iOS simulator
    // has no working face model). Do not block the user on a false negative.
    if (response['unavailable'] == true) {
      return const FaceCheckResult.ok(1, 1);
    }

    if (count == 0) {
      return const FaceCheckResult.failed(FaceCheckFailure.noFace);
    }
    if (count > 1) {
      return FaceCheckResult.failed(
        FaceCheckFailure.multipleFaces,
        faceCount: count,
        largestFaceArea: area,
      );
    }
    if (area < minimumFaceArea) {
      return FaceCheckResult.failed(
        FaceCheckFailure.faceTooSmall,
        faceCount: count,
        largestFaceArea: area,
      );
    }
    return FaceCheckResult.ok(count, area);
  }
}
