import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/core/widgets/states/app_empty_state.dart';

void main() {
  Widget buildTestableWidget(Widget widget) {
    return CupertinoApp(home: widget);
  }

  group('AppEmptyState Widget Tests', () {
    testWidgets(
      'Deve exibir apenas a mensagem quando nenhum ícone for fornecido',
      (WidgetTester tester) async {
        const emptyMessage = 'Nenhum resultado encontrado.';

        await tester.pumpWidget(
          buildTestableWidget(const AppEmptyState(message: emptyMessage)),
        );

        expect(find.text(emptyMessage), findsOneWidget);

        expect(find.byType(Icon), findsNothing);
      },
    );

    testWidgets(
      'Deve exibir a mensagem e o ícone com tamanho 48 quando o ícone for fornecido',
      (WidgetTester tester) async {
        const emptyMessage = 'Sem conexão com a internet.';
        const testIcon = CupertinoIcons.wifi_slash;

        await tester.pumpWidget(
          buildTestableWidget(
            const AppEmptyState(message: emptyMessage, icon: testIcon),
          ),
        );

        expect(find.text(emptyMessage), findsOneWidget);

        final iconFinder = find.byType(Icon);
        expect(iconFinder, findsOneWidget);

        final iconWidget = tester.widget<Icon>(iconFinder);

        expect(iconWidget.icon, testIcon);
        expect(iconWidget.size, 48.0);
      },
    );
  });
}
