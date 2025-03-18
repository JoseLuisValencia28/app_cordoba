library dropdownfield;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownField extends FormField<String> {
  final String? value;
  final Widget? icon;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final bool required;
  final bool enabled;
  final List<String>? items;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<String>? setter;
  final ValueChanged<String>? onValueChanged;
  final bool strict;
  final int itemsVisibleInDropdown;

  final TextEditingController? controller;

  DropDownField({
    Key? key,
    this.controller,
    this.value,
    this.required = false,
    this.icon,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.inputFormatters,
    this.items,
    this.textStyle,
    this.setter,
    this.onValueChanged,
    this.itemsVisibleInDropdown = 3,
    this.enabled = true,
    this.strict = true,
  }) : super(
          key: key,
          initialValue: controller?.text ?? value ?? '',
          onSaved: setter,
          builder: (FormFieldState<String> field) {
            final state = field as DropDownFieldState;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: state._effectiveController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          icon: icon,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.arrow_drop_down, size: 30.0),
                            onPressed: state.toggleDropDownVisibility,
                          ),
                          hintText: hintText,
                          labelText: labelText,
                          hintStyle: hintStyle,
                          labelStyle: labelStyle,
                          errorText: field.errorText,
                        ),
                        style: textStyle,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        validator: (String? newValue) {
                          if (required &&
                              (newValue == null || newValue.isEmpty)) {
                            return 'Este campo no puede estar vacío!';
                          }
                          if (strict &&
                              items != null &&
                              !items.contains(newValue)) {
                            return 'Valor no válido en este campo!';
                          }
                          return null;
                        },
                        enabled: enabled,
                        inputFormatters: inputFormatters,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: enabled ? state.clearValue : null,
                    )
                  ],
                ),
                state._showDropdown
                    ? Container(
                        height: itemsVisibleInDropdown * 48.0,
                        width: double.infinity,
                        child: ListView(
                          padding: EdgeInsets.only(left: 40.0),
                          children: state._getChildren(),
                        ),
                      )
                    : Container(),
              ],
            );
          },
        );

  @override
  DropDownFieldState createState() => DropDownFieldState();
}

class DropDownFieldState extends FormFieldState<String> {
  late TextEditingController _controller;
  bool _showDropdown = false;
  String _searchText = "";

  @override
  DropDownField get widget => super.widget as DropDownField;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void toggleDropDownVisibility() {
    setState(() {
      _showDropdown = !_showDropdown;
    });
  }

  void clearValue() {
    setState(() {
      _effectiveController.text = '';
      _showDropdown = false;
    });
  }

  List<ListTile> _getChildren() {
    if (widget.items == null) return [];
    return widget.items!
        .where((item) =>
            _searchText.isEmpty ||
            item.toUpperCase().contains(_searchText.toUpperCase()))
        .map((item) => ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  _effectiveController.text = item;
                  _showDropdown = false;
                  widget.onValueChanged?.call(item);
                });
              },
            ))
        .toList();
  }

  void _handleControllerChanged() {
    setState(() {
      _searchText = _effectiveController.text;
      _showDropdown = _searchText.isNotEmpty;
    });
  }
}
