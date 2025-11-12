import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/Order/jewellery_order_bloc.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_error_message.dart';
import 'package:jjewellery/utils/color_constant.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final ValueChanged<String?> onChanged;
  final int cashierId;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.onChanged,
    required this.cashierId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 85,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Text(": "),
            Expanded(
              child: BlocBuilder<JewelleryOrderBloc, JewelleryOrderLoadedState>(
                buildWhen: (previous, current) =>
                    previous.cashiers != current.cashiers ||
                    previous.selectedCashier != current.selectedCashier,
                builder: (context, state) {
                  state.selectedCashier ??= cashierId != 0
                        ? state.cashiers
                            .firstWhere((c) => c.id == cashierId)
                            .name
                        : null;

                  return state.cashiers.isEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorConstant.errorColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: customErrorMessage("**Cashier not found**"),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: state.isCashierEmpty
                                    ? ColorConstant.errorColor
                                    : Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            underline: const SizedBox(),
                            iconEnabledColor: state.isCashierEmpty
                                ? ColorConstant.errorColor
                                : Colors.grey,
                            items: state.cashiers
                                .map((cashier) => DropdownMenuItem<String>(
                                      value: cashier.name,
                                      child: Text(cashier.name),
                                    ))
                                .toList(),
                            value: state.selectedCashier,
                            isExpanded: true,
                            dropdownColor: ColorConstant.scaffoldColor,
                            onChanged: onChanged,
                          ),
                        );
                },
              ),
            ),
          ],
        ),
        BlocBuilder<JewelleryOrderBloc, JewelleryOrderLoadedState>(
          buildWhen: (previous, current) =>
              previous.isCashierEmpty != current.isCashierEmpty,
          builder: (context, state) {
            if (state.isCashierEmpty) {
              return Text(
                "Cashier required",
                style: TextStyle(color: ColorConstant.errorColor, fontSize: 12),
              );
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
