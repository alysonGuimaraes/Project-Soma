import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/core/widgets/components/async_button.dart';
import 'package:project_soma/core/widgets/errors/app_error_message.dart';
import 'package:project_soma/core/widgets/layouts/app_form.dart';

void main() {
  Widget buildSubject({
    List<Widget> fields = const [],
    VoidCallback? onSubmit,
    bool isSubmitting = false,
    String? error,
    String submitLabel = 'Salvar',
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppForm(
          fields: fields,
          onSubmit: onSubmit,
          isSubmitting: isSubmitting,
          error: error,
          submitLabel: submitLabel,
        ),
      ),
    );
  }

  group('AppForm |', () {
    testWidgets('deve renderizar os fields fornecidos', (tester) async {
      await tester.pumpWidget(
        buildSubject(fields: [const Text('Campo 1'), const Text('Campo 2')]),
      );

      expect(find.text('Campo 1'), findsOneWidget);
      expect(find.text('Campo 2'), findsOneWidget);
    });

    testWidgets('deve renderizar o AsyncButton com o label correto', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(submitLabel: 'Confirmar'));

      expect(find.text('Confirmar'), findsOneWidget);
      expect(find.byType(AsyncButton), findsOneWidget);
    });

    testWidgets('deve usar o label padrão Salvar quando não informado', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('deve chamar onSubmit ao pressionar o botão', (tester) async {
      bool submitted = false;

      await tester.pumpWidget(buildSubject(onSubmit: () => submitted = true));

      await tester.tap(find.byType(AsyncButton));
      await tester.pump();

      expect(submitted, isTrue);
    });

    testWidgets('não deve chamar onSubmit quando isSubmitting é true', (
      tester,
    ) async {
      bool submitted = false;

      await tester.pumpWidget(
        buildSubject(isSubmitting: true, onSubmit: () => submitted = true),
      );

      await tester.tap(find.byType(AsyncButton));
      await tester.pump();

      expect(submitted, isFalse);
    });

    testWidgets('deve exibir o AppErrorMessage quando error não for nulo', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(error: 'Erro ao salvar'));

      expect(find.text('Erro ao salvar'), findsOneWidget);
      expect(find.byType(AppErrorMessage), findsOneWidget);
    });

    testWidgets('não deve exibir mensagem de erro quando error for nulo', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(error: null));

      expect(find.byType(AppErrorMessage), findsOneWidget); // widget existe
      expect(find.text('Erro ao salvar'), findsNothing); // mas sem texto
    });

    testWidgets('deve renderizar fields, error e botão na ordem correta', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          fields: [const Text('Campo')],
          error: 'Erro',
          submitLabel: 'Salvar',
        ),
      );

      // Captura posição vertical de cada elemento
      final fieldOffset = tester.getTopLeft(find.text('Campo')).dy;
      final errorOffset = tester.getTopLeft(find.text('Erro')).dy;
      final buttonOffset = tester.getTopLeft(find.byType(AsyncButton)).dy;

      expect(fieldOffset, lessThan(errorOffset));
      expect(errorOffset, lessThan(buttonOffset));
    });
  });
}
