import 'dart:math';

const TIMESTAMPS_COUNT = 50000;
const PROBABILITY_SCORE_CHANGED = 0.0001;
const PROBABILITY_HOME_SCORE = 0.45;
const OFFSET_MAX_STEP = 3;

class Score {
  final int home;
  final int away;

  Score({required this.home, required this.away});
}

class Stamp {
  final int offset;
  final Score score;

  Stamp({required this.offset, required this.score});
}

final Stamp emptyScoreStamp = Stamp(
  offset: 0,
  score: Score(
    home: 0,
    away: 0,
  ),
);

List<Stamp> generateGame() {
  final stamps =
      List<Stamp>.generate(TIMESTAMPS_COUNT, (score) => emptyScoreStamp);

  var currentStamp = stamps[0];

  for (var i = 0; i < TIMESTAMPS_COUNT; i++) {
    currentStamp = generateStamp(currentStamp);
    stamps[i] = currentStamp;
  }

  return stamps;
}

Stamp generateStamp(Stamp prev) {
  final scoreChanged = Random().nextDouble() > 1 - PROBABILITY_SCORE_CHANGED;
  final homeScoreChange =
      scoreChanged && Random().nextDouble() < PROBABILITY_HOME_SCORE ? 1 : 0;

  final awayScoreChange = scoreChanged && !(homeScoreChange > 0) ? 1 : 0;
  final offsetChange = (Random().nextDouble() * OFFSET_MAX_STEP).floor() + 1;

  return Stamp(
    offset: prev.offset + offsetChange,
    score: Score(
        home: prev.score.home + homeScoreChange,
        away: prev.score.away + awayScoreChange),
  );
}

Score getScore(List<Stamp> gameStamps, int offset) {
  int start = 0;
  int end = gameStamps.length - 1;

  while (start < end) {
    int mid = start + ((end - start) >> 1);
    if (gameStamps[mid].offset <= offset) {
      start = mid + 1;
    } else {
      end = mid;
    }
  }

  if (gameStamps[start].offset > offset && start > 0) {
    start--;
  }

  return gameStamps[start].score;
}
