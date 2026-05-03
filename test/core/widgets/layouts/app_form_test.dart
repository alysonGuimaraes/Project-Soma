import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_soma/core/widgets/layouts/app_form.dart';

void main() {
  // Envolve o AppForm com o mínimo necessário para renderizar
  // incluindo localizations pois o DatePicker exige
  Widget buildSubject({
    required List<AppFormSection> sections,
    void Function(Map<String, dynamic>)? onSubmit,
    VoidCallback? onClose,
    bool cleanInvisibleFields = false,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: Scaffold(
        body: AppForm(
          title: 'Formulário Teste',
          sections: sections,
          onSubmit: onSubmit ?? (_) {},
          onClose: onClose ?? () {},
          cleanInvisibleFields: cleanInvisibleFields,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Helpers de criação de campos
  // ─────────────────────────────────────────

  AppFormSection singleFieldSection(AppFormField field) {
    return AppFormSection(
      rows: [
        AppFormRow(fields: [field]),
      ],
    );
  }

  // ─────────────────────────────────────────
  // Header e Footer
  // ─────────────────────────────────────────

  group('AppForm | Header e Footer', () {
    testWidgets('deve exibir o título do formulário', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(const AppFormField(id: 'name', label: 'Nome')),
          ],
        ),
      );

      expect(find.text('Formulário Teste'), findsOneWidget);
    });

    testWidgets('deve chamar onClose ao clicar no botão fechar', (
      tester,
    ) async {
      bool closed = false;

      await tester.pumpWidget(
        buildSubject(
          onClose: () => closed = true,
          sections: [
            singleFieldSection(const AppFormField(id: 'name', label: 'Nome')),
          ],
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(closed, isTrue);
    });

    testWidgets('deve chamar onClose ao clicar em Cancelar', (tester) async {
      bool closed = false;

      await tester.pumpWidget(
        buildSubject(
          onClose: () => closed = true,
          sections: [
            singleFieldSection(const AppFormField(id: 'name', label: 'Nome')),
          ],
        ),
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pump();

      expect(closed, isTrue);
    });

    testWidgets('deve exibir mensagem de vazio quando não há campos visíveis', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            AppFormSection(
              rows: [
                AppFormRow(
                  fields: [
                    AppFormField(
                      id: 'hidden',
                      label: 'Oculto',
                      isVisible: () => false,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      expect(
        find.text('Nenhum campo disponível para exibição no momento.'),
        findsOneWidget,
      );
    });
  });

  // ─────────────────────────────────────────
  // Campo text
  // ─────────────────────────────────────────

  group('AppForm | Campo text', () {
    testWidgets('deve renderizar o label corretamente', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(const AppFormField(id: 'name', label: 'Nome')),
          ],
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
    });

    testWidgets('deve preencher o campo e submeter o valor', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(const AppFormField(id: 'name', label: 'Nome')),
          ],
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'João');
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['name'], 'João');
    });

    testWidgets('deve exibir erro quando campo obrigatório estiver vazio', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'name',
                label: 'Nome',
                isRequired: true,
                isRequiredMessage: 'Nome obrigatório',
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Nome obrigatório'), findsOneWidget);
    });

    testWidgets('deve aplicar o normalizer antes de salvar', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              AppFormField(
                id: 'name',
                label: 'Nome',
                normalizer: (val) => (val as String).toUpperCase(),
              ),
            ),
          ],
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'joão');
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['name'], 'JOÃO');
    });

    testWidgets('deve preencher o campo com initialValue', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'name',
                label: 'Nome',
                initialValue: 'João',
              ),
            ),
          ],
        ),
      );

      expect(find.text('João'), findsOneWidget);
    });

    testWidgets('deve submeter initialValue sem o usuário editar', (
      tester,
    ) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'name',
                label: 'Nome',
                initialValue: 'João',
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['name'], 'João');
    });
  });

  // ─────────────────────────────────────────
  // Campo number
  // ─────────────────────────────────────────

  group('AppForm | Campo number', () {
    testWidgets('deve submeter o valor digitado', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'value',
                label: 'Valor',
                type: AppFieldType.number,
              ),
            ),
          ],
        ),
      );

      await tester.enterText(find.byType(TextFormField), '25');
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['value'], 25.0);
    });

    testWidgets('deve exibir erro quando obrigatório e vazio', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'age',
                label: 'Idade',
                type: AppFieldType.number,
                isRequired: true,
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Campo boolean
  // ─────────────────────────────────────────

  group('AppForm | Campo boolean', () {
    testWidgets('deve inicializar com initialValue false', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'agreed',
                label: 'Concordo',
                type: AppFieldType.boolean,
                initialValue: false,
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['agreed'], isFalse);
    });

    testWidgets('deve inicializar com initialValue true', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'agreed',
                label: 'Concordo',
                type: AppFieldType.boolean,
                initialValue: true,
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['agreed'], isTrue);
    });

    testWidgets('deve alternar valor ao clicar no checkbox', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'agreed',
                label: 'Concordo',
                type: AppFieldType.boolean,
                initialValue: false,
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['agreed'], isTrue);
    });

    testWidgets('deve exibir erro quando isRequired e não marcado', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'agreed',
                label: 'Concordo com os termos',
                type: AppFieldType.boolean,
                isRequired: true,
                isRequiredMessage: 'Você deve aceitar os termos',
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Você deve aceitar os termos'), findsOneWidget);
    });

    testWidgets('deve aceitar initialValue como int (1 = true)', (
      tester,
    ) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'active',
                label: 'Ativo',
                type: AppFieldType.boolean,
                initialValue: 1,
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['active'], isTrue);
    });
  });

  // ─────────────────────────────────────────
  // Campo dropdown
  // ─────────────────────────────────────────

  group('AppForm | Campo dropdown', () {
    final items = [
      const AppDropDownItem(label: 'Ativo', value: 'active'),
      const AppDropDownItem(label: 'Inativo', value: 'inactive'),
    ];

    testWidgets('deve renderizar os itens do dropdown', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              AppFormField(
                id: 'status',
                label: 'Status',
                type: AppFieldType.dropdown,
                dropDownItems: items,
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<dynamic>));
      await tester.pumpAndSettle();

      expect(find.text('Ativo'), findsWidgets);
      expect(find.text('Inativo'), findsOneWidget);
    });

    testWidgets('deve submeter o valor selecionado', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            singleFieldSection(
              AppFormField(
                id: 'status',
                label: 'Status',
                type: AppFieldType.dropdown,
                dropDownItems: items,
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<dynamic>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inativo').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['status'], 'inactive');
    });

    testWidgets('deve exibir initialValue selecionado', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              AppFormField(
                id: 'status',
                label: 'Status',
                type: AppFieldType.dropdown,
                dropDownItems: items,
                initialValue: 'active',
              ),
            ),
          ],
        ),
      );

      expect(find.text('Ativo'), findsOneWidget);
    });

    testWidgets(
      'deve desabilitar e exibir mensagem quando initialValue não existe na lista',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            sections: [
              singleFieldSection(
                AppFormField(
                  id: 'status',
                  label: 'Status',
                  type: AppFieldType.dropdown,
                  dropDownItems: items,
                  initialValue: 'deleted',
                  outOfRangeMessage: 'Valor não encontrado na lista',
                ),
              ),
            ],
          ),
        );

        expect(find.text('Valor não encontrado na lista'), findsOneWidget);
      },
    );

    testWidgets(
      'deve exibir erro quando obrigatório e nenhum item selecionado',
      (tester) async {
        await tester.pumpWidget(
          buildSubject(
            sections: [
              singleFieldSection(
                AppFormField(
                  id: 'status',
                  label: 'Status',
                  type: AppFieldType.dropdown,
                  dropDownItems: items,
                  isRequired: true,
                ),
              ),
            ],
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pump();

        expect(find.text('Campo obrigatório'), findsOneWidget);
      },
    );
  });

  // ─────────────────────────────────────────
  // Campo custom
  // ─────────────────────────────────────────

  group('AppForm | Campo custom', () {
    testWidgets('deve renderizar o widget customizado', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              AppFormField(
                id: 'custom',
                label: 'Custom',
                type: AppFieldType.custom,
                customBuilder: (_) => const Text('Widget Customizado'),
              ),
            ),
          ],
        ),
      );

      expect(find.text('Widget Customizado'), findsOneWidget);
    });

    testWidgets('deve exibir aviso quando customBuilder for nulo', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            singleFieldSection(
              const AppFormField(
                id: 'custom',
                label: 'Custom',
                type: AppFieldType.custom,
              ),
            ),
          ],
        ),
      );

      expect(
        find.text('⚠️ customBuilder não informado para campo do tipo custom'),
        findsOneWidget,
      );
    });
  });

  // ─────────────────────────────────────────
  // Visibilidade dinâmica
  // ─────────────────────────────────────────

  group('AppForm | Visibilidade dinâmica', () {
    testWidgets('deve ocultar campo quando isVisible retorna false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            AppFormSection(
              rows: [
                AppFormRow(
                  fields: [
                    AppFormField(
                      id: 'hidden',
                      label: 'Campo Oculto',
                      isVisible: () => false,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Campo Oculto'), findsNothing);
    });

    testWidgets(
      'deve limpar campos ocultos do submit quando cleanInvisibleFields é true',
      (tester) async {
        bool showExtra = false;
        Map<String, dynamic>? result;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: AppForm(
                  title: 'Teste',
                  cleanInvisibleFields: true,
                  onClose: () {},
                  onSubmit: (data) => result = data,
                  sections: [
                    AppFormSection(
                      rows: [
                        AppFormRow(
                          fields: [
                            const AppFormField(id: 'name', label: 'Nome'),
                          ],
                        ),
                        AppFormRow(
                          fields: [
                            AppFormField(
                              id: 'extra',
                              label: 'Extra',
                              isVisible: () => showExtra,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pump();

        expect(result?.containsKey('extra'), isFalse);
      },
    );
  });

  // ─────────────────────────────────────────
  // Layout — seções e rows
  // ─────────────────────────────────────────

  group('AppForm | Layout', () {
    testWidgets('deve exibir o título da seção', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            AppFormSection(
              title: 'Dados Pessoais',
              rows: [
                AppFormRow(
                  fields: [const AppFormField(id: 'name', label: 'Nome')],
                ),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Dados Pessoais'), findsOneWidget);
    });

    testWidgets('deve renderizar dois campos na mesma row', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          sections: [
            AppFormSection(
              rows: [
                AppFormRow(
                  fields: [
                    const AppFormField(id: 'firstName', label: 'Nome'),
                    const AppFormField(id: 'lastName', label: 'Sobrenome'),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Sobrenome'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('deve submeter dados de múltiplas seções', (tester) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        buildSubject(
          onSubmit: (data) => result = data,
          sections: [
            AppFormSection(
              rows: [
                AppFormRow(
                  fields: [const AppFormField(id: 'name', label: 'Nome')],
                ),
              ],
            ),
            AppFormSection(
              rows: [
                AppFormRow(
                  fields: [const AppFormField(id: 'email', label: 'Email')],
                ),
              ],
            ),
          ],
        ),
      );

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'João');
      await tester.enterText(fields.at(1), 'joao@email.com');
      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(result?['name'], 'João');
      expect(result?['email'], 'joao@email.com');
    });
  });
}
