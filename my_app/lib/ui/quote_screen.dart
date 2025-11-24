import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quote_view_model.dart';
import '../data/quote_service.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuoteViewModel(QuoteService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Цитата дня'),
          backgroundColor: Colors.green,
        ),
        body: Consumer<QuoteViewModel>(
          builder: (context, viewModel, child) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.format_quote, size: 50, color: Colors.green),
                    const SizedBox(height: 20),
                    Text(
                      viewModel.quote,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => viewModel.loadQuote(),
                      child: const Text('Обновить цитату'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}