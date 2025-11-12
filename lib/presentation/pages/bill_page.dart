import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/Order/jewellery_order_bloc.dart';
import 'package:jjewellery/data/command/add_bill.dart';
import 'package:jjewellery/presentation/pages/login_page.dart';

import 'package:jjewellery/presentation/pages/tabbar_view_page.dart';

import 'package:jjewellery/presentation/widgets/Global/appbar.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';

import 'package:jjewellery/utils/color_constant.dart';

import '../../helper/helper_functions.dart';
import '../../helper/helper_handle_token.dart';
import '../../main_common.dart';
import '../widgets/BillPage/custom_expansion_tile.dart';
import '../widgets/BillPage/customer_details_form.dart';

import '../widgets/QrResult/add_to_cart_card.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  final billKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> karatSettings = [];
  int userId = 0;

  bool isResponse = false;

  Future<void> initializeSettings() async {
    karatSettings = await db.rawQuery("SELECT * FROM KaratSettings");
  }

  @override
  void initState() {
    super.initState();
    if (prefs.containsKey("accessToken")) {
      userId = getUserId(token: prefs.getString("accessToken")!);
    } else {
      userId = 0;
    }
    if (BlocProvider.of<JewelleryOrderBloc>(context).state.cashiers.isEmpty ||
        BlocProvider.of<JewelleryOrderBloc>(context)
            .state
            .paymentModes
            .isEmpty) {
      BlocProvider.of<JewelleryOrderBloc>(context).add(PaymentModeLoadEvent());
      customToast(
        "Server Error",
        ColorConstant.errorColor,
      );
      Navigator.of(context).pop();
      return;
    }
    initializeSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const MyAppbar(
          isHomeWidget: false,
        ),
        resizeToAvoidBottomInset: true,
        body: isResponse
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<JewelleryOrderBloc,
                          JewelleryOrderLoadedState>(
                        builder: (context, state) {
                          if (state.jewelleryOrders.isNotEmpty) {
                            return Column(
                              children: [
                                ...state.jewelleryOrders.map(
                                  (data) => customExpansionTile(
                                    context,
                                    data,
                                    karatSettings,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Center(
                                child: Text(
                                  'No orders available !',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstant.errorColor),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      customerDetailsForm(
                        context: context,
                        billKey: billKey,
                        cashierId: userId,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            addToCartCard(
                              width: MediaQuery.of(context).size.width * 0.45,
                              onTap: () {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) =>
                                      TabbarViewPage(isScanned: false),
                                ));

                                BlocProvider.of<JewelleryOrderBloc>(context)
                                    .add(ClearJewelleryOrderEvent());
                              },
                              title: "Cancel Order",
                              bgColor: ColorConstant.errorColor,
                            ),
                            addToCartCard(
                                title: "Place Order",
                                width: MediaQuery.of(context).size.width * 0.45,
                                onTap: () async {
                                  var nav = Navigator.of(context);
                                  var bloc =
                                      BlocProvider.of<JewelleryOrderBloc>(
                                          context);
                                  if (bloc.state.jewelleryOrders.isEmpty) {
                                    customToast(
                                      "No orders found",
                                      ColorConstant.errorColor,
                                    );
                                    return;
                                  }
                                  if (!billKey.currentState!.validate()) {
                                    return;
                                  }

                                  if (bloc.state.totalAmount !=
                                      bloc.state.totalBill -
                                          bloc.state.discount -
                                          bloc.state.oldJewellery) {
                                    customToast(
                                        "Payment Mismatched: Rs. ${(bloc.state.totalBill - bloc.state.discount - bloc.state.oldJewellery) - bloc.state.totalAmount} ",
                                        ColorConstant.errorColor);
                                    return;
                                  }

                                  if (bloc.state.selectedCashier == null) {
                                    bloc.add(CashierEmptyEvent());
                                    return;
                                  }

                                  setState(() {
                                    isResponse = true;
                                  });
                                  if (!await HelperHandleToken().isValid()) {
                                    setState(() {
                                      isResponse = false;
                                    });
                                    nav.push(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );

                                    return;
                                  }

                                  // ignore: use_build_context_synchronously
                                  final response = await addBill(bloc, context);

                                  if (response.isSuccess) {
                                    customToast("Order placed successfully",
                                        ColorConstant.primaryColor);
                                    nav.popUntil((route) => route.isFirst);
                                    nav.pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          TabbarViewPage(isScanned: false),
                                    ));
                                    bloc.add(ClearJewelleryOrderEvent());
                                  } else {
                                    setState(() {
                                      isResponse = false;
                                    });
                                    customToast(response.errorMessage,
                                        ColorConstant.errorColor);
                                  }
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
        // floatingActionButton: isResponse
        //     ? const SizedBox()
        //     : FloatingActionButton(
        //         backgroundColor: Colors.white,
        //         onPressed: () => Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => OldJewelleryPage(),
        //           ),
        //         ),
        //         child: Icon(Icons.diamond, color: ColorConstant.primaryColor),
        //       ),
      ),
    );
  }
}
