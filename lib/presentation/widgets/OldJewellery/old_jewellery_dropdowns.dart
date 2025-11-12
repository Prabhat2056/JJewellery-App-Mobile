import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jjewellery/models/item_materials_model.dart';
import 'package:jjewellery/utils/color_constant.dart';

class OldJewelleryDropdowns extends StatelessWidget {
  const OldJewelleryDropdowns(
      {super.key,
      required this.dropdownKey,
      required this.label,
      required this.items,
      required this.onChanged});
  final GlobalKey<DropdownSearchState<ItemMaterialsModel>> dropdownKey;
  final String label;
  final List items;
  final Function(ItemMaterialsModel) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownSearch<ItemMaterialsModel>(
          key: dropdownKey,
          items: (filter, _) => items as List<ItemMaterialsModel>,
          itemAsString: (item) => item.name,
          compareFn: (item1, item2) => item1.id == item2.id,
          validator: (value) => value == null ? 'Required Field' : null,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: ColorConstant.primaryColor),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          popupProps: PopupProps.dialog(
            dialogProps: DialogProps(
              backgroundColor: ColorConstant.scaffoldColor,
            ),
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: "Search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
