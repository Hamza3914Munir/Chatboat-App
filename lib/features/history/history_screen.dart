import 'package:facepix/core/theme/history_colors.dart';
import 'package:facepix/features/history/history_data.dart';
import 'package:facepix/features/history/widgets/history_card.dart';
import 'package:facepix/features/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Figma `History` (2304:1023) — 375x1367.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.credits});

  final int credits;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _filter = 0;

  static const _filters = [
    'All',
    'Avatars',
    'Portraits',
    'ID Photos',
    'Videos',
  ];

  List<HistoryEntry> get _visible => switch (_filter) {
    1 => const <HistoryEntry>[],
    2 => historyEntries.where((e) => e.kind == CreationKind.portrait).toList(),
    3 => historyEntries.where((e) => e.kind == CreationKind.idPhoto).toList(),
    4 => historyEntries.where((e) => e.kind == CreationKind.video).toList(),
    _ => historyEntries,
  };

  @override
  Widget build(BuildContext context) {
    final entries = _visible;

    return Container(
      color: HistoryColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeAppBar(credits: widget.credits),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'History',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 32 / 24,
                            color: HistoryColors.title,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage and review your AI creations.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 20 / 14,
                            color: HistoryColors.subtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _filterChips(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: _grid(entries),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = i == _filter;
          return GestureDetector(
            onTap: () => setState(() => _filter = i),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: active
                    ? HistoryColors.chipActive
                    : HistoryColors.chipInactive,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                _filters[i],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  height: 20 / 14,
                  color: active
                      ? Colors.white
                      : HistoryColors.chipInactiveLabel,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _grid(List<HistoryEntry> entries) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Text(
          'Nothing here yet.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 14, color: HistoryColors.subtitle),
        ),
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < entries.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HistoryCard(
                entry: entries[i],
                onTap: () {},
                onMenu: () {},
              ),
            ),
            const SizedBox(width: 16),
            if (i + 1 < entries.length)
              Expanded(
                child: HistoryCard(
                  entry: entries[i + 1],
                  onTap: () {},
                  onMenu: () {},
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < entries.length) rows.add(const SizedBox(height: 16));
    }
    return Column(children: rows);
  }
}
