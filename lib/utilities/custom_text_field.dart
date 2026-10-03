import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.text,
    required this.onKeyPress,
    required this.onBackspace,
    this.focusNode,
  });

  final String text;
  final void Function(String text) onKeyPress;
  final void Function() onBackspace;
  final FocusNode? focusNode;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final controller = TextEditingController(text: widget.text);

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller.text != widget.text) {
      controller.value = TextEditingValue(
        text: widget.text,
        selection: TextSelection.collapsed(offset: widget.text.length),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: widget.focusNode,
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: false,
      showCursor: false,
      keyboardType: TextInputType.visiblePassword,
      textCapitalization: TextCapitalization.characters,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: .w800, letterSpacing: 2),
      decoration: const InputDecoration(hintText: 'TYPE HERE'),
      inputFormatters: [_KeyPressFormatter(widget.onKeyPress, widget.onBackspace)],
      onTapOutside: (_) {},
      onEditingComplete: () {},
    );
  }
}

class _KeyPressFormatter extends TextInputFormatter {
  _KeyPressFormatter(this.onKeyPress, this.onBackspace);

  final void Function(String text) onKeyPress;
  final void Function() onBackspace;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final typedLength = newValue.text.length - oldValue.text.length;
    final end = newValue.selection.end;

    if (typedLength < 0) {
      onBackspace();
    } else if (typedLength > 0 && end >= typedLength) {
      onKeyPress(newValue.text.substring(end - typedLength, end));
    }
    return oldValue;
  }
}
