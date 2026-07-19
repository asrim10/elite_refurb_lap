import 'package:flutter/material.dart';

/// A text widget that highlights portions matching a [query] string.
///
/// When [query] is empty, it renders a plain [Text] widget with the given
/// [style]. Otherwise it splits [text] by the query (case‑insensitive) and
/// wraps each match in a highlighted [TextSpan].
class HighlightedText extends StatelessWidget {
  /// The full text to display.
  final String text;

  /// The search term whose occurrences should be highlighted.
  /// When empty, no highlighting is applied.
  final String query;

  /// The base text style applied to non‑matched segments.
  final TextStyle? style;

  /// If null, a default highlight style is derived from [style].
  final TextStyle? highlightStyle;

  /// The background colour used for highlighted segments.
  /// Defaults to a warm amber yellow.
  final Color? highlightColor;

  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
    this.highlightColor,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final q = query.trim();
    if (q.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final spans = _buildSpans();
    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }

  List<TextSpan> _buildSpans() {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase().trim();

    final defaultStyle = style ?? const TextStyle();
    final highlightBg = highlightColor ?? const Color(0xFFFFE0B2); // Amber 200
    final hlStyle = highlightStyle ??
        defaultStyle.copyWith(
          backgroundColor: highlightBg,
          fontWeight: FontWeight.w600,
        );

    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        // No more matches — add the remaining text
        spans.add(TextSpan(
          text: text.substring(start),
          style: defaultStyle,
        ));
        break;
      }

      // Text before the match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: defaultStyle,
        ));
      }

      // The matching portion
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: hlStyle,
      ));

      start = index + query.length;
    }

    return spans;
  }
}
