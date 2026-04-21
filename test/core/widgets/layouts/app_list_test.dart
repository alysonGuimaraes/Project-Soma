import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/core/widgets/errors/app_error_message.dart';
import 'package:project_soma/core/widgets/layouts/app_list.dart';
import 'package:project_soma/core/widgets/states/app_empty_state.dart';

void main() {
  Widget buildSubject({
    List<String> items = const [],
    bool isLoading = false,
    String? error,
    String emptyMessage = 'Nenhum item encontrado',
    VoidCallback? onRetry,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppList<String>(
          items: items,
          itemBuilder: (item) => Text(item),
          emptyMessage: emptyMessage,
          isLoading: isLoading,
          error: error,
          onRetry: onRetry,
        ),
      ),
    );
  }

  group('AppList |', () {
    testWidgets('deve exibir CircularProgressIndicator quando isLoading true', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(isLoading: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(AppEmptyState), findsNothing);
    });

    testWidgets('deve exibir AppErrorMessage quando error não for nulo', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(error: 'Erro ao carregar'));

      expect(find.byType(AppErrorMessage), findsOneWidget);
      expect(find.text('Erro ao carregar'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('deve chamar onRetry ao pressionar o botão de retry', (
      tester,
    ) async {
      bool retried = false;

      await tester.pumpWidget(
        buildSubject(error: 'Erro ao carregar', onRetry: () => retried = true),
      );

      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets('deve exibir AppEmptyState quando a lista for vazia', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(items: [], emptyMessage: 'Nenhuma transação encontrada'),
      );

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.text('Nenhuma transação encontrada'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('deve exibir o ListView quando houver itens', (tester) async {
      await tester.pumpWidget(
        buildSubject(items: ['Item 1', 'Item 2', 'Item 3']),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('deve renderizar cada item dentro de um Card', (tester) async {
      await tester.pumpWidget(buildSubject(items: ['Item 1', 'Item 2']));

      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('não deve exibir loading quando há erro', (tester) async {
      await tester.pumpWidget(
        buildSubject(isLoading: true, error: 'Erro ao carregar'),
      );

      // isLoading tem prioridade — erro não aparece
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(AppErrorMessage), findsNothing);
    });

    testWidgets('não deve exibir loading quando há itens', (tester) async {
      await tester.pumpWidget(buildSubject(isLoading: true, items: ['Item 1']));

      // isLoading tem prioridade — lista não aparece
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });
  });
}
