import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/core/widgets/components/app_text_form_field.dart';

void main() {
  Widget buildSubject(Widget widget) {
    return MaterialApp(home: Scaffold(body: widget));
  }

  group('AppTextFormField - Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets(
      'Deve renderizar com label e comportamento padrão (sem ícones e readOnly false)',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(AppTextFormField(controller: controller, label: 'Nome')),
        );

        expect(find.text('Nome'), findsOneWidget);
        expect(find.byType(Icon), findsNothing);

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.readOnly, isFalse);
      },
    );

    testWidgets('Deve exibir o prefixIcon quando o ícone for fornecido', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          AppTextFormField(
            controller: controller,
            label: 'Email',
            icon: Icons.email,
          ),
        ),
      );

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('Deve ativar o modo readOnly e exibir o ícone de calendário', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          AppTextFormField(
            controller: controller,
            label: 'Data',
            readOnly: true,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.readOnly, isTrue);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('Deve acionar o callback onTap quando clicado', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        buildSubject(
          AppTextFormField(
            controller: controller,
            label: 'Campo clicável',
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      );

      // Simula o clique no campo
      await tester.tap(find.byType(TextFormField));

      expect(wasTapped, isTrue);
    });
  });
}
