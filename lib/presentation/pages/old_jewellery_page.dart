import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/models/item_materials_model.dart';
import 'package:jjewellery/models/old_jewellery_model.dart';
import 'package:jjewellery/presentation/widgets/Global/appbar.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_buttons.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';
import 'package:jjewellery/presentation/widgets/Global/form_field_column.dart';
import 'package:jjewellery/presentation/widgets/OldJewellery/old_jewellery_dropdowns.dart';
import 'package:jjewellery/presentation/widgets/OldJewellery/old_jewellery_table.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/OldJewellery/old_jewellery_bloc.dart';
import '../../data/query/get_items.dart';
import '../../utils/color_constant.dart';
import '../widgets/home/unit_conversion_field.dart';

class OldJewelleryPage extends StatefulWidget {
  const OldJewelleryPage({super.key});

  @override
  State<OldJewelleryPage> createState() => _OldJewelleryPageState();
}

class _OldJewelleryPageState extends State<OldJewelleryPage> {
  TextEditingController qtyTolaController = TextEditingController();
  TextEditingController qtyLalController = TextEditingController();
  TextEditingController qtyGramController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  TextEditingController wasteTolaController = TextEditingController();
  TextEditingController wasteLalController = TextEditingController();
  TextEditingController wasteGramController = TextEditingController();
  late List items;
  late List materials;

  final itemDropDownKey = GlobalKey<DropdownSearchState<ItemMaterialsModel>>();
  final materialDropDownKey =
      GlobalKey<DropdownSearchState<ItemMaterialsModel>>();
  final formKey = GlobalKey<FormState>();
  int itemId = 0;
  String itemName = '';
  int materialId = 0;
  String material = '';
  var uuid = Uuid();
  void onQtyGramChange(String value) {
    if (value.isEmpty || value == "0.000") {
      setState(() {
        qtyGramController.clear();
        qtyLalController.clear();
        qtyTolaController.clear();
      });
      return;
    }

    double convertedValue = double.parse(value) / 11.664;
    double tola = convertedValue.floorToDouble();
    double lal = (convertedValue - tola) * 100;

    setState(() {
      qtyTolaController.text = tola.toStringAsFixed(3);
      qtyLalController.text = lal.toStringAsFixed(3);
    });
  }

  void onQtyTolaChange(String value) {
    if (value.isEmpty || value == "0.000") {
      if (qtyLalController.text.isEmpty || qtyLalController.text == "0.000") {
        setState(() {
          qtyGramController.clear();
          qtyLalController.clear();
          qtyTolaController.clear();
        });
        return;
      }
      value = "0.0";
    }
    double tola = double.tryParse(value) ?? 0.0;
    double lal = double.tryParse(qtyLalController.text) ?? 0.0;
    tola += lal * 0.01;
    setState(() {
      qtyGramController.text = (tola * 11.664).toStringAsFixed(3);
    });
  }

  void onQtyLalChange(String value) {
    if (value.isEmpty || value == "0.000") {
      if (qtyTolaController.text.isEmpty || qtyTolaController.text == "0.000") {
        setState(() {
          qtyGramController.clear();
          qtyLalController.clear();
          qtyTolaController.clear();
        });
        return;
      }
      value = "0.0";
    }

    double lal = double.tryParse(value) ?? 0.0;
    double tola = double.tryParse(qtyTolaController.text) ?? 0.0;
    tola += lal * 0.01;

    setState(() {
      qtyGramController.text = (tola * 11.664).toStringAsFixed(3);
    });
  }

  void onWasteGramChange(String value) {
    if (value.isEmpty || value == "0.000") {
      setState(() {
        wasteGramController.clear();
        wasteLalController.clear();
        wasteTolaController.clear();
      });
      return;
    }

    double convertedValue = double.parse(value) / 11.664;
    double tola = convertedValue.floorToDouble();
    double lal = (convertedValue - tola) * 100;

    setState(() {
      wasteTolaController.text = tola.toStringAsFixed(3);
      wasteLalController.text = lal.toStringAsFixed(3);
    });
  }

  void onWasteTolaChange(String value) {
    if (value.isEmpty || value == "0.000") {
      if (wasteLalController.text.isEmpty ||
          wasteLalController.text == "0.000") {
        setState(() {
          wasteGramController.clear();
          wasteLalController.clear();
          wasteTolaController.clear();
        });
        return;
      }
      value = "0.0";
    }
    double tola = double.tryParse(value) ?? 0.0;
    double lal = double.tryParse(wasteLalController.text) ?? 0.0;
    tola += lal * 0.01;
    setState(() {
      wasteGramController.text = (tola * 11.664).toStringAsFixed(3);
    });
  }

