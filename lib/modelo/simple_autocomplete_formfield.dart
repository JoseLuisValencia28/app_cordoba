// ignore_for_file: unnecessary_null_comparison

library simple_autocomplete_formfield;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textfield_state/textfield_state.dart';

typedef SuggestionsBuilder = Widget Function(
    BuildContext context, List<Widget> items);
typedef ItemToString<T> = String Function(T item);
typedef ItemFromString<T> = T Function(String string);

// ignore: must_be_immutable
class SimpleAutocompleteFormField<T> extends FormField<T> {
  final int minSearchLength;
  final int maxSuggestions;
  final SuggestionsBuilder suggestionsBuilder;
  final double suggestionsHeight;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final ItemToString<T> itemToString;
  final ItemFromString<T> itemFromString;
  final Future<List<T>> Function(String search) onSearch;
  final ValueChanged<T>? onChanged;
  final IconData resetIcon;
  late TextEditingController? controller;
  final FocusNode focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final T? initialValue;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int maxLines;
  final int? maxLength;
  final EdgeInsets scrollPadding;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  void Function(T?)? onFieldSubmitted;
  GestureTapCallback? onTap;

  SimpleAutocompleteFormField({
    Key? key,
    this.minSearchLength = 0,
    required this.maxSuggestions,
    required this.itemBuilder,
    required this.onSearch,
    SuggestionsBuilder? suggestionsBuilder,
    this.suggestionsHeight = 200.0,
    required this.itemToString,
    required this.itemFromString,
    this.onChanged,
    this.resetIcon = Icons.close,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<T>? validator,
    FormFieldSetter<T>? onSaved,
    void Function(T?)? onFieldSubmitted, // Parámetro opcional
    GestureTapCallback? onTap, // Parámetro opcional
    TextEditingController? controller,
    required this.focusNode,
    this.initialValue,
    this.decoration = const InputDecoration(),
    this.keyboardType = TextInputType.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textCapitalization = TextCapitalization.none,
    required this.inputFormatters,
  })  : suggestionsBuilder = suggestionsBuilder ?? _defaultSuggestionsBuilder,
        super(
          key: key,
          autovalidateMode: autovalidateMode,
          validator: validator,
          onSaved: onSaved,
          builder: (FormFieldState<T> field) {
            final state = field as _SimpleAutocompleteFormFieldState<T>;
            return state.build(state.context);
          },
        ) {
    // Inicialización correcta de las variables opcionales
    this.onFieldSubmitted ??= (_) {};
    this.onTap ??= () {};
    this.controller;
  }

  @override
  _SimpleAutocompleteFormFieldState<T> createState() =>
      _SimpleAutocompleteFormFieldState<T>();

  static Widget _defaultSuggestionsBuilder(
      BuildContext context, List<Widget> items) {
    return Column(children: items);
  }
}

class _SimpleAutocompleteFormFieldState<T> extends FormFieldState<T> {
  @override
  SimpleAutocompleteFormField<T> get widget =>
      super.widget as SimpleAutocompleteFormField<T>;

  List<T> suggestions = [];
  bool showSuggestions = false;
  bool showResetIcon = false;
  T? tappedSuggestion;
  late TextFieldState state;

  bool get hasFocus => state.focusNode.hasFocus;
  bool get hasText => state.controller.text.isNotEmpty;

  void textChanged(String text) {
    setState(
        () => showSuggestions = text.trim().length >= widget.minSearchLength);
  }

  void focusChanged(bool focused) {
    setState(() => showSuggestions = focused &&
        state.controller.text.trim().length >= widget.minSearchLength);
  }

  @override
  void initState() {
    super.initState();
    state = TextFieldState(
      textChanged: textChanged,
      focusChanged: focusChanged,
      text: widget.initialValue != null
          ? widget.itemToString(widget.initialValue!)
          : '',
      controller: widget.controller,
      focusNode: widget.focusNode,
    );
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  T? get _value => _toObject(state.controller.text, widget.itemFromString);

  @override
  void setValue(T? value) {
    super.setValue(value);
    if (value != null) {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: state.controller,
          focusNode: state.focusNode,
          decoration: widget.decoration.copyWith(
            suffixIcon: showResetIcon
                ? IconButton(icon: Icon(widget.resetIcon), onPressed: clear)
                : null,
          ),
          keyboardType: widget.keyboardType,
          style: widget.style,
          textAlign: widget.textAlign,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          scrollPadding: widget.scrollPadding,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          onFieldSubmitted: (value) => widget.onFieldSubmitted?.call(_value),
          validator: (value) => widget.validator?.call(_value),
          onTap: widget.onTap,
          onSaved: (value) => widget.onSaved?.call(_value),
        ),
        if (showSuggestions)
          FutureBuilder<List<Widget>>(
            future: _buildSuggestions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return widget.suggestionsBuilder(context, snapshot.data ?? []);
            },
          ),
      ],
    );
  }

  Future<List<Widget>> _buildSuggestions() async {
    final suggestions = await widget.onSearch(state.controller.text);
    return suggestions.take(widget.maxSuggestions).map((suggestion) {
      return InkWell(
        child: widget.itemBuilder(context, suggestion),
        onTap: () {
          setState(() {
            tappedSuggestion = suggestion;
            state.controller.text = _toString(suggestion, widget.itemToString);
            state.focusNode.unfocus();
            showSuggestions = false;
          });
        },
      );
    }).toList();
  }

  void clear() {
    setState(() {
      state.controller.clear();
      showSuggestions = false;
    });
  }
}

String _toString<T>(T? value, ItemToString<T> fn) =>
    value != null ? fn(value) : '';
T? _toObject<T>(String s, ItemFromString<T> fn) => s.isNotEmpty ? fn(s) : null;
