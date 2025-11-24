import 'package:flutter/foundation.dart';
import '../data/quote_service.dart';

class QuoteViewModel extends ChangeNotifier {
  final QuoteService _service;
  String _quote = 'Загрузка...';

  String get quote => _quote;

  QuoteViewModel(this._service) {
    loadQuote();
  }

  Future<void> loadQuote() async {
    _quote = 'Загрузка...';
    notifyListeners();

    _quote = await _service.getDailyQuote();
    notifyListeners();
  }
}