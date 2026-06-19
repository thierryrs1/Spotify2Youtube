import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final report = context.read<AppState>().lastReport;

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Nenhum relatório disponível.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da Conversão'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 60),
                    const SizedBox(height: 10),
                    Text('${report.convertedTracks} músicas convertidas', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Text('${report.notFoundTracks} não encontradas', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
                    Text('Total processado: ${report.totalTracks}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Músicas não encontradas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: report.notFoundList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(report.notFoundList[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    );
  }
}
