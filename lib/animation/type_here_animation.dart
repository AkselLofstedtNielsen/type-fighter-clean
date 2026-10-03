import 'dart:async';

import 'package:material_ui/material_ui.dart';

class TypeHereAnimation extends StatefulWidget {
  const TypeHereAnimation({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<TypeHereAnimation> createState() => _TypeHereAnimationState();
}

class _TypeHereAnimationState extends State<TypeHereAnimation> with SingleTickerProviderStateMixin {
  late final bouncing = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
    ..repeat(reverse: true);
  late final Timer countDownTimer;
  int timeRemaining = 3;

  @override
  void initState() {
    super.initState();
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeRemaining > 1) {
        setState(() => timeRemaining -= 1);
      } else {
        countDownTimer.cancel();
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    countDownTimer.cancel();
    bouncing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: bouncing,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, -15 + 10 * Curves.easeIn.transform(bouncing.value)), child: child),
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            '$timeRemaining',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: .w900, color: color),
          ),
          Icon(Icons.arrow_downward_rounded, color: color, size: 32),
        ],
      ),
    );
  }
}
