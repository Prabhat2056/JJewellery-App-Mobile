import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/Order/jewellery_order_bloc.dart';
import 'package:jjewellery/presentation/pages/tabbar_view_page.dart';
import 'package:jjewellery/presentation/widgets/Global/divider.dart';

import '../../../bloc/QrResult/qr_result_bloc.dart';
import '../../../utils/color_constant.dart';

ExpansionTile customExpansionTile(context, data, karatSettings) {
  return ExpansionTile(
    shape: const Border(),
    leading: Icon(
      Icons.arrow_drop_down,
      color: ColorConstant.primaryColor,
    ),
    showTrailingIcon: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.item,
              style: TextStyle(
                color: ColorConstant.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.code,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                BlocProvider.of<QrResultBloc>(context).add(QrResultInitialEvent(
                  qrData: data,
                  // karatSettings: karatSettings,
                  isUpdate: true,
                ));

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TabbarViewPage(
                          isScanned: true,
                        )));
              },
              icon: Icon(
                Icons.edit,
                color: ColorConstant.primaryColor,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<JewelleryOrderBloc>(context)
                    .add(RemoveJewelleryOrderEvent(data));
              },
              icon: Icon(
                Icons.delete,
                color: ColorConstant.errorColor,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    ),
    subtitle: Text(
      "Rs. ${data.price}",
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6),
        child: Column(
          children: [
            divider(color: ColorConstant.primaryColor),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rowDetail("Rate", ": Rs. ${data.rate}"),
                        const SizedBox(height: 8),
                        rowDetail("Metal", ": ${data.metal}"),
                        const SizedBox(height: 8),
                        rowDetail("Gross wt", ": ${data.grossWeight} g"),
                        const SizedBox(height: 8),
                        rowDetail("Purity", ": ${data.purity}"),
                        const SizedBox(height: 8),
                        rowDetail("Net wt", ": ${data.netWeight} g"),
                        const SizedBox(height: 8),
                        rowDetail("Jyala", ": Rs.${data.jyala}"),
                        const SizedBox(height: 8),
                        rowDetail("Jarti", ": ${data.jarti} g"),
                      ],
                    ),
                  ),
                  (data.stone1Name == "" &&
                          data.stone2Name == "" &&
                          data.stone3Name == "")
                      ? const SizedBox.shrink()
                      : VerticalDivider(
                          thickness: 1,
                          color: ColorConstant.primaryColor,
                        ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data.stone1Name == ""
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "${data.stone1Name}",
                                      style: TextStyle(
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${data.stone1Weight} g"),
                                    Text("Rs. ${data.stone1Price}"),
                                    divider(color: ColorConstant.primaryColor),
                                  ]),
                        data.stone2Name == ""
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "${data.stone2Name}",
                                      style: TextStyle(
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${data.stone2Weight} g"),
                                    Text("Rs. ${data.stone2Price}"),
                                    divider(color: ColorConstant.primaryColor),
                                  ]),
                        data.stone3Name == ""
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "${data.stone3Name}",
                                      style: TextStyle(
                                          color: ColorConstant.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("${data.stone3Weight} g"),
                                    Text("Rs. ${data.stone3Price}"),
                                  ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            divider(color: ColorConstant.primaryColor),
          ],
        ),
      ),
    ],
  );
}

Widget rowDetail(label, data) {
  return Row(children: [
    SizedBox(width: 65, child: Text(label)),
    Text(data),
  ]);
}
