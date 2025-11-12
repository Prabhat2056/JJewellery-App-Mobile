import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/OldJewellery/old_jewellery_bloc.dart';

import '../../../bloc/Order/jewellery_order_bloc.dart';

import '../../../utils/color_constant.dart';
import '../../pages/old_jewellery_page.dart';
import '../Global/custom_error_message.dart';
import '../Global/divider.dart';
import '../Global/form_field_column.dart';
import '../home/dropdown.dart';

Widget customerDetailsForm({context, billKey, cashierId}) {
  final TextEditingController oldJewelleryAmountController =
      TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: billKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader("Customer Details"),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: formFieldColumn(
                    label: "Name",
                    validator: (value) {
                      return value!.isEmpty ? 'Name Required' : null;
                    },
                    onChange: (value) {
                      BlocProvider.of<JewelleryOrderBloc>(context)
                          .add(CustomerNameChangedEvent(value));
                    },
                    initialValue: BlocProvider.of<JewelleryOrderBloc>(context)
                        .state
                        .customerName),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: formFieldColumn(
                    label: "Address",
                    validator: (value) {
                      return value!.isEmpty ? 'Address Required' : null;
                    },
                    onChange: (value) {
                      BlocProvider.of<JewelleryOrderBloc>(context)
                          .add(CustomerAddressChangedEvent(value));
                    },
                    initialValue: BlocProvider.of<JewelleryOrderBloc>(context)
                        .state
                        .customerAddress),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: formFieldColumn(
                    label: "Phone",
                    validator: (value) {
                      return value!.isEmpty ? 'Phone number Required' : null;
                    },
                    onChange: (value) {
                      BlocProvider.of<JewelleryOrderBloc>(context)
                          .add(CustomerPhoneChangedEvent(value));
                    },
                    initialValue: BlocProvider.of<JewelleryOrderBloc>(context)
                        .state
                        .customerPhone),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: formFieldColumn(
                    label: "Pan",
                    validator: (value) {
                      return null;
                    },
                    onChange: (value) {
                      BlocProvider.of<JewelleryOrderBloc>(context)
                          .add(CustomerPanChangedEvent(value));
                    },
                    initialValue: BlocProvider.of<JewelleryOrderBloc>(context)
                        .state
                        .customerPan),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          divider(),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 85,
                child: Text(
                  "Total Bill",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.primaryColor,
                  ),
                ),
              ),
              BlocBuilder<JewelleryOrderBloc, JewelleryOrderLoadedState>(
                buildWhen: (previous, current) =>
                    previous.totalBill != current.totalBill,
                builder: (context, state) {
                  return Text(
                    ": Rs. ${int.parse(state.totalBill.toStringAsFixed(0))}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(children: [
            SizedBox(
              width: 70,
              child: Text(
                'Old Gold',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.errorColor,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              ": ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstant.errorColor,
                fontSize: 16,
              ),
            ),
            BlocBuilder<OldJewelleryBloc, OldJewelleryState>(
              buildWhen: (previous, current) =>
                  previous.oldJewelleryAmount != current.oldJewelleryAmount,
              builder: (context, state) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final updatedText =
                      state.oldJewelleryAmount.toStringAsFixed(0);
                  if (oldJewelleryAmountController.text != updatedText) {
                    oldJewelleryAmountController.text = updatedText;
                  }
                  BlocProvider.of<JewelleryOrderBloc>(context).add(
                      OldJewelleryChangedEvent(
                          oldJewelleryAmountController.text));
                });
                return Expanded(
                  child: TextFormField(
                    controller: oldJewelleryAmountController,
                    enabled: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                );
              },
            ),
            IconButton.filled(
              icon: Icon(Icons.diamond),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OldJewelleryPage(),
                ),
              ),
            )
          ]),
          const SizedBox(
            height: 8,
          ),
          Row(children: [
            SizedBox(
              width: 70,
              child: Text(
                'Discount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.errorColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              ": ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstant.errorColor,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: BlocProvider.of<JewelleryOrderBloc>(context)
                    .state
                    .discount
                    .toString(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) {
                  if (v.isEmpty) v = "0";
                  BlocProvider.of<JewelleryOrderBloc>(context).add(
                    DiscountChangedEvent(v),
                  );
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 85,
                child: Text(
                  "To Pay",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.errorColor,
                  ),
                ),
              ),
              BlocBuilder<JewelleryOrderBloc, JewelleryOrderLoadedState>(
                buildWhen: (previous, current) =>
                    previous.discount != current.discount ||
                    previous.totalBill != current.totalBill ||
                    previous.oldJewellery != current.oldJewellery,
                builder: (context, state) {
                  return Text(
                    ": Rs. ${int.parse((state.totalBill - state.discount - state.oldJewellery).toStringAsFixed(0))}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.errorColor,
                    ),
                  );
                },
              ),
            ],
          ),
          divider(),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 85,
                  child: Text(
                    "Paid ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                ),
                BlocBuilder<JewelleryOrderBloc, JewelleryOrderLoadedState>(
                  buildWhen: (previous, current) =>
                      previous.totalAmount != current.totalAmount,
                  builder: (context, state) {
                    return Text(
                      ": Rs. ${(int.parse(state.totalAmount.toStringAsFixed(0)))}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.primaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          divider(),

          const SizedBox(height: 16),
          // Payment Details Section
          _sectionHeader("Payment Details"),
          const SizedBox(height: 8),
          BlocBuilder<JewelleryOrderBloc, JewelleryOrderLoadedState>(
              buildWhen: (previous, current) =>
                  previous.paymentModes != current.paymentModes,
              builder: (context, state) {
                if (state.paymentModes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customErrorMessage("**Payment Details not found**"),
                  );
                }
                return Column(children: [
                  ...state.paymentModes.map((e) => Column(
                        children: [
                          _formFieldRow(
                              e.name, context, e.id, e.amount.toString()),
                          const SizedBox(height: 12),
                        ],
                      ))
                ]);
              }),
          divider(),
          const SizedBox(height: 8),
          CustomDropdown(
              title: "Cashier",
              cashierId: cashierId,
              onChanged: (value) {
                BlocProvider.of<JewelleryOrderBloc>(context).add(
                  OnCashierChangedEvent(value!),
                );
              }),
        ],
      ),
    ),
  );
}

/// Section Header Widget
Widget _sectionHeader(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: ColorConstant.primaryColor,
    ),
  );
}

/// Form Field Row (Label: TextField for Payment Details)
Widget _formFieldRow(
    String label, BuildContext context, int id, String amount) {
  return Row(
    children: [
      SizedBox(
        width: 70,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(width: 12),
      const Text(": "),
      Expanded(
        child: TextFormField(
          keyboardType: TextInputType.number,
          initialValue: amount,
          onChanged: (value) => BlocProvider.of<JewelleryOrderBloc>(context)
              .add(UpdatePaymentChangedEvent(paymentModeId: id, value: value)),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    ],
  );
}
