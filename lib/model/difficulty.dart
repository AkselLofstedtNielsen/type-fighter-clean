enum Difficulty {
  easy,
  medium,
  hard;

  double get fallingDuration => switch (this) {
    .easy => 8.0,
    .medium => 6.0,
    .hard => 4.0,
  };

  double get spawnInterval => switch (this) {
    .easy => 2.5,
    .medium => 2.0,
    .hard => 1.5,
  };

  int get multiplier => switch (this) {
    .easy => 1,
    .medium => 2,
    .hard => 3,
  };

  String get displayName => name[0].toUpperCase() + name.substring(1);
}
