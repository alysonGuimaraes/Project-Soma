import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Define os tipos de campos suportados nativamente pelo Form.
enum AppFieldType { text, number, date, dropdown, boolean, custom }

/// Definição de um campo individual do formulário.
class AppFormField {
  final String id;
  final String label;
  final AppFieldType type;
  final void Function(dynamic)? onChanged;
  final Icon? prefixIcon;
  final Icon? sufixIcon;

  /// Permite injetar um controller externo.
  final TextEditingController? controller;

  /// Define a proporção de espaço que o campo ocupa na linha (útil para Rows).
  /// Padrão é 1. Se um campo tem flex 2 e outro 1, o primeiro ocupa 2/3 da tela.
  final int flex;

  /// Função que avalia se o campo deve ser renderizado.
  /// Permite criar formulários dinâmicos (ex: mostrar campo X só se Y for preenchido).
  final bool Function()? isVisible;

  /// Permite injetar um widget customizado caso [type] seja [AppFieldType.custom].
  final Widget Function(BuildContext context)? customBuilder;

  // --- Validação ---
  final bool isRequired;
  final String isRequiredMessage;

  /// Permite utilizar validadores customizados para verificar campos do formulário.
  final String? Function(String?)? customValidator;

  // --- Formatação e Normalização ---
  /// Permite utilizar formatador de texto personalizado.
  /// Usuário não precisa digitar no formato correto (Ex.: Usuário digita CPF 12345678900, campo no formulario mostra valor 123.456.789-00)
  final List<TextInputFormatter>? formatters;

  /// Recebe a string visível na UI e retorna o dado pronto para o DTO.
  /// Retorna `dynamic` pois pode converter "R$ 15,00" para o double `15.0`.
  final dynamic Function(dynamic)? normalizer;

  /// Lista estática de opções para um field dropdown.
  final List<AppDropDownItem>? dropDownItems;

  /// Valor inicial do campo. Essencial para campos que não usam TextEditingController
  /// como booleans (true/false) ou para facilitar a injeção em telas de edição.
  final dynamic initialValue;

  /// Data mínima permitida no DatePicker (Padrão: 1900)
  final DateTime? firstDate;

  /// Data máxima permitida no DatePicker (Padrão: 2100)
  final DateTime? lastDate;

  // --- Especificos para o dropdown ---
  /// Mensagem de erro ao inicializar um dropdown com um valor fora dos itens da lista.
  final String? outOfRangeMessage;

  final bool? dropdownEnabled;
  final String? dropdownHelperText;

  /// Permite injetar opções extras além da lista principal (ex.: item legado).
  final List<AppDropDownItem>? extraDropDownItems;

  // --- Rebuild do formulário ---
  /// Booleano que define se o field do formulario vai ou não fazer o mesmo sofrer rebuild.
  final bool triggersVisibilityRebuild;

  const AppFormField({
    required this.id,
    required this.label,
    this.type = AppFieldType.text,
    this.prefixIcon,
    this.sufixIcon,
    this.onChanged,
    this.controller,
    this.flex = 1,
    this.isVisible,
    this.customBuilder,
    this.isRequired = false,
    this.isRequiredMessage = 'Campo obrigatório',
    this.customValidator,
    this.formatters,
    this.normalizer,
    this.dropDownItems,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.outOfRangeMessage,
    this.triggersVisibilityRebuild = false,
    this.dropdownHelperText,
    this.extraDropDownItems,
    this.dropdownEnabled = true,
  });

  /// Verifica se o campo deve ser renderizado no momento atual.
  bool get shouldRender => isVisible == null || isVisible!();
}

/// Representa uma opção dentro de um Dropdown.
class AppDropDownItem {
  final String label;
  final dynamic value;

  const AppDropDownItem({required this.label, required this.value});
}

/// Define uma linha do formulário, podendo conter 1 ou N campos.
class AppFormRow {
  final List<AppFormField> fields;

  const AppFormRow({required this.fields});

  /// Retorna apenas os campos que passam na condição de visibilidade.
  List<AppFormField> get visibleFields =>
      fields.where((f) => f.shouldRender).toList();
}

