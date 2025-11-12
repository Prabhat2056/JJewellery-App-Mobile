import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/QrResult/qr_result_bloc.dart';
import 'package:jjewellery/data/query/get_items.dart';
import 'package:jjewellery/helper/helper_functions.dart';
import 'package:jjewellery/models/qr_data_model.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';

import '../../../models/item_materials_model.dart';
import '../../../utils/color_constant.dart';

class ShowItemPicker extends StatefulWidget {
  const ShowItemPicker({
    super.key,
    required this.qrDataModel,
  });

  final QrDataModel qrDataModel;

  @override
  State<ShowItemPicker> createState() => _ShowItemPickerState();
}

class _ShowItemPickerState extends State<ShowItemPicker> {
  List<ItemMaterialsModel> listOfItems = [];
  List<ItemMaterialsModel> selectedItems = [];

  TextEditingController searchController = TextEditingController();

  Future<void> loadItemsFromDb() async {
    // var bloc = BlocProvider.of<JewelleryOrderBloc>(context);
    var nav = Navigator.of(context);
    selectedItems = listOfItems = ItemsMaterialsDataRepository().items;
    if (listOfItems.isEmpty) {
      if (await checkInternetConnection()) {
        // bloc.add(ItemMaterialsLoadEvent());
        bool res = await ItemsMaterialsDataRepository().initialize();

        //mounted fixed the bug of crash and didnt let the custom toast to appear
        if (mounted) {
          if (res == false) {
            nav.pop();
            customToast("Error in loading data", ColorConstant.errorColor);
            return;
          }
        }
        selectedItems = listOfItems = ItemsMaterialsDataRepository().items;
      } else {
        nav.pop();
        customToast("No Internet Connection", ColorConstant.errorColor);
      }
    }
    if (listOfItems.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadItemsFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(children: [
          TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstant.primaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12,
                    ),
                  ),
                ),
              ),
              onChanged: (_) {
                setState(() {
                  if (selectedItems.isEmpty) {
                    selectedItems = listOfItems;
                  }
                  selectedItems = listOfItems
                      .where((i) => i.name
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList();
                });
              }),
          Positioned(
            right: 10,
            top: 15,
            child: Icon(
              Icons.search,
              color: ColorConstant.primaryColor,
            ),
          )
        ]),
        listOfItems.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      // widget.qrDataModel.itemId = selectedItems[index].id;
                      widget.qrDataModel.item = selectedItems[index].name;
                      BlocProvider.of<QrResultBloc>(context)
                          .add(QrResultItemChangedEvent(
                        qrData: widget.qrDataModel,
                      ));
                      Navigator.of(context).pop();
                    },
                    child: ListTile(
                      title: Text(
                        selectedItems[index].name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  itemCount: selectedItems.length,
                ),
              )
            : Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ]),
    );
  }
}
