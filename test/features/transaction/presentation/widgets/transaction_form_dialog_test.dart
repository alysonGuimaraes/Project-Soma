import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_soma/core/widgets/components/app_switch_tile.dart';
import 'package:project_soma/core/widgets/components/app_text_form_field.dart';
import 'package:project_soma/features/transaction/presentation/controllers/transaction_form_controller.dart';
import 'package:project_soma/features/transaction/presentation/widgets/transaction_form_dialog.dart';
import 'package:provider/provider.dart';

import '../../mocks/transaction_mocks.mocks.dart';

void main() {
  late MockTransactionFormController mockController;

  setUp(() {
    mockController = MockTransactionFormController();
  });

  Widget buildSubject({
    bool isSubmitting = false,
    String? error,
    bool success = false,
  }) {
    when(mockController.isSubmitting).thenReturn(isSubmitting);
    when(mockController.error).thenReturn(error);
    when(mockController.success).thenReturn(success);

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: ChangeNotifierProvider<TransactionFormController>.value(
        value: mockController,
        child: const Scaffold(body: TransactionFormDialog()),
      ),
    );
  }

  group('TransactionFormDialog - Widget Tests', () {
    testWidgets(
      'Deve renderizar os campos iniciais e esconder a seção de transação fixa por padrão',
      (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.text('Nova Transação'), findsOneWidget);
        expect(find.text('Valor (R\$)'), findsOneWidget);
        expect(find.text('Data de transação'), findsOneWidget);
        expect(find.text('Observação (Opcional)'), findsOneWidget);

        expect(find.text('Tempo indeterminado (Assinatura)'), findsNothing);
        expect(find.text('Mês/Ano Final'), findsNothing);
      },
    );

    testWidgets(
      'Deve exibir os campos de assinatura ao marcar como transação fixa',
      (tester) async {
        await tester.pumpWidget(buildSubject());

        final switchFinder = find.widgetWithText(
          AppSwitchTile,
          'É uma transação fixa?',
        );

        await tester.ensureVisible(switchFinder);
        expect(switchFinder, findsOneWidget);

        await tester.tap(switchFinder);
        await tester.pumpAndSettle();

        expect(find.text('Tempo indeterminado (Assinatura)'), findsOneWidget);
        expect(find.text('Mês/Ano Final'), findsNothing);
      },
    );

    testWidgets(
      'Deve exibir o campo de Mes/Ano Final ao desmarcar Tempo Indeterminado',
      (tester) async {
        await tester.pumpWidget(buildSubject());

        final fixedSwitchFinder = find.widgetWithText(
          AppSwitchTile,
          'É uma transação fixa?',
        );
        await tester.ensureVisible(fixedSwitchFinder);
        await tester.tap(fixedSwitchFinder);
        await tester.pumpAndSettle();

        final indefiniteSwitchFinder = find.widgetWithText(
          CheckboxListTile,
          'Tempo indeterminado (Assinatura)',
        );
        await tester.ensureVisible(indefiniteSwitchFinder);
        await tester.tap(indefiniteSwitchFinder);
        await tester.pumpAndSettle();

        expect(find.text('Mês/Ano Final'), findsOneWidget);
      },
    );

    testWidgets(
      'Deve realizar o parsing correto dos dados e acionar formatters.save',
      (tester) async {
        when(
          mockController.save(
            value: anyNamed('value'),
            categoryId: anyNamed('categoryId'),
            transactionDate: anyNamed('transactionDate'),
            observation: anyNamed('observation'),
            isFixed: anyNamed('isFixed'),
            isPaid: anyNamed('isPaid'),
            finalMonthYear: anyNamed('finalMonthYear'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(buildSubject(success: true));

        final valorField = find.widgetWithText(AppTextFormField, 'Valor (R\$)');
        await tester.ensureVisible(valorField);
        await tester.enterText(valorField, '2.500,75');

        final dataField = find.widgetWithText(
          AppTextFormField,
          'Data de transação',
        );
        await tester.ensureVisible(dataField);
        await tester.enterText(dataField, '20/12/2025');

        final obsField = find.widgetWithText(
          AppTextFormField,
          'Observação (Opcional)',
        );
        await tester.ensureVisible(obsField);
        await tester.enterText(obsField, 'Pagamento de serviço');

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final saveButton = find.widgetWithText(ElevatedButton, 'Salvar');

        await tester.dragUntilVisible(
          saveButton,
          find.byType(SingleChildScrollView),
          const Offset(0, -200),
        );
        await tester.pumpAndSettle();

        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        verify(
          mockController.save(
            value: 2500.75,
            categoryId: 'cat_provisoria_01',
            transactionDate: DateTime(2025, 12, 20),
            observation: 'Pagamento de serviço',
            isFixed: false,
            isPaid: true,
            finalMonthYear: null,
          ),
        ).called(1);
      },
    );

    testWidgets(
      'Não deve chamar o formatters.save se o formulário for inválido',
      (tester) async {
        await tester.pumpWidget(buildSubject());

        final saveButton = find.text('Salvar');
        await tester.ensureVisible(saveButton);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        verifyNever(
          mockController.save(
            value: anyNamed('value'),
            categoryId: anyNamed('categoryId'),
            transactionDate: anyNamed('transactionDate'),
            observation: anyNamed('observation'),
            isFixed: anyNamed('isFixed'),
            isPaid: anyNamed('isPaid'),
            finalMonthYear: anyNamed('finalMonthYear'),
          ),
        );
      },
    );
  });
}
