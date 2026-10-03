import 'package:material_ui/material_ui.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText(this.text, {super.key, required this.matching, this.style});

  final String text;
  final String matching;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final highlighted = text.startsWith(matching) ? matching.length : 0;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, highlighted),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          TextSpan(text: text.substring(highlighted)),
        ],
      ),
      style: style,
    );
  }
}
