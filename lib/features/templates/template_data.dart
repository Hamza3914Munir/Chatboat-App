import 'package:facepix/features/generate/models/generation_flow.dart';

/// Static template catalogue transcribed from the Figma `Template` frames.
/// Replaced by the backend catalogue once generation is wired up.
enum TemplateFilter { all, images, videos }

class AllTemplate {
  const AllTemplate({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.badge,
    required this.isVideo,
  });

  final String title;
  final String subtitle;
  final String asset;
  final String badge;
  final bool isVideo;

  GenerationFlow get flow =>
      isVideo ? GenerationFlow.video : GenerationFlow.portrait;
}

class ImageTemplate {
  const ImageTemplate({
    required this.title,
    required this.description,
    required this.asset,
    required this.flow,
  });

  final String title;
  final String description;
  final String asset;
  final GenerationFlow flow;
}

class VideoTemplate {
  const VideoTemplate({
    required this.title,
    required this.description,
    required this.asset,
    required this.badge,
  });

  final String title;
  final String description;
  final String asset;
  final String badge;
}

const allTemplates = <AllTemplate>[
  AllTemplate(
    title: 'Corporate Headshot',
    subtitle: 'Premium Business Portrait',
    asset: 'assets/templates/all_corporate_headshot.png',
    badge: 'IMAGE',
    isVideo: false,
  ),
  AllTemplate(
    title: 'Cinematic Profile',
    subtitle: 'Social Media',
    asset: 'assets/templates/all_cinematic_profile.png',
    badge: '10s',
    isVideo: true,
  ),
  AllTemplate(
    title: 'ID Passport',
    subtitle: 'Official Document Photo',
    asset: 'assets/templates/all_id_passport.png',
    badge: 'IMAGE',
    isVideo: false,
  ),
  AllTemplate(
    title: 'Photo Motion',
    subtitle: 'Animated Photo',
    asset: 'assets/templates/all_photo_motion.png',
    badge: '5s',
    isVideo: true,
  ),
];

const featuredTemplates = <AllTemplate>[
  AllTemplate(
    title: 'Style Avatar',
    subtitle: 'Modern, natural aesthetic',
    asset: 'assets/templates/all_style_avatar.png',
    badge: 'IMAGE',
    isVideo: false,
  ),
  AllTemplate(
    title: 'Professional Intro',
    subtitle: '4K Cinematic Intro',
    asset: 'assets/templates/all_professional_intro.png',
    badge: '15s',
    isVideo: true,
  ),
];

const imageTemplates = <ImageTemplate>[
  ImageTemplate(
    title: 'Anime Avatar',
    flow: GenerationFlow.avatar,
    description: 'Turns your photo into a\nhigh-quality drawn…',
    asset: 'assets/templates/img_anime_avatar.png',
  ),
  ImageTemplate(
    title: 'Studio Portrait',
    flow: GenerationFlow.portrait,
    description: 'Professional business\nlook for your profile.',
    asset: 'assets/templates/img_studio_portrait.png',
  ),
  ImageTemplate(
    title: 'Passport Photo',
    flow: GenerationFlow.idPhoto,
    description: 'Clean ID photo meeting official requirements.',
    asset: 'assets/templates/img_passport_photo.png',
  ),
  ImageTemplate(
    title: 'Corporate Headshot',
    flow: GenerationFlow.portrait,
    description: 'Premium business\nportrait for LinkedIn.',
    asset: 'assets/templates/img_corporate_headshot.png',
  ),
  ImageTemplate(
    title: 'Neon Avatar',
    flow: GenerationFlow.avatar,
    description: 'Stylized creative avatar\nwith neon glow.',
    asset: 'assets/templates/img_neon_avatar.png',
  ),
  ImageTemplate(
    title: 'Official ID',
    flow: GenerationFlow.idPhoto,
    description: 'Standard document\nphoto layout.',
    asset: 'assets/templates/img_official_id.png',
  ),
];

const videoTemplates = <VideoTemplate>[
  VideoTemplate(
    title: 'Photo Motion',
    description: 'Adds subtle natural\nmovement to your still…',
    asset: 'assets/templates/vid_photo_motion.png',
    badge: 'VIDEO • 5S',
  ),
  VideoTemplate(
    title: 'Urban Story',
    description: 'Dynamic urban scene with\nsmooth cinematic…',
    asset: 'assets/templates/vid_urban_story.png',
    badge: 'VIDEO • 12S',
  ),
  VideoTemplate(
    title: 'Studio Glow',
    description: 'Bright and creative\nworkspace setup for…',
    asset: 'assets/templates/vid_studio_glow.png',
    badge: 'VIDEO • 8S',
  ),
  VideoTemplate(
    title: 'Cinematic Profile',
    description: 'Turn your portrait into a\nmoving story.',
    asset: 'assets/templates/vid_cinematic_profile.png',
    badge: 'VIDEO • 10S',
  ),
  VideoTemplate(
    title: 'Professional Intro',
    description: 'Polished 15-second\ncinematic introduction.',
    asset: 'assets/templates/vid_professional_intro.png',
    badge: 'VIDEO • 15S',
  ),
  VideoTemplate(
    title: 'Creative Reveal',
    description: 'Dynamic transformation\nfrom photo to video.',
    asset: 'assets/templates/vid_creative_reveal.png',
    badge: 'VIDEO • 7S',
  ),
];
