/// The four generation flows. Every flow runs the same skeleton — style →
/// (customize) → upload → generating → result — differing only in copy, style
/// list and whether it has a customize step, so one set of screens drives all
/// four.
enum GenerationFlow { avatar, portrait, idPhoto, video }

class StyleOption {
  const StyleOption({
    required this.title,
    required this.description,
    required this.asset,
    this.duration,
    this.popular = false,
  });

  final String title;
  final String description;
  final String asset;

  /// Video flows only, e.g. `15-20 SEC`.
  final String? duration;
  final bool popular;
}

class FlowConfig {
  const FlowConfig({
    required this.flow,
    required this.appBarTitle,
    required this.styleHeading,
    required this.styleSubtitle,
    required this.styles,
    required this.mediaKindLabel,
    required this.privacyNoun,
    required this.generatingTitle,
    required this.generatingStepLabel,
    required this.generatingCaption,
    required this.resultSuccess,
    required this.resultReady,
    required this.resultBody,
    required this.resultPreviewLabel,
    required this.hasCustomize,
  });

  final GenerationFlow flow;

  /// Title in the style screen's app bar.
  final String appBarTitle;
  final String styleHeading;
  final String styleSubtitle;
  final List<StyleOption> styles;

  /// `Image` or `Video`, shown under the style name on the upload screen.
  final String mediaKindLabel;

  /// Completes "Your photo is used only to create your selected …".
  final String privacyNoun;

  final String generatingTitle;
  final String generatingStepLabel;
  final String generatingCaption;

  final String resultSuccess;
  final String resultReady;
  final String resultBody;
  final String resultPreviewLabel;

  final bool hasCustomize;

  bool get isVideo => flow == GenerationFlow.video;

  static FlowConfig of(GenerationFlow flow) => switch (flow) {
    GenerationFlow.avatar => _avatar,
    GenerationFlow.portrait => _portrait,
    GenerationFlow.idPhoto => _idPhoto,
    GenerationFlow.video => _video,
  };
}

const _avatarStyles = <StyleOption>[
  StyleOption(
    title: 'Realistic Avatar',
    description: 'Natural AI-enhanced\nportrait',
    asset: 'assets/generate/styles/style_realistic.png',
  ),
  StyleOption(
    title: '3D Avatar',
    description: 'Polished 3D character style',
    asset: 'assets/generate/styles/style_3d_avatar.png',
  ),
  StyleOption(
    title: 'Anime',
    description: 'Stylized anime-inspired\nportrait',
    asset: 'assets/generate/styles/style_anime.png',
  ),
  StyleOption(
    title: 'Cartoon',
    description: 'Fun illustrated version of\nyou',
    asset: 'assets/generate/styles/style_cartoon.png',
  ),
  StyleOption(
    title: 'Artistic',
    description: 'Creative illustrated portrait',
    asset: 'assets/generate/styles/style_artistic.png',
  ),
  StyleOption(
    title: 'Cinematic',
    description: 'Stylized cinematic portrait',
    asset: 'assets/generate/styles/style_cinematic.png',
  ),
];

const _portraitStyles = <StyleOption>[
  StyleOption(
    title: 'Corporate Headshot',
    description: 'Clean, Polished headshot\nfor work',
    asset: 'assets/generate/styles/style_realistic.png',
  ),
  StyleOption(
    title: 'LinkedIn Portrait',
    description: 'Professional profile photo\nfor LinkedIn',
    asset: 'assets/generate/styles/style_linkedin.png',
  ),
  StyleOption(
    title: 'Business Casual',
    description: 'Professional and\napproachable',
    asset: 'assets/generate/styles/style_anime.png',
  ),
  StyleOption(
    title: 'Executive Portrait',
    description: 'Premium look for senior\nprofessionals',
    asset: 'assets/generate/styles/style_cartoon.png',
  ),
  StyleOption(
    title: 'Creative Professional',
    description: 'Modern portrait for\ncreative careers',
    asset: 'assets/generate/styles/style_artistic.png',
  ),
  StyleOption(
    title: 'Studio Portrait',
    description: 'Clean studio style\nprofessional photo',
    asset: 'assets/generate/styles/style_cinematic.png',
  ),
];

const _idStyles = <StyleOption>[
  StyleOption(
    title: 'Passport',
    description: 'Standard passport photo',
    asset: 'assets/generate/styles/style_realistic.png',
  ),
  StyleOption(
    title: 'Visa',
    description: 'Visa Application photo',
    asset: 'assets/generate/styles/style_3d_avatar.png',
  ),
  StyleOption(
    title: 'Driver License',
    description: 'Licence ready\nphoto',
    asset: 'assets/generate/styles/style_anime.png',
  ),
  StyleOption(
    title: 'Student ID',
    description: 'Photo for student\nidentification.',
    asset: 'assets/generate/styles/style_cartoon.png',
  ),
  StyleOption(
    title: 'National ID',
    description: 'Standard identification\nphoto',
    asset: 'assets/generate/styles/style_artistic.png',
  ),
  StyleOption(
    title: 'Employee ID',
    description: 'Professional workplace\nphoto',
    asset: 'assets/generate/styles/style_cinematic.png',
  ),
];

