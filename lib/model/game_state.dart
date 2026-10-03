enum GameState {
  notStarted,
  playing,
  paused,
  won,
  lost;

  String get displayName => switch (this) {
    .notStarted => 'Ready',
    .playing => 'Playing',
    .paused => 'Paused',
    .won => 'Victory!',
    .lost => 'Game Over',
  };
}
