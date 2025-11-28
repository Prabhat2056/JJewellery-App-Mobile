import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/data/query/get_items.dart';

import 'package:jjewellery/helper/helper_handle_token.dart';
import 'package:jjewellery/models/item_materials_model.dart';
import 'package:jjewellery/models/qr_data_model.dart';

import 'package:jjewellery/presentation/pages/bill_page.dart';
import 'package:jjewellery/presentation/pages/login_page.dart';
import 'package:jjewellery/presentation/pages/luxury.dart';

import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';
import 'package:jjewellery/presentation/widgets/Global/refresh_indicator.dart';
import 'package:jjewellery/presentation/widgets/QrResult/expected_amount.dart';


import 'package:jjewellery/presentation/widgets/QrResult/qr_result_header.dart';
import 'package:jjewellery/presentation/widgets/QrResult/qr_result_stone_table.dart';

import 'package:jjewellery/presentation/widgets/QrResult/row_with_textfield.dart';
import 'package:jjewellery/presentation/widgets/QrResult/show_item_picker.dart';
import 'package:jjewellery/utils/color_constant.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/Order/jewellery_order_bloc.dart';
import '../../bloc/QrResult/qr_result_bloc.dart';
import '../../endpoints.dart';
import '../../helper/helper_functions.dart';
import '../../main_common.dart';

import '../widgets/QrResult/add_to_cart_card.dart';
import '../widgets/QrResult/discount_card.dart';
import '../widgets/QrResult/karat_price_header.dart';

class QrResult extends StatefulWidget {
  const QrResult({
    super.key,
  });

  @override
  State<QrResult> createState() => _QrResultState();
}

class _QrResultState extends State<QrResult> {
  late bool showCalculation;
  late QrDataModel originalQrDataModel;
   bool lockedToCalculatedJyala = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController itemController = TextEditingController();
  TextEditingController jartiPercentageController = TextEditingController();
  TextEditingController jartiGramController = TextEditingController();
  TextEditingController jartiLalController = TextEditingController();
  TextEditingController jyalaController = TextEditingController();
  TextEditingController jyalaPercentageController = TextEditingController();
  TextEditingController netWeightController = TextEditingController();
  TextEditingController grossWeightController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  TextEditingController stone1NameController = TextEditingController();
  TextEditingController stone2NameController = TextEditingController();
  TextEditingController stone3NameController = TextEditingController();

  TextEditingController stone1WeightController = TextEditingController();
  TextEditingController stone2WeightController = TextEditingController();
  TextEditingController stone3WeightController = TextEditingController();

  TextEditingController stone1PriceController = TextEditingController();
  TextEditingController stone2PriceController = TextEditingController();
  TextEditingController stone3PriceController = TextEditingController();
  TextEditingController expectedAmountController = TextEditingController();
 

  TextEditingController newjartiPercentageController = TextEditingController();
  TextEditingController newjartiGramController = TextEditingController();
  TextEditingController newjartiLalController = TextEditingController();
  TextEditingController newjartiAmountController = TextEditingController();
  TextEditingController newjyalaController = TextEditingController();
  TextEditingController newjyalaPercentageController = TextEditingController();
  TextEditingController newstone1PriceController = TextEditingController();
  TextEditingController newstone2PriceController = TextEditingController();
  TextEditingController newstone3PriceController = TextEditingController();


  late QrDataModel originalQrData;
  @override
  void initState() {
    super.initState();
    showCalculation = prefs.getBool("ShowCalculation") ?? true;



  }

   // 🔵 UPDATE JYALA CONTROLLER BASED ON newJyala OR jyala
  void updateJyalaController(QrDataModel data) {
    // ignore: unnecessary_null_comparison
    final displayValue = (data.newJyala != null && data.newJyala.isNotEmpty)
        ? data.newJyala
        : data.jyala;

    jyalaController.text = displayValue;
  }

  int findValidId(
      {required String name,
      required List listOfItems,
      required String errorMessage}) {
    if (name.isEmpty) {
      return 0;
    }

    var items = listOfItems.firstWhere(
        (i) => i.name.toLowerCase() == name.toLowerCase(),
        orElse: () => ItemMaterialsModel(name: name, id: 0));

    if (items.id == 0) {
      customToast(errorMessage, ColorConstant.errorColor);
      return 0;
    }
    return items.id;
  }

