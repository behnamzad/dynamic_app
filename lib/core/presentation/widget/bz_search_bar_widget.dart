import 'package:dynamic_app/core/util/common_ui_imports.dart';

class BzSearchBarWidget extends StatefulWidget {
  final String hint;
  final bool isEditMode;
  final bool searchBoxAutoFocus;
  final TextEditingController searchCtrl;
  final VoidCallback onSearchClick;
  final VoidCallback? onBackClick;
  final ValueChanged<String>? onQueryChanged;

  const BzSearchBarWidget({
    super.key,
    required this.hint,
    required this.isEditMode,
    required this.searchCtrl,
    required this.onSearchClick,
    this.onQueryChanged,
    this.onBackClick,
    this.searchBoxAutoFocus = false,
  });

  @override
  State<BzSearchBarWidget> createState() => _BzSearchBarWidgetState();
}

class _BzSearchBarWidgetState extends State<BzSearchBarWidget> {
  final ValueNotifier<bool> isEditMode = ValueNotifier(false);
  final ValueNotifier<bool> autoFocus = ValueNotifier(true);
  var searchFocusNode = FocusNode();

  @override
  void initState() {
    isEditMode.value = widget.isEditMode;
    autoFocus.value = widget.searchBoxAutoFocus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: autoFocus,
        builder: (context, bool hasAutoFocus, child) {
          return ValueListenableBuilder(
            valueListenable: isEditMode,
            builder: (context, bool isEdit, child) {
              return Container(
                color: isEdit ? context.scheme().mainBackground1 : context.scheme().mainBackground2,
                height: Dimen.searchBarHeight,
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          widget.onBackClick != null ? widget.onBackClick!() : Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          width: Dimen.appBarHeight,
                          height: Dimen.appBarHeight,
                          child: Icon(Icons.arrow_back_sharp, color: context.scheme().titleText),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: isEdit
                                ? Container(
                                    margin: const EdgeInsets.only(left: 56, top: 9),
                                    child: BzText(
                                      widget.hint,
                                      style: context.title1Bold.copyWith(color: context.scheme().titleText),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : BzTextField.borderLess(
                                    hint: widget.hint,
                                    textEditingController: widget.searchCtrl,
                                    hintColor: context.scheme().subText,
                                    padding: const EdgeInsets.only(top: 24, left: 16, bottom: 16),
                                    onChanged: widget.onQueryChanged,
                                    textHeight: 1,
                                    autoFocus: hasAutoFocus,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    focusNode: searchFocusNode,
                                  ),
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: widget.searchCtrl,
                            builder: (context, searchedValue, child) {
                              return Visibility(
                                visible: searchedValue.text.isNotEmpty,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      widget.onSearchClick();
                                      searchFocusNode.unfocus();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                      child: Icon(Icons.search, size: 24, color: context.scheme().titleText),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
