import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/core/widgets/errors/app_error_message.dart';

void main() {
  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(home: Scaffold(body: widget));
  }

  group('AppErrorMessage Widget Tests', () {
    testWidgets('Deve renderizar SizedBox.shrink quando o erro for nulo', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(const AppErrorMessage(error: null)),
      );

      expect(find.byType(Column), findsNothing);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets(
      'Deve exibir a mensagem de erro com a cor vermelha quando fornecida',
      (WidgetTester tester) async {
        const errorMessage = 'Erro de conexão';

        await tester.pumpWidget(
          buildTestableWidget(const AppErrorMessage(error: errorMessage)),
        );

        final textFinder = find.text(errorMessage);
        expect(textFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.style?.color, Colors.red);
      },
    );

    testWidgets(
      'Não deve exibir o botão de tentar novamente se onRetry for nulo',
      (WidgetTester tester) async {
        const errorMessage = 'Erro de conexão';

        await tester.pumpWidget(
          buildTestableWidget(
            const AppErrorMessage(error: errorMessage, onRetry: null),
          ),
        );

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byType(TextButton), findsNothing);
        expect(find.text('Tentar novamente'), findsNothing);
      },
    );

    testWidgets(
      'Deve exibir o botão e acionar a callback onRetry ao ser clicado',
      (WidgetTester tester) async {
        const errorMessage = 'Erro de conexão';
        bool retryClicked = false;

        await tester.pumpWidget(
          buildTestableWidget(
            AppErrorMessage(
              error: errorMessage,
              onRetry: () {
                retryClicked = true;
              },
            ),
          ),
        );

        expect(find.text(errorMessage), findsOneWidget);

        final buttonFinder = find.byType(TextButton);
        expect(buttonFinder, findsOneWidget);
        expect(find.text('Tentar novamente'), findsOneWidget);

        await tester.tap(buttonFinder);
        await tester.pump();

        expect(retryClicked, isTrue);
      },
    );
  });
}