  Future findValidItemId({required String code}) async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(
        "${Endpoints.baseUrl}PurchaseBillItems/Get",
        queryParameters: {'code': code},
      );

      if (response.data.isNotEmpty) {
        return response.data;
      } else {
        customToast("No Such Item Found", ColorConstant.errorColor);
        return {'itemId': 0, 'materialId': 0, 'pcs': 0};
      }
    } catch (e) {
      customToast("No Such Item Found", ColorConstant.errorColor);
      return {'itemId': 0, 'materialId': 0, 'pcs': 0};
    }
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.18;

    return BlocConsumer<QrResultBloc, QrResultState>(
        listener: (context, state) {
          //when price, expected amount discount changes, update controllers
          if ( state is QrResultPriceChangedState||
              state is QrResultExpectedAmountDiscountChangedState ||
              state is QrResultTotalChangedState
              || state is QrResultInitialState || state is QrResultJyalaChangedEvent|| state is QrResultJyalaPercentageChangedEvent

              ) {
                print("🟢 Updating controllers - jyala: ${state.qrData.jyala}, jyalaPercentage: ${state.qrData.jyalaPercentage}");
            jartiPercentageController.text = state.qrData.jartiPercentage;
            jartiGramController.text = state.qrData.jarti;
            jartiLalController.text = state.qrData.jartiLal;
            jyalaPercentageController.text = state.qrData.jyalaPercentage;
            jyalaController.text = state.qrData.jyala;
            rateController.text = state.qrData.rate;
            itemController.text = state.qrData.item;

             // For jyala fields: Show discount-calculated values OR manual values
    if (state is QrResultExpectedAmountDiscountChangedState) {
      // When discount is calculated, show new calculated values
      jyalaPercentageController.text = state.qrData.newJyalaPercentage.isNotEmpty 
          ? state.qrData.newJyalaPercentage 
          : state.qrData.jyalaPercentage;
      jyalaController.text = state.qrData.newJyala.isNotEmpty 
          ? state.qrData.newJyala 
          : state.qrData.jyala;
    } else {
      // For manual edits, show the original fields
      jyalaPercentageController.text = state.qrData.jyalaPercentage;
      jyalaController.text = state.qrData.jyala;
    }

          }
        },

        
      buildWhen: (previous,
                current) => //updates UI when changes in these states occur
            current is QrResultInitialState ||
            current is QrResultExpectedAmountChangedState||
            current is QrResultExpectedAmountDiscountChangedState || 
            current is QrResultJyalaChangedEvent|| 
            current is QrResultJyalaPercentageChangedEvent||
            current is QrResultTotalChangedState,
            //current is QrResultResetToOriginalState,
      builder: (context, state) {
          if (state is QrResultInitialState) {
            originalQrData = state.originalQrData;

            //}
            // Update controllers for both initial and discount changed states
            itemController.text = state.qrData.item;
            grossWeightController.text = state.qrData.grossWeight;
            netWeightController.text = state.qrData.netWeight;
            rateController.text = state.qrData.rate;
            //jyalaController.text = state.qrData.jyala;

            // 🔴 CRITICAL FIX: Update jyalaController based on newJyala
    final displayJyala = (state.qrData.newJyala.isNotEmpty && 
                         state.qrData.newJyala != "0.000")
        ? state.qrData.newJyala
        : state.qrData.jyala; 
    jyalaController.text = displayJyala;

    final displayJyalaPercentage = (state.qrData.newJyalaPercentage.isNotEmpty && 
                         state.qrData.newJyalaPercentage != "0.000")
        ? state.qrData.newJyalaPercentage
        : state.qrData.jyalaPercentage;
    jyalaPercentageController.text = displayJyalaPercentage;

            jartiPercentageController.text = state.qrData.jartiPercentage;
            jartiGramController.text = state.qrData.jarti;
            jartiLalController.text = state.qrData.jartiLal;
            //jyalaPercentageController.text = state.qrData.jyalaPercentage;
            stone1NameController.text = state.qrData.stone1Name;
            stone2NameController.text = state.qrData.stone2Name;
            stone3NameController.text = state.qrData.stone3Name;
            stone1WeightController.text = state.qrData.stone1Weight;
            stone2WeightController.text = state.qrData.stone2Weight;
            stone3WeightController.text = state.qrData.stone3Weight;
            stone1PriceController.text = state.qrData.stone1Price;
            stone2PriceController.text = state.qrData.stone2Price;
            stone3PriceController.text = state.qrData.stone3Price;
            expectedAmountController.text = state.qrData.expectedAmount;
//  if (state is QrResultExpectedAmountDiscountChangedState) {
//    // 🔴 CRITICAL FIX: Update jyalaController when discount is calculated
//     final displayJyala = (state.qrData.newJyala.isNotEmpty && 
//                          state.qrData.newJyala != "0.000")
//         ? state.qrData.newJyala
//         : state.qrData.jyala;
//     jyalaController.text = displayJyala;

//     final displayJyalaPercentage = (state.qrData.newJyalaPercentage.isNotEmpty && 
//                          state.qrData.newJyalaPercentage != "0.000")
//         ? state.qrData.newJyalaPercentage
//         : state.qrData.jyalaPercentage;
//     jyalaPercentageController.text = displayJyalaPercentage;
//             //Initialize new calculated fields controllers with values for UI display
//             // newjyalaController.text= state.qrData.newJyala ;
//             // newjyalaPercentageController.text= state.qrData.newJyalaPercentage;
//             // newjartiGramController.text= state.qrData.newJarti;
//             // newjartiPercentageController.text = state.qrData.newJartiPercentage;
//             // newjartiLalController.text= state.qrData.newJartiLal;
//             // newstone1PriceController.text= state.qrData.newStone1Price;
//             // newstone2PriceController.text= state.qrData.newStone2Price;
//             // newstone3PriceController.text= state.qrData.newStone3Price;
//  }
            

            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12),
                        child: Column(
                          children: [
                            state.qrData.code.isEmpty
                                ? KaratPriceHeader(onKaratPricePressed: (rate) {
                                    state.qrData.rate = rate;
                                    BlocProvider.of<QrResultBloc>(context).add(
                                      QrResultRateChangedEvent(
                                          qrData: state.qrData),
                                    );
                                  })
                                : qrResultHeader(
                                    showCalculation: showCalculation,
                                    item: state.qrData.item,
                                    code: state.qrData.code,
                                    mrp: state.qrData.mrp,
                                    todayRate: state.qrData.todayRate,
                                    metal: state.qrData.metal,
                                    purity: state.qrData.purity,
                                    width: width / 0.18,
                                  ),
                            state.qrData.code.isEmpty
                                ? const SizedBox.shrink()
                                : const Divider(),
                            Form(
                              key: _formKey,
                              child: Column(children: [
                                showCalculation || state.qrData.code.isEmpty
                                    ? Column(children: [
                                        GestureDetector(
                                          onTap: () => showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              backgroundColor:
                                                  ColorConstant.scaffoldColor,
                                              content: ShowItemPicker(
                                                qrDataModel: state.qrData,
                                              ),
                                            ),
                                          ),
                                          child: rowWithTextField(
                                            controller: itemController,
                                            isEnabled: false,
                                            title: "Item",
                                            width: width,
                                            isUnitLeading: false,
                                            isNumberField: false,
                                            validator: (value) => value!.isEmpty
                                                ? 'Please enter item name'
                                                : null,
                                          ),
                                        ),
                                        (width / 0.18) > 410
                                            ? Row(children: [
                                                Expanded(
                                                  child: rowWithTextField(
                                                      controller:
                                                          netWeightController,
                                                      onChanged: (value) {
                                                        state.qrData.netWeight =
                                                            value;
                                                        BlocProvider.of<
                                                                    QrResultBloc>(
                                                                context)
                                                            .add(QrResultNetWeightChangedEvent(
                                                                qrData: state
                                                                    .qrData));
                                                      },
                                                      title: "Net wt",
                                                      unit: "g",
                                                      width: width,
                                                      isUnitLeading: false,
                                                      isNumberField: true,
                                                      validator: (value) => value!
                                                                  .isEmpty ||
                                                              value == "0"
                                                          ? 'Please enter net weight'
                                                          : null),
                                                ),
                                                const SizedBox(width: 50),
                                                Expanded(
                                                  child: rowWithTextField(
                                                      controller:
                                                          grossWeightController,
                                                      onChanged: (value) {
                                                        state.qrData
                                                                .grossWeight =
                                                            value;
                                                      },
                                                      title: "Gross wt",
                                                      unit: "g",
                                                      width: width,
                                                      isUnitLeading: false,
                                                      isNumberField: true,
                                                      validator: (value) => value!
                                                                  .isEmpty ||
                                                              value == "0"
                                                          ? 'Please enter gross weight'
                                                          : null),
                                                ),
                                              ])
                                            : Column(children: [
                                                rowWithTextField(
                                                    controller:
                                                        grossWeightController,
                                                    onChanged: (value) {
                                                      state.qrData.grossWeight =
                                                          value;
                                                    },
                                                    title: "Gross wt",
                                                    unit: "g",
                                                    width: width,
                                                    isUnitLeading: false,
                                                    isNumberField: true,
                                                    validator: (value) => value!
                                                                .isEmpty ||
                                                            value == "0"
                                                        ? 'Please enter gross weight'
                                                        : null),
                                                rowWithTextField(
                                                    controller:
                                                        netWeightController,
                                                    onChanged: (value) {
                                                      state.qrData.netWeight =
                                                          value;
                                                      BlocProvider.of<
                                                                  QrResultBloc>(
                                                              context)
                                                          .add(
                                                              QrResultNetWeightChangedEvent(
                                                                  qrData: state
                                                                      .qrData));
                                                    },
                                                    title: "Net wt",
                                                    unit: "g",
                                                    width: width,
                                                    isUnitLeading: false,
                                                    isNumberField: true,
                                                    validator: (value) => value!
                                                                .isEmpty ||
                                                            value == "0"
                                                        ? 'Please enter net weight'
                                                        : null),
                                              ]),
                                        rowWithTextField(
                                            controller: rateController,
                                            onChanged: (value) {
                                              state.qrData.rate = value;
                                              BlocProvider.of<QrResultBloc>(
                                                      context)
                                                  .add(QrResultRateChangedEvent(
                                                      qrData: state.qrData));
                                            },
                                            title: "Rate per tola",
                                            unit: "Rs",
                                            width: width,
                                            isUnitLeading: true,
                                            isNumberField: true,
                                            validator: (value) => value == "" ||
                                                    value == "0.0" ||
                                                    value == "0" ||
                                                    value == "0.00" ||
                                                    value == null
                                                ? 'Please enter rate'
                                                : null),
                                        rowWithTwoTextField(
                                          controller1:
                                              jartiPercentageController,
                                          controller2: jartiGramController,
                                          isJartiField: true,
                                          jartiLalController:
                                              jartiLalController,
                                          jartiLalOnChanged: (value) {
                                            state.qrData.jartiLal = value;
                                            BlocProvider.of<QrResultBloc>(
                                                    context)
                                                .add(
                                                    QrResultJartiLalChangedEvent(
                                                        qrData: state.qrData));
                                          },
                                          onChanged1: (value) {
                                            state.qrData.jartiPercentage =
                                                value;
                                            BlocProvider.of<QrResultBloc>(
                                                    context)
                                                .add(
                                                    QrResultJartiPercentageChangedEvent(
                                                        qrData: state.qrData));
                                          },
                                          onChanged2: (value) {
                                            state.qrData.jarti = value;
                                            BlocProvider.of<QrResultBloc>(
                                                    context)
                                                .add(
                                              QrResultJartiGramChangedEvent(
                                                  qrData: state.qrData),
                                            );
                                          },
                                          title: "Jarti",
                                          unit1: "%",
                                          unit2: "g",
                                          width: width * 6,
                                          isUnitLeading: false,
                                        ),
                                        rowWithTwoTextField(
                                            controller1:
                                                jyalaPercentageController,
                                            controller2: jyalaController,
                                            onChanged1: (value) {
                                               print("🟢 Manual jyalaPercentage change: $value");
                                                // When user manually edits percentage, clear discount calculations
    state.qrData.newJyala = "";
    state.qrData.newJyalaPercentage = "";

                                              if (state.qrData.newJyalaPercentage.isEmpty || state.qrData.newJyalaPercentage == "0.000") {
                                                state.qrData.jyalaPercentage =
                                                  value;
                                              BlocProvider.of<QrResultBloc>(
                                                      context)
                                                  .add(
                                                      QrResultJyalaPercentageChangedEvent(
                                                          qrData:
                                                              state.qrData));

                                              } 
                                            },
                                            onChanged2: (value) {
                                               
                                              
                                              // state.qrData.jyala = value;
                                              // BlocProvider.of<QrResultBloc>(
                                              //         context)
                                              //     .add(
                                              //         QrResultJyalaChangedEvent(
                                              //             qrData:
                                              //                 state.qrData));
                                              // Only update if we're not showing newJyala (user manually editing)

                                              print("🟢 Manual jyala change: $value");
                                              // Clear any calculated newJyala values when user manually edits
    state.qrData.newJyala = "";
    state.qrData.newJyalaPercentage = "";
                  
                                              if (state.qrData.newJyala.isEmpty || state.qrData.newJyala == "0.000") {
                                                state.qrData.jyala = value;
                                              
                                                BlocProvider.of<QrResultBloc>(context)
                                                  .add(QrResultJyalaChangedEvent(qrData: state.qrData));
                                              }
                                            },
                                            title: "Jyala",
                                            unit1: "%",
                                            unit2: "Rs",
                                            width: width * 6,
                                            isUnitLeading: true),
                                        const Divider(),
                                      ])
                                    : const SizedBox.shrink(),
                                !showCalculation && state.qrData.code.isNotEmpty
                                    ? Text(
                                        "MRP : ${state.qrData.mrp}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                state.qrData.code.isEmpty
                                    ? const SizedBox.shrink()
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showCalculation = !showCalculation;
                                          });
                                        },
                                        icon: showCalculation
                                            ? Icon(
                                                Icons.expand_less_rounded,
                                                color:
                                                    ColorConstant.primaryColor,
                                              )
                                            : Icon(
                                                Icons.expand_more_rounded,
                                                color:
                                                    ColorConstant.primaryColor,
                                              ),
                                      ),
                                state.qrData.code.isEmpty
                                    ? const SizedBox.shrink()
                                    : const Divider(),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      "Stones",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(),
                                qrResultStoneTable(
                                  context: context,
                                  state: state,
                                  stone1NameController: stone1NameController,
                                  stone1WeightController:
                                      stone1WeightController,
                                  stone1PriceController: stone1PriceController,
                                  stone2NameController: stone2NameController,
                                  stone2WeightController:
                                      stone2WeightController,
                                  stone2PriceController: stone2PriceController,
                                  stone3NameController: stone3NameController,
                                  stone3WeightController:
                                      stone3WeightController,
                                  stone3PriceController: stone3PriceController,
                                ),
                              ]),
                            ),
                            const Divider(),
