import 'package:facepix/core/preferences/auth_flow_preferences.dart';
import 'package:facepix/core/theme/home_colors.dart';
import 'package:facepix/features/auth/widgets/data_sharing_dialog.dart';
import 'package:facepix/features/history/history_screen.dart';
import 'package:facepix/features/home/home_screen.dart';
import 'package:facepix/features/profile/profile_screen.dart';
import 'package:facepix/features/shell/widgets/app_bottom_nav_bar.dart';
import 'package:facepix/features/templates/templates_screen.dart';
import 'package:flutter/material.dart';

/// Root shell for the signed-in app: the three bottom-nav destinations from
/// the Figma `BottomNavBar` (Home / History / Profile).
///
/// Templates is intentionally not a tab — in the design it is pushed on top of
/// the shell with a back arrow, from Home's "Try a Template" section.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  /// Placeholder balance until the credit ledger is wired up.
  final int _credits = 5;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeShowDataSharing(),
    );
  }

  Future<void> _maybeShowDataSharing() async {
    final acknowledged = await AuthFlowPreferences.isDataSharingAcknowledged();
    if (!acknowledged && mounted) {
      await showDataSharingDialog(context);
    }
  }

  void _openTemplates() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TemplatesScreen(
          onNavTap: (i) {
            Navigator.of(context).pop();
            setState(() => _index = i);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: [
            HomeScreen(credits: _credits, onOpenTemplates: _openTemplates),
            HistoryScreen(credits: _credits),
            ProfileScreen(credits: _credits),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNavBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