  void onWasteLalChange(String value) {
    if (value.isEmpty || value == "0.000") {
      if (wasteTolaController.text.isEmpty ||
          wasteTolaController.text == "0.000") {
        setState(() {
          wasteGramController.clear();
          wasteLalController.clear();
          wasteTolaController.clear();
        });
        return;
      }
      value = "0.0";
    }

    double lal = double.tryParse(value) ?? 0.0;
    double tola = double.tryParse(wasteTolaController.text) ?? 0.0;
    tola += lal * 0.01;

    setState(() {
      wasteGramController.text = (tola * 11.664).toStringAsFixed(3);
    });
  }

  loadData() async {
    items = ItemsMaterialsDataRepository().items;
    materials = ItemsMaterialsDataRepository().materials;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppbar(isHomeWidget: false, title: "Old Jewellery"),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 190,
                  child: BlocBuilder<OldJewelleryBloc, OldJewelleryState>(
                    buildWhen: (previous, current) =>
                        previous.oldJewelleryList != current.oldJewelleryList,
                    builder: (context, state) {
                      return OldJewelleryTable(
                        items: state.oldJewelleryList,
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: OldJewelleryDropdowns(
                                  dropdownKey: itemDropDownKey,
                                  label: "Item :",
                                  items: items,
                                  onChanged: (i) {
                                    itemId = i.id;
                                    itemName = i.name;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: OldJewelleryDropdowns(
                                  dropdownKey: materialDropDownKey,
                                  label: "Material :",
                                  items: materials,
                                  onChanged: (i) {
                                    materialId = i.id;
                                    material = i.name;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          formFieldColumn(
                              label: "Rate (In Tola)",
                              isNumber: true,
                              controller: rateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required Field";
                                }
                              }),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Item Quantity :",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      unitConversionField(
                                        title: "Gram",
                                        controller: qtyGramController,
                                        onChanged: (v) => onQtyGramChange(v),
                                        color: Colors.black,
                                      ),
                                      Icon(
                                        Icons.swap_horiz,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      unitConversionField(
                                        title: "Tola",
                                        controller: qtyTolaController,
                                        onChanged: (v) => onQtyTolaChange(v),
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 10),
                                      unitConversionField(
                                        title: "Lal",
                                        controller: qtyLalController,
                                        onChanged: (v) => onQtyLalChange(v),
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Waste Deduction :",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      unitConversionField(
                                        title: "Gram",
                                        controller: wasteGramController,
                                        onChanged: (v) => onWasteGramChange(v),
                                        color: Colors.black,
                                      ),
                                      Icon(
                                        Icons.swap_horiz,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      unitConversionField(
                                        title: "Tola",
                                        controller: wasteTolaController,
                                        onChanged: (v) => onWasteTolaChange(v),
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 10),
                                      unitConversionField(
                                        title: "Lal",
                                        controller: wasteLalController,
                                        onChanged: (v) => onWasteLalChange(v),
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        ]),
                  ),
                ),
                customElevatedButton(
                    title: "Add",
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      if (qtyGramController.text.isEmpty) {
                        customToast("Item Quantity Required ",
                            ColorConstant.errorColor);
                        return;
                      }

                      OldJewelleryModel oldJewelleryModel = OldJewelleryModel(
                        id: Uuid().v4(),
                        itemId: itemId,
                        item: itemName,
                        materialId: materialId,
                        material: material,
                        rate: double.parse(rateController.text),
                        qtyGram: double.parse(qtyGramController.text),
                        wasteGram: wasteGramController.text.isEmpty
                            ? 0.0
                            : double.parse(wasteGramController.text),
                        finalQty: wasteGramController.text.isEmpty
                            ? double.parse(qtyGramController.text)
                            : (double.parse(qtyGramController.text) -
                                double.parse(wasteGramController.text)),
                      );

                      BlocProvider.of<OldJewelleryBloc>(context).add(
                          OldJewelleryAddEvent(
                              oldJewelleryModel: oldJewelleryModel));

                      rateController.clear();
                      qtyGramController.clear();
                      qtyLalController.clear();
                      qtyTolaController.clear();
                      wasteGramController.clear();
                      wasteLalController.clear();
                      wasteTolaController.clear();

                      itemDropDownKey.currentState?.clear();
                      materialDropDownKey.currentState?.clear();
                      itemId = 0;
                      itemName = '';
                      materialId = 0;
                      material = '';
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