//                             ExpectedAmount(
//                               controller: TextEditingController(text: state.qrData.expectedAmount),
//   total: state.qrData.total,
//   qrData: state.qrData,
//   onDiscountCalculated: (discount) {
//     // This will trigger the bloc event and calculations
//     state.qrData.expectedAmountDiscount = discount.toStringAsFixed(2);
//   },
//   onExpectedAmountEntered: (expected) {
//     state.qrData.expectedAmount = expected.toString();
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountChangedEvent(
//         state.qrData.expectedAmount, 
//         qrData: state.qrData
//       ),
//     );
//   }, 
// ),


                            ExpectedAmount(
                             // controller: expectedAmountController,
                             controller:TextEditingController(
                                text: state.qrData.expectedAmount),
                              total: state.qrData.total,
                              qrData: state.qrData, // Pass the qrData object
                              onDiscountCalculated: (discount) {
                                setState(() {
                                  state.qrData.expectedAmountDiscount =
                                      (discount).toStringAsFixed(2); // ⭐ Store saved discount
                                });
                              },
                              onExpectedAmountEntered: (expected) {
                                state.qrData.expectedAmount =
                                    expected.toString();
                                BlocProvider.of<QrResultBloc>(context).add(
                                  QrResultExpectedAmountChangedEvent( state.qrData.expectedAmount, qrData: state.qrData),
                                 // QrResultExpectedAmountChangedEvent(
                                      //state.qrData as String, qrData: state.qrData),
                                );
                              }, 
                            ),

                            //  ExpectedAmountPage(
                            //   controller: expectedAmountController,
                            //   //total: state.qrData.total,
                            //   qrData: state.qrData, // Pass the qrData object

                            //   onExpectedAmountEntered: (expected) {
                            //     state.qrData.expectedAmount =
                            //         expected.toString();
                            //     BlocProvider.of<QrResultBloc>(context).add(
                            //       //QrResultExpectedAmountChangedEvent( state.qrData.expectedAmount, qrData: state.qrData),
                            //       QrResultExpectedAmountChangedEvent(
                            //           state.qrData as String, qrData: state.qrData),
                            //     );
                            //   }, discount: state.qrData.expectedAmountDiscount,
                            // ),


                            
                            const Divider(),
                            BlocBuilder<QrResultBloc, QrResultState>(
                              buildWhen: (previous, current) =>
                                  current is QrResultPriceChangedState ||
                                  current is QrResultInitialState,
                              builder: (context, state) {
                                if (state is QrResultPriceChangedState) {
                                  final qr = state.qrData;

                                  return LuxuryCalculationPage(
                                    baseAmount: qr.baseAmount,
                                    nonTaxableAmount: qr.nonTaxableAmount,
                                    taxableAmount: qr.taxableAmount,
                                    luxuryAmount: qr.luxuryAmount,
                                    total: qr.total,
                                    qrData: state.qrData,
                                  );
                                } else if (state is QrResultInitialState) {
                                  final qr = state.qrData;

                                  return LuxuryCalculationPage(
                                    baseAmount: qr.baseAmount,
                                    nonTaxableAmount: qr.nonTaxableAmount,
                                    taxableAmount: qr.taxableAmount,
                                    luxuryAmount: qr.luxuryAmount,
                                    total: qr.total,
                                    qrData: state.qrData,
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 4,
                            ),
                            state.qrData.code.isEmpty
                                ? const SizedBox.shrink()
                                : addToCartCard(
                                    title: state.isUpdate
                                        ? "Update Item"
                                        : "Add to Cart",
                                    width: width * 6,
                                    onTap: () async {
                                      var qrBloc =
                                          BlocProvider.of<QrResultBloc>(
                                              context);

                                      qrBloc.add(QrResultOnLoadingEvent(
                                          isLoading: true));
                                      var bloc =
                                          BlocProvider.of<JewelleryOrderBloc>(
                                              context);
                                      if (!await checkInternetConnection()) {
                                        customToast("No Internet Connection",
                                            ColorConstant.errorColor);
                                        qrBloc.add(QrResultOnLoadingEvent(
                                            isLoading: false));
                                        return;
                                      }
                                      if (ItemsMaterialsDataRepository()
                                              .items
                                              .isEmpty ||
                                          ItemsMaterialsDataRepository()
                                              .materials
                                              .isEmpty) {
                                        bool res =
                                            await ItemsMaterialsDataRepository()
                                                .initialize();
                                        if (res == false) {
                                          qrBloc.add(QrResultOnLoadingEvent(
                                              isLoading: false));
                                          customToast("Error Loading Data",
                                              ColorConstant.errorColor);
                                          return;
                                        }
                                      }

                                      if (_formKey.currentState!.validate()) {
                                        QrDataModel orderedItem = state.qrData;
                                        if (orderedItem.itemId == 0) {
                                          final result = await findValidItemId(
                                              code: orderedItem.code);
                                          orderedItem.itemId = result['itemId'];
                                          orderedItem.materialId =
                                              result['materialId'];
                                          orderedItem.pcs = result['pcs'];
                                          if (orderedItem.itemId == 0) {
                                            qrBloc.add(QrResultOnLoadingEvent(
                                                isLoading: false));
                                            return;
                                          }
                                        }

                                        orderedItem.stone1Id = findValidId(
                                            name: orderedItem.stone1Name,
                                            listOfItems:
                                                ItemsMaterialsDataRepository()
                                                    .materials,
                                            errorMessage: "Invalid Stone Name");
                                        orderedItem.stone2Id = findValidId(
                                            name: orderedItem.stone2Name,
                                            listOfItems:
                                                ItemsMaterialsDataRepository()
                                                    .materials,
                                            errorMessage: "Invalid Stone Name");
                                        orderedItem.stone3Id = findValidId(
                                            name: orderedItem.stone3Name,
                                            listOfItems:
                                                ItemsMaterialsDataRepository()
                                                    .materials,
                                            errorMessage: "Invalid Stone Name");

                                        if (orderedItem.stone1Name.isNotEmpty &&
                                            orderedItem.stone1Id == 0) {
                                          qrBloc.add(QrResultOnLoadingEvent(
                                              isLoading: false));
                                          return;
                                        }
                                        if (orderedItem.stone2Name.isNotEmpty &&
                                            orderedItem.stone2Id == 0) {
                                          qrBloc.add(QrResultOnLoadingEvent(
                                              isLoading: false));
                                          return;
                                        }
                                        if (orderedItem.stone3Name.isNotEmpty &&
                                            orderedItem.stone3Id == 0) {
                                          qrBloc.add(QrResultOnLoadingEvent(
                                              isLoading: false));
                                          return;
                                        }

                                        if (orderedItem.id.isNotEmpty &&
                                            state.isUpdate == false) {
                                          customToast(
                                              "Item Already added! Please scan qr to add again",
                                              ColorConstant.errorColor);
                                          qrBloc.add(QrResultOnLoadingEvent(
                                              isLoading: false));
                                          return;
                                        }

                                        if (orderedItem.id.isEmpty) {
                                          orderedItem.id = const Uuid().v1();
                                        }

                                        bloc.add(AddJewelleryOrderEvent(
                                            orderedItem));
                                        if (state.isUpdate) {
                                          customToast(
                                            "Item Updated Successfully",
                                            ColorConstant.primaryColor,
                                          );
                                        } else {
                                          customToast(
                                            "Item Added Successfully",
                                            ColorConstant.primaryColor,
                                          );
                                        }
                                      }
                                      qrBloc.add(QrResultOnLoadingEvent(
                                          isLoading: false));
                                      return;
                                    },
                                  ),
                            const SizedBox(height: 15),
                            state.qrData.code.isEmpty
                                ? const SizedBox.shrink()
                                : DiscountSummaryWidget(
                                    qrData: state.qrData,
                                    originalQrData: originalQrData,
                                  ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                    state.qrData.code.isEmpty
                        ? const SizedBox.shrink()
                        : Positioned(
                            right: 0,
                            top: MediaQuery.of(context).size.height * 0.4,
                            child: Stack(
                              children: [
                                FloatingActionButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  )),
                                  onPressed: () async {
                                    var nav = Navigator.of(context);
                                    var qrBloc =
                                        BlocProvider.of<QrResultBloc>(context);
                                    qrBloc.add(QrResultOnLoadingEvent(
                                        isLoading: true));
                                    var bloc =
                                        BlocProvider.of<JewelleryOrderBloc>(
                                            context);
                                    if (bloc.state.jewelleryOrders.isEmpty) {
                                      return;
                                    }

                                    if (!prefs.containsKey("accessToken") ||
                                        !prefs.containsKey("refreshToken")) {
                                      nav.push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );

                                      qrBloc.add(QrResultOnLoadingEvent(
                                          isLoading: false));
                                      return;
                                    }
                                    if (prefs.getString("accessToken") == "" ||
                                        prefs.getString("refreshToken") == "") {
                                      nav.push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                      qrBloc.add(QrResultOnLoadingEvent(
                                          isLoading: false));
                                      return;
                                    }
                                    if (!await HelperHandleToken().isValid()) {
                                      nav.push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                      qrBloc.add(QrResultOnLoadingEvent(
                                          isLoading: false));
                                      return;
                                    }

                                    if (bloc.state.paymentModes.isEmpty ||
                                        bloc.state.cashiers.isEmpty) {
                                      if (await checkInternetConnection()) {
                                        bloc.add(PaymentModeLoadEvent());
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        qrBloc.add(QrResultOnLoadingEvent(
                                            isLoading: false));
                                        if (bloc.state.paymentModes.isEmpty ||
                                            bloc.state.cashiers.isEmpty) {
                                          customToast(
                                              "Error Loading Payment Modes",
                                              ColorConstant.errorColor);
                                          return;
                                        }
                                      } else {
                                        customToast("No Internet Connection",
                                            ColorConstant.errorColor);
                                        return;
                                      }
                                    }
                                    qrBloc.add(QrResultOnLoadingEvent(
                                        isLoading: false));
                                    nav.push(MaterialPageRoute(
                                      builder: (context) => const BillPage(),
                                    ));
                                  },
                                  backgroundColor: ColorConstant.primaryColor,
                                  child: const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: ColorConstant.errorColor,
                                    ),
                                    child: BlocBuilder<JewelleryOrderBloc,
                                        JewelleryOrderLoadedState>(
                                      builder: (context, state) {
                                        return Center(
                                          child: Text(
                                            state.jewelleryOrders.length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Positioned(
                      child: BlocBuilder<QrResultBloc, QrResultState>(
                        buildWhen: (current, previous) =>
                            current is QrResultOnLoadingState ||
                            current is QrResultInitialState,
                        builder: (context, state) {
                          if (state is QrResultOnLoadingState) {
                            return state.isLoading
                                ? refreshIndicator()
                                : const SizedBox.shrink();
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          } //if
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      }//builder
    );
  }//build
}//_ QrResultState
