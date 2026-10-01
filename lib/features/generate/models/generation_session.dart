import 'package:facepix/features/generate/models/generation_flow.dart';

/// Everything the user has chosen so far in one run through a flow.
///
/// Passed down the navigation stack; there is no backend yet, so it also
/// stands in for what would later be the generation request.
class GenerationSession {
  GenerationSession({
    required this.config,
    this.styleIndex = 0,
    this.photoPath,
    this.backgroundIndex = 0,
    this.photoSizeIndex = 0,
    this.fullName = '',
    this.professionalRole = '',
    this.background = '',
    this.videoPurposeIndex = 0,
    this.presentationStyleIndex = 0,
    this.videoLengthIndex = 0,
    this.extraNotes = '',
  });

  final FlowConfig config;

  int styleIndex;
  String? photoPath;

  // Customize (portrait / ID photo)
  int backgroundIndex;
  int photoSizeIndex;

  // Customize Video
  String fullName;
  String professionalRole;
  String background;
  int videoPurposeIndex;
  int presentationStyleIndex;
  int videoLengthIndex;
  String extraNotes;

  StyleOption get style => config.styles[styleIndex];

  GenerationSession copy() => GenerationSession(
    config: config,
    styleIndex: styleIndex,
    photoPath: photoPath,
    backgroundIndex: backgroundIndex,
    photoSizeIndex: photoSizeIndex,
    fullName: fullName,
    professionalRole: professionalRole,
    background: background,
    videoPurposeIndex: videoPurposeIndex,
    presentationStyleIndex: presentationStyleIndex,
    videoLengthIndex: videoLengthIndex,
    extraNotes: extraNotes,
  );
}
