import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote_care/constants/colors.dart';
import 'package:remote_care/constants/radii.dart';

///DropDownField has customized autocomplete text field functionality
///
///Parameters
///
///value - dynamic - Optional value to be set into the Dropdown field by default when this field renders
///
///icon - Widget - Optional icon to be shown to the left of the Dropdown field
///
///hintText - String - Optional Hint text to be shown
///
///hintStyle - TextStyle - Optional styling for Hint text. Default is normal, gray colored font of size 18.0
///
///labelText - String - Optional Label text to be shown
///
///labelStyle - TextStyle - Optional styling for Label text. Default is normal, gray colored font of size 18.0
///
///required - bool - True will validate that this field has a non-null/non-empty value. Default is false
///
///enabled - bool - False will disable the field. You can unset this to use the Dropdown field as a read only form field. Default is true
///
///items - List<dynamic> - List of items to be shown as suggestions in the Dropdown. Typically a list of String values.
///You can supply a static list of values or pass in a dynamic list using a FutureBuilder
///
///textStyle - TextStyle - Optional styling for text shown in the Dropdown. Default is bold, black colored font of size 14.0
///
///inputFormatters - List<TextInputFormatter> - Optional list of TextInputFormatter to format the text field
///
///setter - FormFieldSetter<dynamic> - Optional implementation of your setter method. Will be called internally by Form.save() method
///
///onValueChanged - ValueChanged<dynamic> - Optional implementation of code that needs to be executed when the value in the Dropdown
///field is changed
///
///strict - bool - True will validate if the value in this dropdown is amongst those suggestions listed.
///False will let user type in new values as well. Default is true
///
///itemsVisibleInDropdown - int - Number of suggestions to be shown by default in the Dropdown after which the list scrolls. Defaults to 3
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}

class DropDownFieldCustom extends FormField<String> {
  final dynamic value;
  final BuildContext context;
  final Widget icon;
  final String hintText;
  final TextStyle hintStyle;
  final String labelText;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final bool required;
  final bool enabled;
  final List<dynamic> items;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldSetter<dynamic> setter;
  final ValueChanged<dynamic> onValueChanged;
  final bool strict;
  //final Widget suffixIcon;
  final int itemsVisibleInDropdown;
  final FormFieldSetter<String> onValidate;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController controller;

  DropDownFieldCustom(
      {Key key,
        this.context,
        this.controller,
        this.onValidate,
        this.value,
        this.required: false,
        this.icon,
        this.hintText,
        this.hintStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
        this.labelText,
        this.labelStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 18.0),
        this.inputFormatters,
        this.items,
        this.textStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14.0),
        this.setter,
        this.onValueChanged,
        this.itemsVisibleInDropdown: 7,
        this.enabled: true,
        this.strict: true,
        //this.suffixIcon
      })
      : super(
    key: key,
    autovalidate: false,
    initialValue: controller != null ? controller.text : (value ?? ''),
    onSaved: setter,
    builder: (FormFieldState<String> field) {
      final DropDownFieldState state = field;
      final ScrollController _scrollController = ScrollController();
      final InputDecoration effectiveDecoration = InputDecoration(
          border: InputBorder.none,
          filled: true,
          icon: icon,
          fillColor: AppColors.primaryBackground,
          //fillColor: AppColors.homeScreenBackground,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius:Radii.k4pxRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius:Radii.k4pxRadius,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: Radii.k4pxRadius,
          ),
          suffixIcon: IconButton(
              icon: Icon(Icons.arrow_drop_down,
                  size: 30.0, color: Colors.black),
              onPressed: () {
                controller.clear();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                state.setState(() {
                  state._showdropdown = !state._showdropdown;
                  //Focus.of(state.context).unfocus();
                });
              }),
          hintStyle: hintStyle,
          labelStyle: labelStyle,
          hintText: hintText,
          labelText: labelText);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  onEditingComplete: () => Focus.of(context).unfocus(),
                  autovalidate: false,
                  //focusNode: FirstDisabledFocusNode(),
                  controller: state._effectiveController,
                  decoration: effectiveDecoration.copyWith(
                      errorText: field.errorText),
                  style: textStyle,
                  textAlign: TextAlign.start,
                  autofocus: false,
                  obscureText: false,
                  maxLengthEnforced: true,
                  maxLines: 1,
                  validator: onValidate,
                  onChanged: setter,
                  enabled: enabled,
                  inputFormatters: inputFormatters,
                ),
              ),
            ],
          ),
          !state._showdropdown
              ? Container()
              : Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Card(
                  color: AppColors.white,
                  child: Container(
                    //padding: EdgeInsets.only(bottom: MediaQuery.of(state.context).viewInsets.bottom),
            alignment: Alignment.topCenter,
            height: state._getChildren(state._items).length > itemsVisibleInDropdown ? itemsVisibleInDropdown * 40.0 : state._getChildren(state._items).length * 40.0, //limit to default 3 items in dropdownlist view and then remaining scrolls
            width: MediaQuery.of(field.context).size.width,
            child: ListView(
                  //cacheExtent: 0.0,
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  //padding: EdgeInsets.only(left: 40.0),
                  children: items.isNotEmpty
                      ?state._getChildren(state._items)
                      .toList()
                      : List(),
            ),
          ),
                ),
              ),
        ],
      );
    },
  );

  @override
  DropDownFieldState createState() => DropDownFieldState();
}

class DropDownFieldState extends FormFieldState<String> {
  TextEditingController _controller;
  bool _showdropdown = false;
  bool _isSearching = true;
  String _searchText = "";

  @override
  DropDownFieldCustom get widget => super.widget;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  List<String> get _items => widget.items;

  void toggleDropDownVisibility() {}

  void clearValue() {
    setState(() {
      _effectiveController.text = '';
    });
  }

  @override
  void didUpdateWidget(DropDownFieldCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    }

    _effectiveController.addListener(_handleControllerChanged);

    _searchText = _effectiveController.text;
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  List<Widget> _getChildren(List<String> items) {
    List<Widget> childItems = List();
    for (var item in items) {
      if (_searchText.isNotEmpty) {
        if (item.toUpperCase().contains(_searchText.toUpperCase()))
          childItems.add(_getListTile(item));
      } else {
        childItems.add(_getListTile(item));
      }
    }
    _isSearching ? childItems : List();
    return childItems;
  }

  Widget _getListTile(String text) {
    return Container(
      height: 40,
      child: ListTile(
        dense: true,
        title: Text(
          text,
          style: widget.textStyle,
        ),
        onTap: () {
          setState(() {
            _effectiveController.text = text;
            _handleControllerChanged();
            _showdropdown = false;
            _isSearching = false;
            if (widget.onValueChanged != null) widget.onValueChanged(text);
          });
        },
      ),
    );
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);

    if (_effectiveController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchText = "";
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchText = _effectiveController.text;
        _showdropdown = true;
      });
    }
  }
}