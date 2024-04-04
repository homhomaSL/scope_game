import 'package:test/test.dart';
import 'package:scope_game/game.dart';

void main() {
  group('getScore', () {
    test('Возвращает начальный счет при offset 0', () {
      final game = generateGame();
      final score = getScore(game, 0);
      expect(score.home, equals(0));
      expect(score.away, equals(0));
    });

    test('Возвращает корректный счет при offset в середине игры', () {
      final game = generateGame();
      final midGameOffset = game[game.length ~/ 2].offset;
      final score = getScore(game, midGameOffset);
      final expectedScore =
          game.firstWhere((stamp) => stamp.offset >= midGameOffset).score;
      expect(score.home, equals(expectedScore.home));
      expect(score.away, equals(expectedScore.away));
    });

    test('Возвращает конечный счет при offset больше максимального', () {
      final game = generateGame();
      final score = getScore(game, game.last.offset + 1000);
      expect(score.home, equals(game.last.score.home));
      expect(score.away, equals(game.last.score.away));
    });
  });
}
