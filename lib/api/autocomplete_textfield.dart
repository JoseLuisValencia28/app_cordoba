// // ignore_for_file: unused_element

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';

// typedef Widget AutoCompleteOverlayItemBuilder<T>(
//   BuildContext context,
//   T suggestion,
// );

// typedef bool Filter<T>(T suggestion, String query);

// typedef InputEventCallback<T>(T data);

// typedef StringCallback = void Function(String data);

// class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField<T>> {
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? listSuggestionsEntry;
//   List<T> filteredSuggestions = [];
//   TextEditingController? _internalController;
//   FocusNode? _internalFocusNode;

//   TextEditingController get controller =>
//       widget.controller ?? _internalController!;
//   FocusNode get focusNode => widget.focusNode ?? _internalFocusNode!;

//   @override
//   Widget build(BuildContext context) {
//     return CompositedTransformTarget(link: _layerLink, child: textField);
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Usar el controlador y focusNode proporcionados o crear nuevos
//     if (widget.controller == null) {
//       _internalController = TextEditingController();
//     }
//     if (widget.focusNode == null) {
//       _internalFocusNode = FocusNode();
//     }

//     focusNode.addListener(() {
//       widget.onFocusChanged?.call(focusNode.hasFocus);
//       if (!focusNode.hasFocus) {
//         filteredSuggestions.clear();
//         updateOverlay();
//       } else if (controller.text.isNotEmpty) {
//         updateOverlay(controller.text);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // Solo eliminar si se crearon internamente
//     _internalController?.dispose();
//     _internalFocusNode?.dispose();
//     listSuggestionsEntry?.remove();
//     super.dispose();
//   }

//   TextField get textField => TextField(
//     controller: controller,
//     focusNode: focusNode,
//     decoration: widget.decoration,
//     style: widget.style,
//     keyboardType: widget.keyboardType,
//     textInputAction: widget.textInputAction,
//     textCapitalization: widget.textCapitalization,
//     onChanged: (newText) {
//       setState(() {
//         updateOverlay(newText);
//       });
//       widget.textChanged?.call(newText);
//     },
//     onTap: () => updateOverlay(controller.text),
//     onSubmitted: (submittedText) {
//       widget.textSubmitted?.call(submittedText);
//       if (widget.clearOnSubmit) {
//         controller.clear();
//         setState(() {
//           filteredSuggestions.clear();
//           updateOverlay();
//         });
//       }
//     },
//   );

//   void updateOverlay([String query = ""]) {
//     if (listSuggestionsEntry == null) {
//       final overlay = Overlay.of(context);
//       listSuggestionsEntry = OverlayEntry(
//         builder:
//             (context) => Positioned(
//               width: MediaQuery.of(context).size.width * 0.8,
//               child: CompositedTransformFollower(
//                 link: _layerLink,
//                 showWhenUnlinked: false,
//                 offset: const Offset(0.0, 50.0),
//                 child: Material(
//                   elevation: 4.0,
//                   child: Column(
//                     children:
//                         filteredSuggestions
//                             .map(
//                               (suggestion) => ListTile(
//                                 title: widget.itemBuilder!(context, suggestion),
//                                 onTap: () {
//                                   controller.text = suggestion.toString();
//                                   focusNode.unfocus();
//                                   widget.itemSubmitted!(suggestion);
//                                   if (widget.clearOnSubmit) {
//                                     controller.clear();
//                                     filteredSuggestions.clear();
//                                     updateOverlay();
//                                   }
//                                 },
//                               ),
//                             )
//                             .toList(),
//                   ),
//                 ),
//               ),
//             ),
//       );
//       overlay.insert(listSuggestionsEntry!);
//     }

//     setState(() {
//       filteredSuggestions =
//           widget.suggestions
//               .where((item) => widget.itemFilter!(item, query))
//               .toList()
//               .take(widget.suggestionsAmount)
//               .toList();
//     });

//     listSuggestionsEntry!.markNeedsBuild();
//   }
// }

// late TextEditingController controller;
// late FocusNode focusNode;
// late LayerLink _layerLink; // Esto es necesario para CompositedTransformTarget

// @override
// void initState() {
//   // super.initState();
//   controller = TextEditingController();
//   focusNode = FocusNode();
//   _layerLink = LayerLink();
// }

// @override
// void dispose() {
//   controller.dispose();
//   focusNode.dispose();
//   // super.dispose();
// }

// class SimpleAutoCompleteTextField extends AutoCompleteTextField<String> {
//   final StringCallback? textChanged;
//   final StringCallback? textSubmitted;
//   final int minLength;
//   final ValueSetter<bool>? onFocusChanged;
//   final TextEditingController controller;
//   final FocusNode? focusNode;

//   SimpleAutoCompleteTextField({
//     TextStyle style = const TextStyle(),
//     InputDecoration decoration = const InputDecoration(),
//     this.onFocusChanged,
//     this.textChanged,
//     this.textSubmitted,
//     this.minLength = 1,
//     required this.controller,
//     this.focusNode,
//     TextInputType keyboardType = TextInputType.text,
// required GlobalKey<AutoCompleteTextFieldState<String>> key,
//     required List<String> suggestions,
//     int suggestionsAmount = 5,
//     bool submitOnSuggestionTap = true,
//     bool clearOnSubmit = true,
//     TextInputAction textInputAction = TextInputAction.done,
//     TextCapitalization textCapitalization = TextCapitalization.sentences,
//   }) : super(
//          key: key,
//          style: style,
//          decoration: decoration,
//          textChanged: textChanged,
//          textSubmitted: textSubmitted,
//          itemSubmitted: (String item) => textSubmitted?.call(item),
//          keyboardType: keyboardType,
//          suggestions: suggestions,
//          suggestionsAmount: suggestionsAmount,
//          submitOnSuggestionTap: submitOnSuggestionTap,
//          clearOnSubmit: clearOnSubmit,
//          textInputAction: textInputAction,
//          textCapitalization: textCapitalization,
//          itemBuilder:
//              (context, item) =>
//                  Padding(padding: const EdgeInsets.all(8.0), child: Text(item)),
//          itemSorter: (a, b) => a.compareTo(b),
//          itemFilter:
//              (item, query) =>
//                  item.toLowerCase().startsWith(query.toLowerCase()),
//        );
// }