/// Agrupa diversas linhas em uma seção com título opcional.
class AppFormSection {
  final String? title;
  final List<AppFormRow> rows;

  const AppFormSection({this.title, required this.rows});

  /// Verifica se a seção possui pelo menos um campo visível para ser renderizada.
  bool get hasVisibleFields => rows.any((r) => r.visibleFields.isNotEmpty);
}

class AppForm extends StatefulWidget {
  final String title;
  final double? width;
  final double? height;
  final List<AppFormSection> sections;
  final void Function(Map<String, dynamic> data) onSubmit;
  final VoidCallback onClose;
  final String emptyMessage;
  final bool cleanInvisibleFields;

  const AppForm({
    super.key,
    required this.title,
    required this.sections,
    required this.onSubmit,
    required this.onClose,
    this.width,
    this.height,
    this.emptyMessage = 'Nenhum campo disponível para exibição no momento.',
    this.cleanInvisibleFields = false,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  final _formKey = GlobalKey<FormState>();

  // Formulario mantêm os valores obtidos aqui antes de avançar
  final Map<String, dynamic> _formData = {};

  @override
  void initState() {
    super.initState();
    _seedFormDataFromInitialValues();
  }

  @override
  void didUpdateWidget(covariant AppForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Garante que novos campos adicionados dinamicamente recebam valor inicial,
    // sem sobrescrever valores já preenchidos/alterados pelo usuário.
    _seedFormDataFromInitialValues();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Verifica se existe pelo menos uma seção com campos visíveis
    final hasAnyVisibleField = widget.sections.any((s) => s.hasVisibleFields);

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(theme),
          const Divider(height: 1),

          Expanded(
            child: !hasAnyVisibleField
                ? Center(child: Text(widget.emptyMessage))
                : _buildFormBody(),
          ),

          const Divider(height: 1),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
        ],
      ),
    );
  }

  Widget _buildFormBody() {
    return Form(
      key: _formKey,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.sections.length,
        itemBuilder: (context, index) {
          final section = widget.sections[index];
          if (!section.hasVisibleFields) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (section.title != null) ...[
                Text(
                  section.title!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ...section.rows.map((row) => _buildRow(row)),
              const SizedBox(height: 24), // Espaçamento entre seções
            ],
          );
        },
      ),
    );
  }

  Widget _buildRow(AppFormRow row) {
    final visibleFields = row.visibleFields;
    if (visibleFields.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: visibleFields.asMap().entries.map((entry) {
          final isLast = entry.key == visibleFields.length - 1;
          final field = entry.value;

          return Expanded(
            flex: field.flex,
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 16.0),
              child: _buildField(field),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildField(AppFormField field) {
    if (field.type == AppFieldType.custom) {
      if (field.customBuilder == null) {
        return const Text(
          '⚠️ customBuilder não informado para campo do tipo custom',
          style: TextStyle(color: Colors.red),
        );
      }
      return field.customBuilder!(context);
    }

    if (field.type == AppFieldType.dropdown) {
      final allItems = <AppDropDownItem>[
        ...?field.extraDropDownItems,
        ...?field.dropDownItems,
      ];

      final initialValueExists =
          field.initialValue == null ||
          allItems.any((item) => item.value == field.initialValue);

      final effectiveItems = initialValueExists
          ? allItems
          : <AppDropDownItem>[];

      return DropdownButtonFormField<dynamic>(
        isExpanded: true,
        value: initialValueExists ? field.initialValue : null,
        decoration: InputDecoration(
          labelText: field.label,
          isDense: true,
          helperText: initialValueExists
              ? field.dropdownHelperText
              : (field.outOfRangeMessage ??
                    'Valor inicial "${field.initialValue}" não encontrado na lista de opções.'),
          prefixIcon: field.prefixIcon,
          suffixIcon: field.sufixIcon,
        ),
        items: effectiveItems
            .map(
              (item) =>
                  DropdownMenuItem(value: item.value, child: Text(item.label)),
            )
            .toList(),
        onChanged: field.dropdownEnabled!
            ? (value) {
                field.onChanged?.call(value);
                if (field.triggersVisibilityRebuild) setState(() {});
              }
            : null,
        validator: (val) {
          if (field.isRequired && val == null) return field.isRequiredMessage;
          return field.customValidator?.call(val?.toString());
        },
        onSaved: (val) => _formData[field.id] = field.normalizer != null
            ? field.normalizer!(val)
            : val,
      );
    }

    if (field.type == AppFieldType.boolean) {
      return FormField<bool>(
        initialValue: _parseInitialBool(field.initialValue),

        // A validação de obrigatoriedade em um boolean geralmente significa
        // "O usuário precisa marcar essa caixa" (ex: Aceitar Termos de Uso).
        validator: (val) {
          if (field.isRequired && val != true) return field.isRequiredMessage;

          return null;
        },

        // Salva o valor final. Se você precisar que a API receba 1/0 ou "S"/"N",
        // basta passar isso no seu normalizer no momento de criar o campo.
        onSaved: (val) {
          _formData[field.id] = field.normalizer != null
              ? field.normalizer!(val)
              : (val ?? false);
        },

        builder: (FormFieldState<bool> state) {
          final theme = Theme.of(context);

          return InputDecorator(
            decoration: InputDecoration(
              // Oculta o labelTible se não houver erro, para não duplicar com o texto do Checkbox
              labelText: state.hasError ? null : ' ',
              errorText: state.hasError ? state.errorText : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              isDense: true,
              prefixIcon: field.prefixIcon,
              suffixIcon: field.sufixIcon,
            ),
            // isEmpty diz pro InputDecorator manter a borda ativa se marcado
            isEmpty: state.value == false,
            child: CheckboxListTile(
              title: Text(field.label, style: theme.textTheme.bodyMedium),
              value: state.value,
              onChanged: (value) {
                state.didChange(value);
                if (field.onChanged != null) field.onChanged!(value);
                if (field.triggersVisibilityRebuild) {
                  setState(() {});
                }
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              // Removemos as bordas e fundo internos do ListTile para não brigar com o Decorator
              tileColor: Colors.transparent,
            ),
          );
        },
      );
    }

    if (field.type == AppFieldType.date) {
      return _AppDateField(
        field: field,
        onSaved: (val) => _formData[field.id] = val,
        onRequestFormRebuild: () => setState(() {}),
      );
    }

    if (field.type == AppFieldType.number) {
      return TextFormField(
        controller: field.controller,
        initialValue: field.controller == null
            ? field.initialValue?.toString()
            : null,
        onChanged: (value) {
          field.onChanged?.call(value);
          if (field.triggersVisibilityRebuild) {
            setState(() {});
          }
        },
        // Mobile
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters:
            field.formatters ??
            [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
        decoration: InputDecoration(
          labelText: field.label,
          isDense: true,
          prefixIcon: field.prefixIcon,
          suffixIcon: field.sufixIcon,
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (field.isRequired && text.isEmpty) return field.isRequiredMessage;
          return field.customValidator?.call(text);
        },
        onSaved: (value) {
          final text = value?.trim() ?? '';

          final numberValue = field.normalizer != null
              ? field.normalizer!(text)
              : _parseToDouble(value: value);

          _formData[field.id] = numberValue;
        },
      );
    }

    return TextFormField(
      controller: field.controller,
      initialValue: field.controller == null
          ? field.initialValue?.toString()
          : null,
      onChanged: (value) {
        field.onChanged?.call(value);
        if (field.triggersVisibilityRebuild) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        labelText: field.label,
        isDense: true,
        prefixIcon: field.prefixIcon,
        suffixIcon: field.sufixIcon,
      ),
      inputFormatters: field.formatters,
      validator: (value) {
        final text = value?.trim() ?? '';

        if (field.isRequired && text.isEmpty) {
          return field.isRequiredMessage;
        }

        if (field.customValidator != null) {
          return field.customValidator!(text);
        }

        return null;
      },
      onSaved: (value) {
        final text = value?.trim() ?? '';

        // Usa o normalizador de texto, caso exista, antes de salvar
        final finalValue = field.normalizer != null
            ? field.normalizer!(text)
            : text;

        _formData[field.id] = finalValue;
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: widget.onClose,
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();

                Map<String, dynamic> finalData = Map.from(_formData);

                if (widget.cleanInvisibleFields) {
                  final visibleIds = widget.sections
                      .expand((s) => s.rows)
                      .expand((r) => r.visibleFields)
                      .map((f) => f.id)
                      .toSet();

                  finalData = Map.fromEntries(
                    _formData.entries.where((e) => visibleIds.contains(e.key)),
                  );
                }

                widget.onSubmit(finalData);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  bool _parseInitialBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toUpperCase() == 'S' || value.toUpperCase() == 'TRUE';
    }
    return false;
  }

  double _parseToDouble({String decimalSeparator = ',', required value}) {
    if (value.trim().isEmpty) return 0.0;

    final regex = RegExp('[^0-9\\-$decimalSeparator]');
    String cleaned = value.replaceAll(regex, '');

    if (cleaned.isEmpty || cleaned == '-') return 0.0;

    cleaned = cleaned.replaceAll(decimalSeparator, '.');

    return double.tryParse(cleaned) ?? 0.0;
  }

  void _seedFormDataFromInitialValues() {
    for (final section in widget.sections) {
      for (final row in section.rows) {
        for (final field in row.fields) {
          if (_formData.containsKey(field.id)) continue;

          if (field.type == AppFieldType.custom) continue;

          if (field.type == AppFieldType.boolean) {
            _formData[field.id] = _parseInitialBool(field.initialValue);
            continue;
          }

          _formData[field.id] = field.initialValue;
        }
      }
    }
  }
}

class _AppDateField extends StatefulWidget {
  final AppFormField field;
  final void Function(dynamic) onSaved;
  final VoidCallback onRequestFormRebuild;

  const _AppDateField({
    required this.field,
    required this.onSaved,
    required this.onRequestFormRebuild,
  });

  @override
  State<_AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<_AppDateField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Se você passou um controller externo, usamos ele.
    // Se não, criamos um interno já injetando o initialValue (se existir).
    _controller =
        widget.field.controller ??
        TextEditingController(text: widget.field.initialValue?.toString());
  }

  @override
  void dispose() {
    // Só damos dispose se o controller for interno
    if (widget.field.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Tenta fazer o parse da data atual digitada para abrir o calendário no mês certo
    DateTime initialDate = DateTime.now();
    if (_controller.text.length == 10) {
      // Formato DD/MM/AAAA
      try {
        final parts = _controller.text.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {} // Se a data digitada for inválida, ignora e usa hoje
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.field.firstDate ?? DateTime(1900),
      lastDate: widget.field.lastDate ?? DateTime(2100),
      // Definimos o locale para garantir que o calendário fique em Português
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      // Formata a data escolhida de volta para DD/MM/AAAA e injeta no campo
      final dia = picked.day.toString().padLeft(2, '0');
      final mes = picked.month.toString().padLeft(2, '0');
      final ano = picked.year.toString();

      final dataFormatada = '$dia/$mes/$ano';

      setState(() {
        _controller.text = dataFormatada;
      });

      // Se existir um onChanged na configuração, avisa a tela externa
      if (widget.field.onChanged != null) {
        widget.field.onChanged!(dataFormatada);
      }

      if (widget.field.triggersVisibilityRebuild) {
        widget.onRequestFormRebuild();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      inputFormatters: widget.field.formatters,
      // Mobile
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.field.label,
        isDense: true,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, size: 20),
          onPressed: () => _selectDate(context),
        ),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (widget.field.isRequired && text.isEmpty) {
          return widget.field.isRequiredMessage;
        }

        if (widget.field.customValidator != null) {
          return widget.field.customValidator!(text);
        }
        return null;
      },
      onChanged: (value) {
        widget.field.onChanged?.call(value);
        if (widget.field.triggersVisibilityRebuild) {
          widget.onRequestFormRebuild();
        }
      },
      onSaved: (value) {
        final text = value?.trim() ?? '';
        final finalValue = widget.field.normalizer != null
            ? widget.field.normalizer!(text)
            : text;

        widget.onSaved(finalValue);
      },
    );
  }
}
