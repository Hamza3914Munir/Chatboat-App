import 'dart:async';

/// Countdown that gates "resend" actions.
///
/// Verification and reset emails are rate limited by every mail provider, so
/// the button has to stop accepting taps for a while after one is requested.
/// Keeping the countdown in one object means the screens only have to render
/// it, and that the timer has a single, reliable [dispose].
class AuthResendCooldown {
  AuthResendCooldown({
    required this.onTick,
    this.duration = const Duration(seconds: 30),
  });

  /// Called once per second while counting down, and once more when it ends.
  final void Function() onTick;
  final Duration duration;

  Timer? _timer;
  int _secondsRemaining = 0;

  int get secondsRemaining => _secondsRemaining;
  bool get isActive => _secondsRemaining > 0;

  void start() {
    _timer?.cancel();
    _secondsRemaining = duration.inSeconds;
    // Cancels itself at zero so no timer outlives the countdown — a pending
    // periodic timer fails widget tests and leaks in release.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      if (_secondsRemaining <= 0) {
        _secondsRemaining = 0;
        timer.cancel();
        _timer = null;
      }
      onTick();
    });
    onTick();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
