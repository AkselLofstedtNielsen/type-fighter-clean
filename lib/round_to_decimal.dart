import 'dart:math';

extension RoundToDecimal on double {
  double roundToDecimal(int fractionDigits) {
    final multiplier = pow(10, fractionDigits);
    return (this * multiplier).round() / multiplier;
  }
}
