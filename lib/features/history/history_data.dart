/// Static history entries transcribed from the Figma `History` frame.
/// Replaced by the user's real creations once generation is wired up.
enum CreationKind { portrait, video, idPhoto }

class HistoryEntry {
  const HistoryEntry({
    required this.title,
    required this.timeAgo,
    required this.asset,
    required this.kind,
  });

  final String title;
  final String timeAgo;
  final String asset;
  final CreationKind kind;

  bool get isVideo => kind == CreationKind.video;

  String get badgeLabel => switch (kind) {
    CreationKind.portrait => 'PORTRAIT',
    CreationKind.video => 'VIDEO',
    CreationKind.idPhoto => 'ID PHOTO',
  };
}

const historyEntries = <HistoryEntry>[
  HistoryEntry(
    title: 'Corporate Headshot',
    timeAgo: '1h ago',
    asset: 'assets/history/corporate_headshot.png',
    kind: CreationKind.portrait,
  ),
  HistoryEntry(
    title: 'Tech Presentation',
    timeAgo: '2h ago',
    asset: 'assets/history/tech_presentation.png',
    kind: CreationKind.video,
  ),
  HistoryEntry(
    title: 'Nature Dawn',
    timeAgo: '3h ago',
    asset: 'assets/history/nature_dawn.png',
    kind: CreationKind.video,
  ),
  HistoryEntry(
    title: 'Modern Professional',
    timeAgo: '3h ago',
    asset: 'assets/history/modern_professional.png',
    kind: CreationKind.portrait,
  ),
  HistoryEntry(
    title: 'Urban Sunset',
    timeAgo: '4h ago',
    asset: 'assets/history/urban_sunset.png',
    kind: CreationKind.video,
  ),
  HistoryEntry(
    title: 'Student ID',
    timeAgo: '6h ago',
    asset: 'assets/history/student_id.png',
    kind: CreationKind.idPhoto,
  ),
];