const _videoStyles = <StyleOption>[
  StyleOption(
    title: 'Professional Intro',
    description: 'Create a polished\nintroduction video for…',
    asset: 'assets/generate/styles/vstyle_professional_intro.png',
    duration: '15-20 SEC',
    popular: true,
  ),
  StyleOption(
    title: 'Cinematic Clip',
    description: 'Turn your photo into a\nshort cinematic video.',
    asset: 'assets/generate/styles/vstyle_cinematic_clip.png',
    duration: '5-10 SEC',
  ),
  StyleOption(
    title: 'Photo Motion',
    description: 'Add natural movement and\nsubtle animation to your…',
    asset: 'assets/generate/styles/vstyle_photo_motion.png',
    duration: '5-8 SEC',
  ),
  StyleOption(
    title: 'Profile Video',
    description: 'Create a short video for\nyour profile, portfolio or…',
    asset: 'assets/generate/styles/vstyle_profile_video.png',
    duration: '10-15 SEC',
  ),
  StyleOption(
    title: 'Animated Avatar',
    description: 'Bring your AI avatar to life\nwith natural motion.',
    asset: 'assets/generate/styles/vstyle_animated_avatar.png',
    duration: '5-10 SEC',
  ),
  StyleOption(
    title: 'Talking Photo',
    description: 'Turn your photo into a\nspeaking video with AI.',
    asset: 'assets/generate/styles/vstyle_talking_photo.png',
    duration: '10-20 SEC',
  ),
];

const _avatar = FlowConfig(
  flow: GenerationFlow.avatar,
  appBarTitle: 'AI Avatars',
  styleHeading: 'Choose your avatar style',
  styleSubtitle: 'Choose a style and turn your photo into a unique AI avatar.',
  styles: _avatarStyles,
  mediaKindLabel: 'Image',
  privacyNoun: 'avatar',
  generatingTitle: 'Generating your photo',
  generatingStepLabel: 'Creating avatar',
  generatingCaption: 'Creating your avatar',
  resultSuccess: 'Avatar created successfully',
  resultReady: 'Your avatar is ready!',
  resultBody:
      "We've enhanced your features and styled\nyour photo in a professional setting.",
  resultPreviewLabel: 'Your Avatar',
  hasCustomize: false,
);

const _portrait = FlowConfig(
  flow: GenerationFlow.portrait,
  appBarTitle: 'Professional Portraits',
  // "potrait" is the spelling used in the Figma file.
  styleHeading: 'Choose your potrait style',
  styleSubtitle: 'Choose a style and turn your photo into a unique AI avatar.',
  styles: _portraitStyles,
  mediaKindLabel: 'Image',
  privacyNoun: 'Portrait',
  generatingTitle: 'Generating your photo',
  generatingStepLabel: 'Creating Portrait',
  generatingCaption: 'Creating your Portrait',
  resultSuccess: 'Portrait  created successfully',
  resultReady: 'Your portrait is ready!',
  resultBody:
      "We've enhanced your features and styled\nyour photo in a professional setting.",
  resultPreviewLabel: 'Your Portrait',
  hasCustomize: true,
);

const _idPhoto = FlowConfig(
  flow: GenerationFlow.idPhoto,
  appBarTitle: 'ID Photos',
  styleHeading: 'Choose your ID Photo',
  styleSubtitle: 'Choose a style and turn your photo into a unique AI avatar.',
  styles: _idStyles,
  mediaKindLabel: 'Image',
  privacyNoun: 'ID Photo',
  generatingTitle: 'Generating your photo',
  generatingStepLabel: 'Creating ID Photo',
  generatingCaption: 'Creating your ID Photo',
  resultSuccess: 'ID Photo  created successfully',
  resultReady: 'Your ID Photo is ready!',
  resultBody:
      "We've enhanced your features and styled\nyour photo in a professional setting.",
  resultPreviewLabel: 'Your ID Photo',
  hasCustomize: true,
);

const _video = FlowConfig(
  flow: GenerationFlow.video,
  appBarTitle: 'Video Styles',
  styleHeading: 'Choose your Video Style',
  styleSubtitle:
      'Choose how you would like to bring your photo to life with AI',
  styles: _videoStyles,
  mediaKindLabel: 'Video',
  privacyNoun: 'Video',
  generatingTitle: 'Generating your Video',
  generatingStepLabel: 'Creating Video',
  generatingCaption: 'Creating your Video',
  resultSuccess: 'Video  created successfully',
  resultReady: 'Your Video is ready!',
  resultBody:
      "We've enhanced your features and styled\nyour video in a professional setting.",
  resultPreviewLabel: 'Your Video',
  hasCustomize: true,
);
