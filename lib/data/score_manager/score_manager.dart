import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static final ScoreManager _instance = ScoreManager._internal();

  factory ScoreManager() {
    return _instance;
  }

  ScoreManager._internal();

  final Map<String, int> _correctAnswers = {};
  final Map<String, int> _totalQuestions = {};

  /// **Load saved scores from SharedPreferences**
  Future<void> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    _correctAnswers.clear();
    _totalQuestions.clear();

    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('correct_')) {
        String topic = key.substring(8); // Remove "correct_" prefix
        _correctAnswers[topic] = prefs.getInt(key) ?? 0;
      } else if (key.startsWith('total_')) {
        String topic = key.substring(6); // Remove "total_" prefix
        _totalQuestions[topic] = prefs.getInt(key) ?? 0;
      }
    }
  }

  /// **Update score by replacing the old score with the new one**
  Future<void> updateScore(String topic, int correct, int total) async {
    _correctAnswers[topic] = correct; // Replace previous correct answers
    _totalQuestions[topic] = total; // Replace previous total questions

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('correct_$topic', correct);
    await prefs.setInt('total_$topic', total);
  }

  /// **Get percentage score for a topic**
  double getScorePercentage(String topic) {
    if ((_totalQuestions[topic] ?? 0) == 0) return 0.0;
    return ((_correctAnswers[topic]! / _totalQuestions[topic]!) * 100);
  }

  /// **Get all topic scores as percentages**
  Map<String, double> getAllScores() {
    return _correctAnswers.map((topic, correct) {
      double percentage = getScorePercentage(topic);
      return MapEntry(topic, percentage);
    });
  }
}
