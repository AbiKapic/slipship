import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _piecesKey = 'pieces_collected';

  Future<int> getPiecesCollected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_piecesKey) ?? 0;
  }

  Future<void> addPiece() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_piecesKey) ?? 0;
    await prefs.setInt(_piecesKey, (current + 1).clamp(0, 9));
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_piecesKey, 0);
  }
}


