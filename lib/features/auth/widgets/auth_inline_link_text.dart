import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// One run of text inside an [AuthInlineLinkText]. A null [onTap] renders as
/// plain body copy; a non-null one renders as a tappable link.
class AuthLinkSpan {
  const AuthLinkSpan(this.text, {this.onTap});

  const AuthLinkSpan.link(this.text, this.onTap);

  final String text;
  final VoidCallback? onTap;
}

/// A sentence with tappable links in it.
///
/// Exists so the [TapGestureRecognizer]s get disposed. Building them inline in
/// a `build()` method — as the auth screens used to — leaks one recognizer per
/// link per rebuild, because nothing ever calls `dispose()` on them.
class AuthInlineLinkText extends StatefulWidget {
  const AuthInlineLinkText({
    super.key,
    required this.spans,
    required this.baseStyle,
    required this.linkStyle,
    this.textAlign = TextAlign.center,
  });

  final List<AuthLinkSpan> spans;
  final TextStyle baseStyle;
  final TextStyle linkStyle;
  final TextAlign textAlign;

  @override
  State<AuthInlineLinkText> createState() => _AuthInlineLinkTextState();
}

class _AuthInlineLinkTextState extends State<AuthInlineLinkText> {
  /// One recognizer per span index, created once and reused across rebuilds.
  final _recognizers = <int, TapGestureRecognizer>{};

  @override
  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    super.dispose();
  }

  /// Reads the callback off `widget` at tap time rather than capturing it, so a
  /// recognizer created on an earlier build never calls a stale closure.
  TapGestureRecognizer _recognizerFor(int index) {
    return _recognizers.putIfAbsent(
      index,
      () => TapGestureRecognizer()
        ..onTap = () {
          if (index < widget.spans.length) widget.spans[index].onTap?.call();
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        style: widget.baseStyle,
        children: [
          for (var i = 0; i < widget.spans.length; i++)
            if (widget.spans[i].onTap == null)
              TextSpan(text: widget.spans[i].text)
            else
              TextSpan(
                text: widget.spans[i].text,
                style: widget.linkStyle,
                recognizer: _recognizerFor(i),
                // Without this a screen reader reads the whole sentence as one
                // blob and never announces the link.
                semanticsLabel: widget.spans[i].text,
              ),
        ],
      ),
    );
  }
}
